import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/bauhaus_theme.dart';

class MainShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final b = context.bauhaus;

    final tabs = [
      (
        label: 'Accueil',
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        accent: b.pastelRed,
      ),
      (
        label: 'Vocabulaire',
        icon: Icons.list_alt_outlined,
        activeIcon: Icons.list_alt_rounded,
        accent: b.pastelBlue,
      ),
      (
        label: 'Référentiel',
        icon: Icons.menu_book_outlined,
        activeIcon: Icons.menu_book_rounded,
        accent: b.pastelYellow,
      ),
      (
        label: 'Domaines',
        icon: Icons.auto_stories_outlined,
        activeIcon: Icons.auto_stories_rounded,
        accent: b.pastelMint,
      ),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: b.cardSurface,
          border: Border(
            top: BorderSide(color: b.slate, width: 1.5),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: List.generate(tabs.length, (index) {
                final tab = tabs[index];
                final isSelected = navigationShell.currentIndex == index;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => navigationShell.goBranch(
                        index,
                        initialLocation: index == navigationShell.currentIndex,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 140),
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? tab.accent : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? b.slate : Colors.transparent,
                            width: 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: b.slate,
                                    offset: const Offset(2, 2),
                                    blurRadius: 0,
                                  ),
                                ]
                              : const [],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isSelected ? tab.activeIcon : tab.icon,
                              size: 20,
                              color: b.slate,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              tab.label.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 0.4,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected
                                    ? b.slate
                                    : b.slate.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
