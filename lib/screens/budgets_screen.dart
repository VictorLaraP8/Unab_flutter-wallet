import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _CategoryModel {
  String name;
  double spent;
  double limit;
  String icon;
  Color color;

  _CategoryModel({
    required this.name,
    required this.spent,
    required this.limit,
    required this.icon,
    required this.color,
  });
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  // Initial dummy data
  final List<_CategoryModel> _categories = [
    _CategoryModel(
      icon: '🍔',
      name: 'Alimentación',
      spent: 285,
      limit: 400,
      color: const Color(0xFF3B82F6), // Blue
    ),
    _CategoryModel(
      icon: '🚗',
      name: 'Transporte',
      spent: 45,
      limit: 150,
      color: const Color(0xFF10B981), // Green
    ),
    _CategoryModel(
      icon: '🎬',
      name: 'Ocio',
      spent: 180,
      limit: 200,
      color: const Color(0xFFF59E0B), // Orange
    ),
  ];

  void _showAddEditDialog({_CategoryModel? category, int? index}) {
    final isEditing = category != null;
    final nameController = TextEditingController(text: category?.name ?? '');
    final spentController = TextEditingController(
      text: category?.spent.toString() ?? '0',
    );
    final limitController = TextEditingController(
      text: category?.limit.toString() ?? '0',
    );

    // Preserve existing properties or set defaults
    String currentIcon = category?.icon ?? '✨';
    Color currentColor = category?.color ?? const Color(0xFF6366F1);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1E2F),
        title: Text(
          isEditing ? 'Editar Categoría' : 'Nueva Categoría',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogInput(nameController, 'Nombre (ej. Ropa)'),
            const SizedBox(height: 12),
            _buildDialogInput(spentController, 'Gastado', isNumber: true),
            const SizedBox(height: 12),
            _buildDialogInput(limitController, 'Límite', isNumber: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final spent = double.tryParse(spentController.text) ?? 0.0;
              final limit = double.tryParse(limitController.text) ?? 0.0;

              if (name.isNotEmpty) {
                setState(() {
                  if (isEditing && index != null) {
                    _categories[index] = _CategoryModel(
                      name: name,
                      spent: spent,
                      limit: limit,
                      icon: currentIcon,
                      color: currentColor,
                    );
                  } else {
                    _categories.add(
                      _CategoryModel(
                        name: name,
                        spent: spent,
                        limit: limit,
                        icon: '📦', // Default icon for new ones
                        color: const Color(0xFF818CF8), // Default color
                      ),
                    );
                  }
                });
                Navigator.pop(context);
              }
            },
            child: Text(isEditing ? 'Guardar' : 'Agregar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogInput(
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F121C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Presupuestos',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Controla tus gastos mensuales',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 32),
              const _BudgetSummaryCard(),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tus Categorías',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showAddEditDialog(),
                    icon: Icon(Icons.add, color: AppTheme.textSecondary),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._categories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GestureDetector(
                    onTap: () =>
                        _showAddEditDialog(category: category, index: index),
                    child: _CategoryItem(
                      icon: category.icon,
                      name: category.name,
                      spent: category.spent,
                      limit: category.limit,
                      color: category.color,
                    ),
                  ),
                );
              }),
              // Add space at bottom
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _BudgetSummaryCard extends StatelessWidget {
  const _BudgetSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F121C), // Dark card background
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL GASTADO',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2230),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '+12% vs mes ant.',
                  style: TextStyle(
                    color: Color(0xFF4ADE80),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '\$559',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 1),
                      FlSpot(1, 2.5),
                      FlSpot(2, 2.0),
                      FlSpot(3, 3.5),
                      FlSpot(4, 2.2),
                      FlSpot(5, 4.5),
                      FlSpot(6, 1.5),
                    ],
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
                    ),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) =>
                          spot.x == 4, // Show dot at x=4
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 5,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: const Color(0xFF6366F1),
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6366F1).withValues(alpha: 0.3),
                          const Color(0xFF6366F1).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6366F1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Total presupuestado: \$800',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Text(
                'Editar Plan',
                style: TextStyle(
                  color: const Color(0xFF818CF8),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String icon;
  final String name;
  final double spent;
  final double limit;
  final Color color;

  const _CategoryItem({
    required this.icon,
    required this.name,
    required this.spent,
    required this.limit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double remaining = limit - spent;
    final double percentage = (spent / limit).clamp(0.0, 1.0);
    final int percentageInt = (percentage * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F121C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C2230),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(icon, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gastado: \$${spent.toInt()}',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${remaining.toInt()}',
                    style: TextStyle(
                      color: const Color(0xFF818CF8),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'RESTANTE',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1C2230),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$percentageInt% utilizado',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              Text(
                'Límite: \$${limit.toInt()}',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
