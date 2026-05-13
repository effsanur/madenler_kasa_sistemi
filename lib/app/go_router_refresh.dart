import 'dart:async';

import 'package:flutter/foundation.dart';

/// [GoRouter.refreshListenable] için; auth akışı değişince yönlendirmeyi yeniler.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
