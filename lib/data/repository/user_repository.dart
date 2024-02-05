import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/constant/api.dart';
import 'package:ridesharing/data/models/error_response.dart';
import 'package:ridesharing/data/models/success_response.dart';
import 'package:ridesharing/data/repository/auth_repository.dart';

abstract class UserRepository {
  Future<dynamic> login({required String phoneNumber, required String otpCode});
  Future<dynamic> phoneNumberRegister({required String phoneNumber});
  Future<dynamic> registerUser({
    required String name,
    required String gender,
    required String userType,
    required File photo,
  });

  Future<dynamic> tokenExtraction();
}

class UserRepositoryImpl implements UserRepository {
  Ref ref;
  late Dio _dio;

  UserRepositoryImpl({required this.ref}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: API.baseUrl,
        responseType: ResponseType.json,
      ),
    );
  }

  @override
  Future login({required String phoneNumber, required String otpCode}) async {
    try {
      final response = await _dio.post(API.login, data: {
        "phone": phoneNumber,
        "otp": otpCode,
      });
      return response.data;
    } on DioException {
      return ErrorResponse(title: "OTP is not valid");
    } catch (e) {
      return "Error";
    }
  }

  @override
  Future phoneNumberRegister({required String phoneNumber}) async {
    try {
      final response = await _dio.post(API.registerPhone, data: {
        "phone": phoneNumber,
      });

      return SuccessResponse(title: response.data['message']);
    } on DioException {
      return ErrorResponse(title: "Invalid Phone number");
    } catch (e) {
      return ErrorResponse(title: "Something went wrong");
    }
  }

  @override
  Future registerUser(
      {required String name,
      required String gender,
      required String userType,
      required File photo}) async {
    try {
      String fileName = photo.path.split('/').last;

      final token = ref.watch(getToken).asData?.value;

      FormData formData = FormData.fromMap({
        "picture": await MultipartFile.fromFile(photo.path, filename: fileName),
        // "picture": photo,
        "name": name,
        "gender": gender,
        "role": userType,
      });

      final response = await _dio.post(
        API.register,
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      return response.data;
    } on DioException catch (ex) {
      return DynamicErrorResponse(data: ex.response?.data[0]['error']);
    } catch (e) {
      return ErrorResponse(title: "Server Error");
    }
  }

  @override
  Future tokenExtraction() async {
    String? token;
    ref.read(getToken).when(
          data: (data) {
            token = data;
          },
          error: (error, stackTrace) {},
          loading: () {},
        );
    return token;
  }
}

final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  return UserRepositoryImpl(ref: ref);
});
