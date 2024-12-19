import 'package:admin_taag/core/errors/failures.dart';
import 'package:admin_taag/features/create_clinics/domain/repositories/create_clinic_repo.dart';
import 'package:dartz/dartz.dart';

import '../sources/create_clinec_data_source.dart';

class CreateClinicRepoImpl extends CreateClinicRepo {
  @override
  Future<Either<Failure, void>> createClinic(
      {required String clinicName,
      required String clinicAddress,
      required String clinicPhone,
      required String clinicDescription,
      required date}) async {
    try {
      final data = await CreateClinecDataSource().createClinic(
          clinicName, clinicAddress, clinicPhone, clinicDescription, date);
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
