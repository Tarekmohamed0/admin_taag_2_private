import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class Payment_chartRepository {
  Future<Either<Failure, List<dynamic>>> fetchClinicBySpecialty(String Query);
}
