import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            const _TopAppBar(),
            const _FilterChips(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: const [
                  _SectionHeader(title: 'Hoy'),
                  _TransactionItem(
                    icon: Icons.shopping_cart,
                    title: 'Supermercado XYZ',
                    subtitle: '14:32',
                    amount: '-\$12.50',
                    amountColor: Color(0xFFEF4444), // red-500
                    iconBgColor: Color(
                      0xFFE5E7EB,
                    ), // gray-200 (light) or gray-700 (dark)
                    iconColor: Color(0xFF1F2937), // gray-800
                  ),
                  SizedBox(height: 8),
                  _TransactionItem(
                    icon: Icons.music_note,
                    title: 'Spotify',
                    subtitle: '08:15',
                    amount: '-\$9.99',
                    amountColor: Color(0xFFEF4444),
                    iconBgColor: Color(0xFFE5E7EB),
                    iconColor: Color(0xFF1F2937),
                  ),
                  _SectionHeader(title: 'Ayer'),
                  _TransactionItem(
                    icon: Icons.account_balance,
                    title: 'Salario Mensual',
                    subtitle: 'Nómina',
                    amount: '+\$2,500.00',
                    amountColor: Color(0xFF22C55E), // green-500
                    iconBgColor: Color(0xFFE5E7EB),
                    iconColor: Color(0xFF1F2937),
                  ),
                  SizedBox(height: 8),
                  _TransactionItem(
                    icon: Icons.restaurant,
                    title: 'Restaurante El Sabor',
                    subtitle: '20:45',
                    amount: '-\$45.80',
                    amountColor: Color(0xFFEF4444),
                    iconBgColor: Color(0xFFE5E7EB),
                    iconColor: Color(0xFF1F2937),
                  ),
                  _SectionHeader(title: '15 de Octubre'),
                  _TransactionItem(
                    icon: Icons.local_gas_station,
                    title: 'Gasolinera Shell',
                    subtitle: '18:02',
                    amount: '-\$55.00',
                    amountColor: Color(0xFFEF4444),
                    iconBgColor: Color(0xFFE5E7EB),
                    iconColor: Color(0xFF1F2937),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopAppBar extends StatelessWidget {
  const _TopAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button (hidden in main nav, but shown in design)
          // Since this is a tab, we might not need a back button to "Home", but strictly following mockup:
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 24,
            ),
          ),
          Text(
            'Historial de Transacciones',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48, // 32px height + padding
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _Chip(label: 'Todos', isSelected: true),
          const SizedBox(width: 12),
          _Chip(label: 'Ingresos', isSelected: false),
          const SizedBox(width: 12),
          _Chip(label: 'Gastos', isSelected: false),
          const SizedBox(width: 12),
          _Chip(label: 'Servicios', isSelected: false),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _Chip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryColor
            : const Color(0xFF374151), // dark gray for unselected
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[300],
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;
  final Color iconBgColor;
  final Color iconColor;

  const _TransactionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
    required this.iconBgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF374151), // Darker gray for dark mode bg
              borderRadius: BorderRadius.circular(
                8,
              ), // Rounded square as per design
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
