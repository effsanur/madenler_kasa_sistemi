import 'package:firebase_auth/firebase_auth.dart';

String messageForFirebaseAuth(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return 'E-posta veya şifre hatalı.';
    case 'invalid-email':
      return 'Geçersiz e-posta adresi.';
    case 'user-disabled':
      return 'Bu hesap devre dışı bırakılmış.';
    case 'email-already-in-use':
      return 'Bu e-posta ile zaten bir hesap var.';
    case 'weak-password':
      return 'Şifre çok zayıf. Daha güçlü bir şifre seçin.';
    case 'too-many-requests':
      return 'Çok fazla deneme yapıldı. Lütfen daha sonra tekrar deneyin.';
    case 'network-request-failed':
      return 'Ağ hatası. İnternet bağlantınızı kontrol edin.';
    case 'operation-not-allowed':
      return "Bu giriş yöntemi etkin değil. Firebase Console'da E-posta/Şifre açın.";
    default:
      return e.message?.isNotEmpty == true
          ? e.message!
          : 'Bir hata oluştu (${e.code}).';
  }
}
