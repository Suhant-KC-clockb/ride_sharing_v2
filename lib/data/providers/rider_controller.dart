import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiderController extends StateNotifier<AsyncValue<dynamic>> {
  Ref ref;

  RiderController({
    required this.ref,
  }) : super(const AsyncData(null));
}

final riderController =
    StateNotifierProvider<RiderController, AsyncValue<dynamic>>((ref) {
  return RiderController(ref: ref);
});
