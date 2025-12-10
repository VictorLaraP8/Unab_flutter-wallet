import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 3,
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuAZ8uu6mSmKmKwm9M9t9C8x7VQ6KxULfpoBJz4psbC5_xdZmzKJRzJTxp8BRonoGA3yVLcl4N1OWKeji3mh5YFCZzSp8Wb5Z1cBZ3xGfJ7iTRdeaisOeljvcrGXPF4zw5wJmc7riTtHZ-XydsvRbuPuwQDjWEGWKhxxhK67JcmJLRBy5s38qg-9bXVLK88BgLrnIcnGzLVDYWzIKlMFvUKLBtNvVcmgmE_3BqHD5DvnxxInKqPmSqJFfBiIU37g_FqtpLfyxtnOAZpX',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Vito Corleone',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'vito@corleone.it',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Settings Options
              _buildSectionTitle('General'),
              const SizedBox(height: 16),
              _buildSettingsTile(
                icon: Icons.person_outline,
                title: 'Editar Perfil',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notificaciones',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.wallet_outlined,
                title: 'Métodos de Pago',
                onTap: () {},
              ),

              const SizedBox(height: 32),
              _buildSectionTitle('Seguridad'),
              const SizedBox(height: 16),
              _buildSettingsTile(
                icon: Icons.lock_outline,
                title: 'Cambiar Contraseña',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.fingerprint,
                title: 'Biometría',
                isSwitch: true,
                onTap: () {},
              ),

              const SizedBox(height: 40),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                     Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.deepOrangeAccent),
                  label: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.deepOrangeAccent.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    bool isSwitch = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: isSwitch ? null : onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.backgroundDark,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        trailing: isSwitch
            ? Switch(
                value: true,
                activeTrackColor: AppTheme.primaryColor,
                onChanged: (val) {},
              )
            : Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.textSecondary,
                size: 16,
              ),
      ),
    );
  }
}
