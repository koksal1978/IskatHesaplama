import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Sayfanın altında yer alan zorunlu yasal ve dini bilgilendirme uyarısı.
class DisclaimerCard extends StatelessWidget {
  const DisclaimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.creamTint.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppConstants.goldAccent.withValues(alpha: 0.6),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppConstants.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              AppConstants.disclaimerText,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.45,
                color: AppConstants.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
