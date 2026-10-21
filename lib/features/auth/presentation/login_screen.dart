import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../shared/presentation/feature_link.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FeaturePage(
      title: 'Login',
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.eco_rounded, size: 42, color: theme.colorScheme.primary),
            const SizedBox(height: AppSpacing.md),
            Text('Welcome back', style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Authentication is not connected in this foundation build.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            const AppTextField(
              label: 'Email address',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.mail_outline_rounded,
            ),
            const SizedBox(height: AppSpacing.md),
            const AppTextField(
              label: 'Password',
              obscureText: true,
              prefixIcon: Icons.lock_outline_rounded,
            ),
            const SizedBox(height: AppSpacing.lg),
            const FilledButton(onPressed: null, child: Text('Sign in')),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Continue to app preview'),
            ),
          ],
        ),
      ),
    );
  }
}
