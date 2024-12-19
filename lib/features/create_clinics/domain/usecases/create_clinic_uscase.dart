import 'package:admin_taag/features/create_clinics/domain/repositories/create_clinic_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

class CreateClinicUscase {
  final CreateClinicRepo repository;

  CreateClinicUscase(this.repository);

  Future<Either<Failure, void>> call({
    required String clinicName,
    required String clinicAddress,
    required String clinicPhone,
    required String clinicDescription,
    required dynamic date,
  }) async {
    return await repository.createClinic(
        clinicName: clinicName,
        clinicAddress: clinicAddress,
        clinicPhone: clinicPhone,
        clinicDescription: clinicDescription,
        date: date);
  }
}
