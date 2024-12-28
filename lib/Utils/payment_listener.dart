import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class TransferListener {
  final String uuid;
  late DatabaseReference _transferRef;
  StreamSubscription? _subscription;
  Timer? _timeoutTimer;

  TransferListener(this.uuid) {
    _transferRef = FirebaseDatabase.instance.ref('driver/$uuid/transaction');
  }

  void startListening({
    required Function(String key, dynamic amount) onNewTransfer,
    required Function onTimeout,
    required Function onCancel,
  }) async {
    // Set a timeout for 5 minutes
    _timeoutTimer = Timer(const Duration(minutes: 5), () {
      stopListening();
      onTimeout();
    });
    final processedKeys = <String>{};

    // Add pre-existing keys to the processed list
    await _transferRef.once().then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.exists) {
        final initialData = snapshot.snapshot.children;
        for (final child in initialData) {
          print(child.key);
          processedKeys.add(child.key ?? '');
        }
      }
    });

    // Listen to new keys being added
    _subscription = _transferRef.onChildAdded.listen((event) {
      final key = event.snapshot.key;
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      final amount = data?['amount'];

      if (key != null && !processedKeys.contains(key)) {
        processedKeys.add(key);

        print('KEY --->> $key');
        // Process the new key
        if (amount != null) {
          stopListening();
          onNewTransfer(key, amount);
        }
      }
    });
  }

  void stopListening() {
    // Cancel the listener and timer
    _subscription?.cancel();
    _timeoutTimer?.cancel();
  }
}
