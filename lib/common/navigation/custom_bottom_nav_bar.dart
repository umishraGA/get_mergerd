import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final AnimationController? hideAnimationController;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.hideAnimationController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget bottomBar = Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEF3340),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _buildNavItem(
                  icon: 'assets/images/happening.png',
                  label: 'Happening',
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemTapped(0),
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  icon: 'assets/images/spirtual.png',
                  label: 'Spiritual',
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemTapped(1),
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  icon: 'assets/images/listings.png',
                  label: 'Listings',
                  isSelected: selectedIndex == 2,
                  onTap: () => onItemTapped(2),
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  icon: 'assets/images/utsav.png',
                  label: 'Utsav',
                  isSelected: selectedIndex == 3,
                  onTap: () => onItemTapped(3),
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  icon: 'assets/images/events.png',
                  label: 'Events',
                  isSelected: selectedIndex == 4,
                  onTap: () => onItemTapped(4),
                ),
              ),
              Expanded(
                child: _buildNavItemWithIcon(
                  icon: Icons.quiz,
                  label: 'Quiz',
                  isSelected: false,
                  onTap: () => onItemTapped(5),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // If we have an animation controller, wrap with an AnimatedBuilder
    if (hideAnimationController != null) {
      return AnimatedBuilder(
        animation: hideAnimationController!,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, hideAnimationController!.value * 150),
            child: child,
          );
        },
        child: bottomBar,
      );
    }

    return bottomBar;
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              width: 24,
              height: 24,
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItemWithIcon({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.white,
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
