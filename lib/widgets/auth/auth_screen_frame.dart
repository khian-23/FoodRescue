import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class AuthScreenFrame extends StatelessWidget {
  const AuthScreenFrame({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.backgroundImage,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final String? backgroundImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (backgroundImage != null)
            Image.asset(backgroundImage!, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: backgroundImage == null
                  ? AppTheme.pageGlow
                  : LinearGradient(
                      colors: [
                        AppTheme.forest.withValues(alpha: 0.82),
                        AppTheme.forest.withValues(alpha: 0.52),
                        Colors.white.withValues(alpha: 0.92),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.forest.withValues(alpha: 0.90),
                                AppTheme.leaf.withValues(alpha: 0.82),
                                AppTheme.sand.withValues(alpha: 0.88),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: AppTheme.softShadow,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Icon(
                                  Icons.volunteer_activism,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                subtitle,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Card(
                          color: backgroundImage == null
                              ? null
                              : Colors.white.withValues(alpha: 0.58),
                          child: Padding(
                            padding: const EdgeInsets.all(22),
                            child: child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
