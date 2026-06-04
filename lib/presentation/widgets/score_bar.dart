import 'package:flutter/material.dart';

class ScoreBar extends StatelessWidget {
  final String cropName;
  final double score;

  const ScoreBar({super.key, required this.cropName, required this.score});

  Color _color() {
    if (score >= 70) return Colors.green.shade600;
    if (score >= 40) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cropName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${score.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _color(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: score / 100,
                minHeight: 8,
                backgroundColor: Theme.of(context).colorScheme.surface,
                valueColor: AlwaysStoppedAnimation<Color>(_color()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
