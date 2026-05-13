import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:madenler_kasa_sistemi/app/router.dart';
import 'package:madenler_kasa_sistemi/app/state.dart';

class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  String _initials(User? user) {
    final name = user?.displayName?.trim();
    if (name != null && name.isNotEmpty) {
      final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name.length >= 2
          ? name.substring(0, 2).toUpperCase()
          : name[0].toUpperCase();
    }
    final email = user?.email ?? '';
    if (email.isNotEmpty) return email[0].toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final tertiary = theme.colorScheme.tertiary;
    final user = FirebaseAuth.instance.currentUser;
    final displayName =
        user?.displayName?.trim().isNotEmpty == true
            ? user!.displayName!.trim()
            : (user?.email ?? 'Kullanıcı');

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
                        _initials(user),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      displayName,
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
                          ValueListenableBuilder<List<MadenItem>>(
                            valueListenable: kasaItems,
                            builder: (context, items, child) {
                              double total = 0;
                              for (var item in items) {
                                total += item.unitPrice * item.quantity;
                              }
                              return Text(
                                '₺${total.toStringAsFixed(2)}',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              );
                            },
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
              icon: Icons.history,
              title: 'Log Kayıtları',
              subtitle: 'Son işlemleri gör',
              accentColor: Colors.orange.shade50,
              onTap: () async {
                final logs = await getLogs();
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Log Kayıtları'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: logs.isEmpty ? const Text('Henüz log bulunmuyor.') : ListView.builder(
                          shrinkWrap: true,
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            final parts = logs[index].split('|');
                            final time = parts[0];
                            final msg = parts.length > 1 ? parts[1] : '';
                            try {
                              final dt = DateTime.parse(time);
                              final formatted = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(msg, style: const TextStyle(fontSize: 14)),
                                subtitle: Text(formatted, style: const TextStyle(fontSize: 12)),
                              );
                            } catch (_) {
                              return ListTile(title: Text(logs[index]));
                            }
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Kapat'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            _profileMenuItem(
              context,
              icon: Icons.edit,
              title: 'Profili Düzenle',
              subtitle: '',
              accentColor: Colors.blue.shade50,
              onTap: () {
                final controller = TextEditingController(text: user?.displayName);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Profili Düzenle'),
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(labelText: 'Ad Soyad'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('İptal'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (user != null) {
                            await user.updateDisplayName(controller.text.trim());
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Profil güncellendi. Değişikliklerin yansıması için uygulamayı yeniden başlatın veya çıkış yapıp tekrar girin.')),
                              );
                            }
                          }
                        },
                        child: const Text('Kaydet'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _profileMenuItem(
              context,
              icon: Icons.exit_to_app,
              title: 'Çıkış Yap',
              subtitle: '',
              accentColor: Colors.red.shade50,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Çıkış Yap'),
                    content: const Text('Çıkış yapmak istediğinize emin misiniz?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Çıkış yapma'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                        onPressed: () async {
                          await addLog('Çıkış yapıldı.');
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.pop(context);
                            context.go(AppRoute.giris);
                          }
                        },
                        child: const Text('Çıkış yap'),
                      ),
                    ],
                  ),
                );
              },
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
