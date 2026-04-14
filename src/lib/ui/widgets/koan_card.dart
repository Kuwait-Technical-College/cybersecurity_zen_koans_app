import 'package:flutter/material.dart';

import '../../data/koan_model.dart';
import '../theme/colors.dart';

class KoanCard extends StatelessWidget {
  final KoanWithExplanation koan;

  const KoanCard({super.key, required this.koan});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBackground = isDark ? meditationBlue : lotusWhite;
    final cardContent = isDark ? saffronOrange : deepMaroon;
    final dividerColor = isDark
        ? saffronOrange.withValues(alpha: 0.3)
        : deepMaroon.withValues(alpha: 0.2);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 8,
      color: cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Koan text
            Text(
              koan.koanText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                height: 1.5,
                color: cardContent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: dividerColor, thickness: 1),
            ),
            const SizedBox(height: 8),
            // Technical explanation
            SizedBox(
              width: double.infinity,
              child: Text(
                koan.technicalExplanation,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: cardContent.withValues(alpha: 0.85),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Unique code
            Text(
              '#${koan.uniqueCode}',
              style: const TextStyle(
                fontSize: 12,
                color: zenGold,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
