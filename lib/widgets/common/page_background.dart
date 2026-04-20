import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class PageBackground extends StatelessWidget {
  const PageBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppTheme.pageGlow,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.16),
                      Colors.transparent,
                      AppTheme.sage.withValues(alpha: 0.12),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -90,
            right: -20,
            child: _GlowOrb(
              size: 220,
              color: AppTheme.sand.withValues(alpha: 0.34),
            ),
          ),
          Positioned(
            top: 110,
            left: -55,
            child: _GlowOrb(
              size: 170,
              color: AppTheme.sage.withValues(alpha: 0.48),
            ),
          ),
          Positioned(
            bottom: -70,
            right: 40,
            child: _GlowOrb(
              size: 160,
              color: AppTheme.leaf.withValues(alpha: 0.10),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
