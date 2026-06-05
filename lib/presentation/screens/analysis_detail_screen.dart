import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/injection.dart';
import '../../data/models/region.dart';
import '../viewmodels/analysis_viewmodel.dart';
import '../widgets/data_tile.dart';
import '../widgets/score_bar.dart';

class AnalysisDetailScreen extends StatelessWidget {
  final Region region;

  const AnalysisDetailScreen({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AnalysisViewModel>(),
      child: _DetailContent(region: region),
    );
  }
}

class _DetailContent extends StatefulWidget {
  final Region region;

  const _DetailContent({required this.region});

  @override
  State<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<_DetailContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalysisViewModel>().analyze(widget.region);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.region.name} · ${widget.region.state}'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Consumer<AnalysisViewModel>(
        builder: (context, vm, _) {
          if (vm.state == ViewState.idle || vm.state == ViewState.loading) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Consultando dados satelitais...'),
                ],
              ),
            );
          }

          if (vm.state == ViewState.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      vm.errorMessage ?? 'Erro desconhecido',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () =>
                          vm.analyze(widget.region),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ViewState.success
          final result = vm.result!;
          final sortedCrops = result.cropScores.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.region.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Score geral: ${result.overallScore.toStringAsFixed(0)}%',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _scoreColor(
                                    result.overallScore, context),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Dados Climáticos',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DataTile(
                        icon: Icons.thermostat,
                        label: 'Temperatura Média',
                        value: '${result.avgTemp}°C',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DataTile(
                        icon: Icons.umbrella,
                        label: 'Precipitação (7d)',
                        value: '${result.weeklyPrecipitation}mm',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DataTile(
                  icon: Icons.grass,
                  label: 'Umidade do Solo',
                  value:
                      '${(result.soilMoisture * 100).toStringAsFixed(1)}%',
                ),
                const SizedBox(height: 16),
                Text(
                  'Índice de Idealidade por Cultura',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...sortedCrops.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ScoreBar(cropName: e.key, score: e.value),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Análise: ${result.date.day}/${result.date.month}/${result.date.year} '
                    '${result.date.hour}:${result.date.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _scoreColor(double score, BuildContext context) {
    if (score >= 70) return Colors.green.shade700;
    if (score >= 40) return Colors.orange.shade700;
    return Colors.red.shade700;
  }
}
