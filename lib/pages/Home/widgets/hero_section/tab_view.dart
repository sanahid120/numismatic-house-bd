import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';

class TabView extends StatelessWidget {
  const TabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1628527304948-06157ee3c8a6?q=80&w=2070&auto=format&fit=crop'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.forestDeep.withOpacity(0.9),
              AppColors.forestDeep.withOpacity(0.5),
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.brass.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.brass, width: 1),
              ),
              child: const Text(
                'UNC CONDITION GUARANTEED',
                style: TextStyle(
                  color: AppColors.brass,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Preserving History,\nOne Note at a Time',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 15),
            const SizedBox(
              width: 400,
              child: Text(
                'Explore our exclusive collection of authentic, high-grade collectable banknotes. Trusted by collectors across Bangladesh.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brass,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('SHOP NOW', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 15),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('DETAILS', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
