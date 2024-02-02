// ignore: constant_identifier_names
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

const IS_AUTHENTICATED_KEY = 'IS_AUTHENTICATED_KEY';
const TOKEN = "TOKEN";
const AUTHENTICATED_USER_EMAIL_KEY = 'AUTHENTICATED_USER_EMAIL_KEY';

final sharedPrefProvider = Provider((_) async {
  return await SharedPreferences.getInstance();
});

final storedToken = Provider<String?>((ref) => null);

final setAuthStateProvider = StateProvider<dynamic?>(
  (ref) => null,
);

final setIsAuthenticatedProvider = StateProvider.family<void, bool>(
  (ref, isAuth) async {
    final prefs = await ref.watch(sharedPrefProvider);
    ref.watch(setAuthStateProvider);
    prefs.setBool(
      IS_AUTHENTICATED_KEY,
      isAuth,
    );
  },
);

final setToken = StateProvider.family<void, String>(
  (ref, token) async {
    final prefs = await ref.watch(sharedPrefProvider);
    ref.watch(setAuthStateProvider);
    prefs.setString(
      TOKEN,
      jsonEncode(token),
    );
  },
);

final getToken = FutureProvider<String?>(
  (ref) async {
    final prefs = await ref.watch(sharedPrefProvider);
    ref.watch(setAuthStateProvider);
    return json.decode(prefs.getString(TOKEN) ?? "null");
  },
);

final setAuthenticatedUserProvider = StateProvider.family<void, dynamic>(
  (ref, userdata) async {
    final prefs = await ref.watch(sharedPrefProvider);
    ref.watch(setAuthStateProvider);
    prefs.setString(
      AUTHENTICATED_USER_EMAIL_KEY,
      json.encode(userdata),
    );
  },
);

final getIsAuthenticatedProvider = FutureProvider<bool>(
  (ref) async {
    final prefs = await ref.watch(sharedPrefProvider);
    ref.watch(setAuthStateProvider);
    return prefs.getBool(IS_AUTHENTICATED_KEY) ?? false;
  },
);

final getAuthenticatedUserProvider = FutureProvider<User>(
  (ref) async {
    final prefs = await ref.watch(sharedPrefProvider);
    ref.watch(setAuthStateProvider);
    ref.watch(getToken);
    dynamic user =
        json.decode(prefs.getString(AUTHENTICATED_USER_EMAIL_KEY) ?? "");
    return User.fromJson(user);
  },
);

// Todo: Handle logout or and reset
final resetStorage = StateProvider<dynamic>(
  (ref) async {
    final prefs = await ref.watch(sharedPrefProvider);
    final isCleared = await prefs.clear();
    return isCleared;
  },
);
