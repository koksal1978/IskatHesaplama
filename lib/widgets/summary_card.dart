import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Başlık, alt başlık ve İslami geometrik motif esintili üst kart.
class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppConstants.primaryGreenDark,
            AppConstants.primaryGreen,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.goldAccent.withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryGreenDark.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Üst hilal ve yıldız süsleme ikonu
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 1,
                width: 30,
                color: AppConstants.goldAccentLight.withValues(alpha: 0.6),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.nightlight_round,
                  color: AppConstants.goldAccent,
                  size: 22,
                ),
              ),
              Container(
                height: 1,
                width: 30,
                color: AppConstants.goldAccentLight.withValues(alpha: 0.6),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Başlık
          const Text(
            AppConstants.appTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),

          // Alt Başlık
          Text(
            AppConstants.appSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppConstants.goldAccentLight.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
