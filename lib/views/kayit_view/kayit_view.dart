import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:madenler_kasa_sistemi/app/router.dart';

class KayitView extends StatefulWidget {
  const KayitView({super.key});

  @override
  State<KayitView> createState() => _KayitViewState();
}

class _KayitViewState extends State<KayitView> {
  static const Color _beigeBackground = Color(0xFFF5F1E8);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscurePasswordAgain = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordAgainController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration({
    String? hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      border: const OutlineInputBorder(),
      prefixIconConstraints: const BoxConstraints(minWidth: 48),
      suffixIcon: suffixIcon,
      suffixIconConstraints: const BoxConstraints(minHeight: 48),
    );
  }

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoute.giris);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final tertiary = theme.colorScheme.tertiary;
    final labelStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );

    return Scaffold(
      backgroundColor: _beigeBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => _goBack(context),
                    icon: Icon(Icons.arrow_back_ios_new, color: tertiary),
                  ),
                ),
                Text(
                  'Değerli Maden Kasası',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Kayıt Olun',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Hesabınızı oluşturmak için bilgilerinizi girin',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: tertiary,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text('Ad Soyad', style: labelStyle),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          decoration: _fieldDecoration(
                            hintText: 'Adınız Soyadınız',
                          ).copyWith(
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: primary,
                            ),
                          ),
                          validator: (value) {
                            if ((value?.trim() ?? '').isEmpty) {
                              return 'Ad soyad girin.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Text('E-posta', style: labelStyle),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: _fieldDecoration(
                            hintText: 'ornek@email.com',
                          ).copyWith(
                            prefixIcon: Icon(
                              Icons.mail_outline,
                              color: primary,
                            ),
                          ),
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) {
                              return 'E-posta girin.';
                            }
                            if (!v.contains('@')) {
                              return 'Geçerli bir e-posta girin.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Text('Şifre', style: labelStyle),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          decoration: _fieldDecoration(
                            hintText: '••••••••',
                          ).copyWith(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: primary,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: tertiary,
                              ),
                            ),
                          ),
                          validator: (value) {
                            final v = value ?? '';
                            if (v.length < 6) {
                              return 'Şifre en az 6 karakter olmalı.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Text('Şifre tekrar', style: labelStyle),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordAgainController,
                          obscureText: _obscurePasswordAgain,
                          textInputAction: TextInputAction.done,
                          decoration: _fieldDecoration(
                            hintText: '••••••••',
                          ).copyWith(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: primary,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePasswordAgain =
                                      !_obscurePasswordAgain;
                                });
                              },
                              icon: Icon(
                                _obscurePasswordAgain
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: tertiary,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Şifreler eşleşmiyor.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.go(AppRoute.anasayfa);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.black,
                            minimumSize: const Size.fromHeight(44),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Kayıt Ol'),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                height: 1,
                                color: Colors.black.withValues(alpha: 0.12),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Text(
                                'veya',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: tertiary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                height: 1,
                                color: Colors.black.withValues(alpha: 0.12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Zaten hesabınız var mı? ',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: tertiary,
                                ),
                              ),
                              InkWell(
                                onTap: () => context.go(AppRoute.giris),
                                borderRadius: BorderRadius.circular(4),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    'Giriş yap',
                                    style: TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
