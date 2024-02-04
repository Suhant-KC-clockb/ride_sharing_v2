import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/constant/api.dart';
import 'package:ridesharing/data/models/error_response.dart';
import 'package:ridesharing/data/repository/auth_repository.dart';

abstract class RiderRepository {
  //GET METHODS
  Future<dynamic> getCurrentRiderDetails();
  Future<dynamic> fetchRiderDetails();
  Future<dynamic> getVehicleInformation();
  Future<dynamic> getLicenseInformation();
  Future<dynamic> getBlueBookInformation();

  //POST METHODS
  Future<dynamic> postRiderVehicleDetail(
      {File? vehiclePhoto,
      required String licenseNumber,
      required String bikeDetail,
      required String numberPlate});
  Future<dynamic> postRiderLicenseDetail({File front, File holding});
}

class RiderRepositoryImpl implements RiderRepository {
  Ref ref;
  late Dio _dio;

  RiderRepositoryImpl({required this.ref}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: API.baseUrl,
        responseType: ResponseType.json,
      ),
    );
  }
  @override
  Future getCurrentRiderDetails() async {
    final response =
        await Future.delayed(Duration(seconds: 1), () => {"data": null});
    return ErrorResponse(title: "K ho rider ko detail barna birisis?");
  }

  @override
  Future getBlueBookInformation() async {
    final response =
        await Future.delayed(Duration(seconds: 3), () => {"data": null});
    return response;
  }

  @override
  Future getLicenseInformation() async {
    final response =
        await Future.delayed(Duration(seconds: 3), () => {"data": null});
    return response;
  }

  @override
  Future getVehicleInformation() async {
    final response =
        await Future.delayed(const Duration(seconds: 10), () => {"data": null});
    return response;
  }

  @override
  Future postRiderVehicleDetail(
      {File? vehiclePhoto,
      required String licenseNumber,
      required String bikeDetail,
      required String numberPlate}) async {
    try {
      final token = ref.watch(getToken).asData?.value;

      Map<String, dynamic?> formProcessing = {
        "license_number": licenseNumber,
        "transport_name": bikeDetail,
        "number_plate": numberPlate,
      };

      if (vehiclePhoto != null) {
        formProcessing.addEntries([
          MapEntry(
              "transport_img",
              await MultipartFile.fromFile(
                vehiclePhoto.path,
                filename: vehiclePhoto.path.split('/').last,
              )),
        ]);
      }

      FormData formData = FormData.fromMap(formProcessing);

      final response = await _dio.post(
        API.storeRiderDetail,
        // "API.storeRiderDetai",
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      return response;
    } on DioException catch (ex) {
      print(ex.response);
      return ErrorResponse(title: "Something went wrong");
    }
  }

  @override
  Future postRiderLicenseDetail({File? front, File? holding}) async {
    try {
      final token = ref.watch(getToken).asData?.value;

      Map<String, dynamic> formProcessing = {};

      if (front != null) {
        formProcessing.addEntries([
          MapEntry(
              "license_front_img",
              await MultipartFile.fromFile(
                front.path,
                filename: front.path.split('/').last,
              )),
        ]);
      }
      if (holding != null) {
        formProcessing.addEntries([
          MapEntry(
              "rider_holding_license_img",
              await MultipartFile.fromFile(
                holding.path,
                filename: holding.path.split('/').last,
              )),
        ]);
      }
      FormData formData = FormData.fromMap(formProcessing);

      final response = await _dio.post(
        API.storeRiderDetail,
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      return response;
    } on DioException catch (ex) {
      return ErrorResponse(title: "License photo could not be updated");
    } catch (e) {
      return ErrorResponse(title: "App error");
    }
  }

  @override
  Future fetchRiderDetails() async {
    try {
      final token = ref.watch(getToken).asData?.value;
      final response = await _dio.get(
        API.fetchRiderDetail,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      return response.data;
    } on DioException catch (ex) {
      return ErrorResponse(title: "Unable to fetch data");
    } catch (e) {
      return ErrorResponse(title: "App Error");
    }
  }
}

final riderRepositoryProvider = Provider<RiderRepositoryImpl>((ref) {
  return RiderRepositoryImpl(ref: ref);
});
