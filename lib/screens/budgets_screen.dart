import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: const Center(
        child: Text('Budgets Screen', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
