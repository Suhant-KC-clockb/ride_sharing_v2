import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/data/models/error_response.dart';
import 'package:ridesharing/data/models/rider_docs.dart';
import 'package:ridesharing/data/repository/rider_repository.dart';

class RiderController extends StateNotifier<AsyncValue<dynamic>> {
  Ref ref;

  RiderController({
    required this.ref,
  }) : super(const AsyncData(null));

  Future<Either<String, bool>> getRiderProfile() async {
    final response =
        await ref.read(riderRepositoryProvider).getCurrentRiderDetails();

    if (response is ErrorResponse) {
      return Left(response.title);
    } else {
      return Right(true);
    }
  }

  Future<Either<String, bool>> postRiderVehicleDetail(
      {required String licenseNumber,
      required String bikeDetail,
      required String numberPlate,
      File? vehiclePhoto}) async {
    final response = await ref
        .read(riderRepositoryProvider)
        .postRiderVehicleDetail(
            licenseNumber: licenseNumber,
            bikeDetail: bikeDetail,
            numberPlate: numberPlate,
            vehiclePhoto: vehiclePhoto);
    print(response);

    if (response is ErrorResponse) {
      return Left(response.title);
    } else {
      return const Right(true);
    }
  }

  Future<Either<String, bool>> postRiderLicenseDetail({
    required File front,
    required File holding,
  }) async {
    final response =
        await ref.read(riderRepositoryProvider).postRiderLicenseDetail(
              front: front,
              holding: holding,
            );

    if (response is ErrorResponse) {
      return Left(response.title);
    } else {
      return const Right(true);
    }
  }

  Future<Either<String, RiderDocs>> fetchRiderDetail() async {
    final response =
        await ref.read(riderRepositoryProvider).fetchRiderDetails();
    if (response is ErrorResponse) {
      return Left(response.title);
    } else {
      final result = RiderDocs.fromJson(response['data']);

      return Right(result);
    }
  }
}

final riderController =
    StateNotifierProvider<RiderController, AsyncValue<dynamic>>((ref) {
  return RiderController(ref: ref);
});

final getRiderDetail = FutureProvider<Either<String, bool>>(
  (ref) async {
    final response =
        await ref.read(riderRepositoryProvider).getCurrentRiderDetails();

    if (response is ErrorResponse) {
      return Left(response.title);
    } else {
      return const Right(true);
    }
  },
);

final fetchRiderInformation =
    FutureProvider<Either<String, dynamic>>((ref) async {
  final response = await ref.read(riderRepositoryProvider).fetchRiderDetails();
  if (response is ErrorResponse) {
    return Left(response.title);
  } else {
    return Right(response);
  }
});

final getLiscenseInformation = FutureProvider((ref) => null);
final getBluebookInformation = FutureProvider((ref) => null);
