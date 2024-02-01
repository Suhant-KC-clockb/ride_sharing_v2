import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/constant/api.dart';
import 'package:http/http.dart' as http;
import 'package:ridesharing/data/models/error_response.dart';
import 'package:ridesharing/data/models/success_response.dart';

abstract class UserRepository {
  Future<dynamic> login({required String phoneNumber, required String otpCode});
  Future<dynamic> phoneNumberRegister({required String phoneNumber});
  Future<dynamic> Registeruser({
    required String name,
    required String gender,
    required String userType,
    required File photo,
  });
}

class UserRepositoryImpl implements UserRepository {
  late Dio _dio;

  UserRepositoryImpl() {
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
    } on DioException catch (ex) {
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
    } on DioException catch (ex) {
      return ErrorResponse(title: "Invalid Phone number");
    } catch (e) {
      return ErrorResponse(title: "Something went wrong");
    }
  }

  @override
  Future Registeruser(
      {required String name,
      required String gender,
      required String userType,
      required File photo}) async {
    try {
      String fileName = photo.path.split('/').last;
      FormData formData = FormData.fromMap({
        "picture": await MultipartFile.fromFile(photo.path, filename: fileName),
        "name": name,
        "gender": gender,
        "role": userType,
      });

      final response = await _dio.post(API.register, data: formData);

      print(response.statusCode);
      return response.data;
    } catch (e) {}
  }
}

final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  return UserRepositoryImpl();
});
