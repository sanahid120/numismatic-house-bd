import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';

class MobileView extends StatelessWidget {
  const MobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1628527304948-06157ee3c8a6?q=80&w=2070&auto=format&fit=crop'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.forestDeep.withOpacity(0.9),
              AppColors.forestDeep.withOpacity(0.4),
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.brass.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.brass, width: 1),
              ),
              child: const Text(
                'UNC CONDITION',
                style: TextStyle(
                  color: AppColors.brass,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Preserving History,\nOne Note at a Time',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              width: 250,
              child: Text(
                'Exclusive authentic high-grade collectable banknotes.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brass,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('SHOP NOW', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
