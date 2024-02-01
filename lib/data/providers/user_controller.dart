import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/data/models/error_response.dart';
import 'package:ridesharing/data/models/success_response.dart';
import 'package:ridesharing/data/repository/auth_repository.dart';
import 'package:ridesharing/data/repository/user_repository.dart';
import 'package:ridesharing/routes.dart';

class UserController extends StateNotifier<AsyncValue<dynamic>> {
  Ref ref;
  String? _phoneNumber;

  UserController({
    required this.ref,
  }) : super(const AsyncData(null));

  Future<Either<String, String>> login({required String otp}) async {
    state = const AsyncLoading();

    if (_phoneNumber == null) {
      return const Left("Phone number not provided");
    }

    final response = await ref
        .read(userRepositoryProvider)
        .login(otpCode: otp, phoneNumber: _phoneNumber!);

    if (response is ErrorResponse) {
      return Left(response.title);
    } else {
      print(response);
      ref.read(setAuthStateProvider.notifier).state = response;
      ref.read(setIsAuthenticatedProvider(true));
      ref.read(setAuthenticatedUserProvider(response['user']));

      final userType = response['user']['role'];
      var pathname = '';
      if (userType == "") {
        pathname = Pathname.signUp;
      } else if (userType == "user") {
        pathname = Pathname.userDashboard;
      } else if (userType == "rider") {
        pathname = Pathname.riderDashboard;
      }
      return Right(pathname);
    }
  }

  Future<Either<String, String>> registerPhone(
      {required String phoneNumber}) async {
    state = const AsyncLoading();
    _phoneNumber = phoneNumber;
    final response = await ref
        .read(userRepositoryProvider)
        .phoneNumberRegister(phoneNumber: phoneNumber);

    if (response is ErrorResponse) {
      return Left(response.title);
    } else if (response is SuccessResponse) {
      return Right(response.title);
    }
    return const Left("Something went wrong");
  }

  Future<Either<String, String>> registerUser(
      String name, String gender, String userType, File photo) async {

        


    return Left("Hello");
  }
}

final userControllerProvider =
    StateNotifierProvider<UserController, AsyncValue<dynamic>>((ref) {
  return UserController(ref: ref);
});
