import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentRoute;

  const TopNavigationBar({
    super.key,
    required this.currentRoute,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Row(
        children: [
          // Logo placeholder
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Image.asset(
              'assets/images/logo_placeholder.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if image doesn't load
                return Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Theme.of(context).primaryColor,
                      size: 32,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Angelic Solace',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Spacer(),
          // Navigation menu items
          _buildNavItem(context, 'Home', '/'),
          const SizedBox(width: 16),
          _buildNavItem(context, 'Services', '/services'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, String route) {
    final isActive = currentRoute == route;

    return TextButton(
      onPressed: () {
        if (!isActive) {
          context.go(route);
        }
      },
      style: TextButton.styleFrom(
        foregroundColor: isActive
            ? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.onSurface,
        backgroundColor: isActive
            ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
