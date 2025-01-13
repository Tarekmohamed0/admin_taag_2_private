import 'package:admin_taag/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class CreateClinicRepo {
  Future<Either<Failure, void>> createClinic({
    required String clinicName,
    required String clinicAddress,
    required String clinicPhone,
    required String clinicDescription,
    required dynamic date,
    required String clinicDiscountOrder,
    required String clinicPriceOrder,
  });
}
