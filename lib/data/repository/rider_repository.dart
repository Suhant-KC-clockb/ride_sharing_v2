import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/constant/api.dart';
import 'package:ridesharing/data/models/error_response.dart';
import 'package:ridesharing/data/repository/auth_repository.dart';
import 'package:ridesharing/screens/rider/vehicle_info.dart';

abstract class RiderRepository {
  //GET METHODS
  Future<dynamic> getCurrentRiderDetails();
  Future<dynamic> fetchRiderDetails();
  Future<dynamic> getVehicleInformation();
  Future<dynamic> getLicenseInformation();
  Future<dynamic> getBlueBookInformation();

  //POST METHODS
  Future<dynamic> postRiderVehicleDetail({
    File? vehiclePhoto,
    required String licenseNumber,
    required String bikeDetail,
    required String numberPlate,
    required String manufacturer,
    required RideType rideType,
  });
  Future<dynamic> postRiderLicenseDetail({File front, File holding});
  Future<dynamic> postRiderBluebookDetail({File bluebook1, File bluebook2});
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
    // final response =
    //     await Future.delayed(const Duration(seconds: 1), () => {"data": null});
    return ErrorResponse(title: "K ho rider ko detail barna birisis?");
  }

  @override
  Future getBlueBookInformation() async {
    final response =
        await Future.delayed(const Duration(seconds: 3), () => {"data": null});
    return response;
  }

  @override
  Future getLicenseInformation() async {
    final response =
        await Future.delayed(const Duration(seconds: 3), () => {"data": null});
    return response;
  }

  @override
  Future getVehicleInformation() async {
    final response =
        await Future.delayed(const Duration(seconds: 10), () => {"data": null});
    return response;
  }

  @override
  Future postRiderVehicleDetail({
    File? vehiclePhoto,
    required String licenseNumber,
    required String bikeDetail,
    required String numberPlate,
    required String manufacturer,
    required RideType rideType,
  }) async {
    try {
      final token = ref.watch(getToken).asData?.value;

      Map<String, dynamic> formProcessing = {
        "license_number": licenseNumber,
        "transport_name": bikeDetail,
        "number_plate": numberPlate,
        "transport_model": manufacturer,
        "ride_type": rideType == RideType.bike ? "bike" : "car"
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
    } on DioException {
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

      if (holding != null || front != null) {
        final response = await _dio.post(
          API.storeRiderDetail,
          data: formData,
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ),
        );
        return response;
      }

      return "success";
    } on DioException {
      return ErrorResponse(title: "License photo could not be updated");
    } catch (e) {
      return ErrorResponse(title: "App error");
    }
  }

  @override
  Future postRiderBluebookDetail({File? bluebook1, File? bluebook2}) async {
    try {
      final token = ref.watch(getToken).asData?.value;

      Map<String, dynamic> formProcessing = {};

      if (bluebook1 != null) {
        formProcessing.addEntries([
          MapEntry(
              "blue_book1_img",
              await MultipartFile.fromFile(
                bluebook1.path,
                filename: bluebook1.path.split('/').last,
              )),
        ]);
      }
      if (bluebook2 != null) {
        formProcessing.addEntries([
          MapEntry(
              "blue_book2_img",
              await MultipartFile.fromFile(
                bluebook2.path,
                filename: bluebook2.path.split('/').last,
              )),
        ]);
      }
      FormData formData = FormData.fromMap(formProcessing);

      if (bluebook1 != null || bluebook2 != null) {
        final response = await _dio.post(
          API.storeRiderDetail,
          data: formData,
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ),
        );
        return response;
      }
      return "success";
    } on DioException {
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
    } on DioException {
      return ErrorResponse(title: "Unable to fetch data");
    } catch (e) {
      return ErrorResponse(title: "App Error");
    }
  }
}

final riderRepositoryProvider = Provider<RiderRepositoryImpl>((ref) {
  return RiderRepositoryImpl(ref: ref);
});
