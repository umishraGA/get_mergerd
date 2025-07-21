import 'package:flutter/material.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/common/widgets/TopAppBarCustom.dart';

class SpiritualScreen extends StatelessWidget {
  const SpiritualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TopAppBarCustom(isVisibleSearchBar: false),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'CHOOSE YOUR PRACTICE RELIGION',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                padding: EdgeInsets.zero,
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _ReligionCard(
                    title: 'HINDUISM',
                    iconPath: 'assets/images/spiritual/hinduism.png',
                    color: const Color(0xFFB25D4C),
                    onTap: () {
                      Navigator.pushNamed(context, '/spiritual/hinduism',
                          arguments: {
                            'bannerImage':
                                'assets/images/spiritual/backgrounds/hinduism_bg.png'
                          });
                    },
                  ),
                  _ReligionCard(
                    title: 'SIKHISM',
                    iconPath: 'assets/images/spiritual/sikhism.png',
                    color: const Color(0xFF407676),
                    onTap: () {
                      Navigator.pushNamed(context, '/spiritual/hinduism',
                          arguments: {
                            'bannerImage':
                                'assets/images/spiritual/backgrounds/sikhism_bg.png'
                          });
                    },
                  ),
                  _ReligionCard(
                    title: 'ISLAM',
                    iconPath: 'assets/images/spiritual/islam.png',
                    color: const Color(0xFF2D5240),
                    onTap: () {
                      Navigator.pushNamed(context, '/spiritual/islam',
                          arguments: {
                            'bannerImage':
                                'assets/images/spiritual/backgrounds/islam_bg.png'
                          });
                    },
                  ),
                  _ReligionCard(
                    title: 'BUDDHISM',
                    iconPath: 'assets/images/spiritual/budhism.png',
                    color: const Color(0xFF7D4B77),
                    onTap: () {
                      Navigator.pushNamed(context, '/spiritual/hinduism',
                          arguments: {
                            'bannerImage':
                                'assets/images/spiritual/backgrounds/buddhism_bg.png'
                          });
                    },
                  ),
                  _ReligionCard(
                    title: 'CHRISTIANITY',
                    iconPath: 'assets/images/spiritual/christianity.png',
                    color: const Color(0xFFA13B3B),
                    onTap: () {
                      Navigator.pushNamed(context, '/spiritual/hinduism',
                          arguments: {
                            'bannerImage':
                                'assets/images/spiritual/backgrounds/christianity_bg.png'
                          });
                    },
                  ),
                  _ReligionCard(
                    title: 'JAINISM',
                    iconPath: 'assets/images/spiritual/jainism.png',
                    color: const Color(0xFF6B4B3B),
                    onTap: () {
                      Navigator.pushNamed(context, '/spiritual/hinduism',
                          arguments: {
                            'bannerImage':
                                'assets/images/spiritual/backgrounds/jainism_bg.png'
                          });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReligionCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color color;
  final VoidCallback onTap;

  const _ReligionCard({
    required this.title,
    required this.iconPath,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              // // Back shadow
              BoxShadow(
                color: color.withOpacity(0.2),
                // offset: const Offset(4, 4),
                blurRadius: 10,
                spreadRadius: -2,
              ),
              // Main shadow
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                // offset: const Offset(0, 0),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.asset(
                  width: double.infinity,
                  height: double.infinity,
                  iconPath,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    title,
                    style: AppTextStyles.medium18.withColor(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
