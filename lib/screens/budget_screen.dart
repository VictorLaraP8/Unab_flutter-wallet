import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BudgetScreen extends StatelessWidget {
  final int userId;

  const BudgetScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Presupuesto'),
        backgroundColor: AppTheme.backgroundDark,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart, size: 80, color: AppTheme.primaryColor),
            const SizedBox(height: 16),
            Text(
              'Detalle de Presupuesto',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aquí podrás ver un desglose detallado de tus gastos.',
              style: TextStyle(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
