import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ResultCard extends StatelessWidget {
  final IconData icon;
  final String typeLabel;
  final String value;
  final bool isUrl;

  const ResultCard({
    super.key,
    required this.icon,
    required this.typeLabel,
    required this.value,
    this.isUrl = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    // FIX: withOpacity → withValues(alpha:)
                    color: AppTheme.primaryMid.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: AppTheme.primaryDark),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan Result',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                    ),
                    Text(
                      typeLabel,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 15,
                                color: AppTheme.primaryDark,
                              ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    // FIX: withOpacity → withValues(alpha:)
                    color: AppTheme.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppTheme.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Scanned',
                        style: TextStyle(
                          color: AppTheme.success,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: AppTheme.divider, height: 1),
            const SizedBox(height: 14),
            Text(
              'Content',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 11, letterSpacing: 0.4),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                      height: 1.5,
                      color:
                          isUrl ? AppTheme.accent : AppTheme.textPrimary,
                      decoration:
                          isUrl ? TextDecoration.underline : null,
                      decorationColor: AppTheme.accent,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}