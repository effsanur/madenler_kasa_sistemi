import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:madenler_kasa_sistemi/app/router.dart';

class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final tertiary = theme.colorScheme.tertiary;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: primary,
                      child: Text(
                        'AY',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Ahmet Yılmaz',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _profileStatCard(
                          label: 'Altın',
                          value: '248.5 gr',
                          icon: Icons.circle,
                          iconColor: Colors.amber.shade700,
                        ),
                        const SizedBox(width: 10),
                        _profileStatCard(
                          label: 'Gümüş',
                          value: '1.2 kg',
                          icon: Icons.circle,
                          iconColor: Colors.blueGrey.shade300,
                        ),
                        const SizedBox(width: 10),
                        _profileStatCard(
                          label: 'Platin',
                          value: '42.0 gr',
                          icon: Icons.circle,
                          iconColor: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Toplam Kasa Değeri',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: tertiary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₺1.842.560',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            _profileMenuItem(
              context,
              icon: Icons.notifications,
              title: 'Bildirimler',
              subtitle: '5 okunmamış',
              accentColor: Colors.orange.shade50,
            ),
            const SizedBox(height: 12),
            _profileMenuItem(
              context,
              icon: Icons.edit,
              title: 'Profili Düzenle',
              subtitle: '',
              accentColor: Colors.blue.shade50,
            ),
            const SizedBox(height: 12),
            _profileMenuItem(
              context,
              icon: Icons.exit_to_app,
              title: 'Çıkış Yap',
              subtitle: '',
              accentColor: Colors.red.shade50,
              onTap: () => context.go(AppRoute.giris),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accentColor,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.black87),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Colors.black45,
        ),
        onTap: onTap ?? () {},
      ),
    );
  }
}
