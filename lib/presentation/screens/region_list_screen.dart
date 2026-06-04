import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/region.dart';
import '../viewmodels/region_list_viewmodel.dart';
import '../widgets/region_card.dart';
import 'analysis_detail_screen.dart';

class RegionListScreen extends StatelessWidget {
  const RegionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regiões Agrícolas'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Consumer<RegionListViewModel>(
        builder: (context, vm, _) {
          final sorted = [...vm.regions]..sort((a, b) {
              final af = vm.isFavorite(a.id) ? 0 : 1;
              final bf = vm.isFavorite(b.id) ? 0 : 1;
              return af.compareTo(bf);
            });

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sorted.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final region = sorted[index];
              return RegionCard(
                region: region,
                isFavorite: vm.isFavorite(region.id),
                onFavoriteToggle: () => vm.toggleFavorite(region.id),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AnalysisDetailScreen(region: region),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
