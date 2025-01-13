import 'package:admin_taag/core/errors/failures.dart';

import 'package:dartz/dartz.dart';

import '../sources/sources.dart';
import '../../domain/repositories/repositories.dart';

class Payment_chartRepositoryImp implements Payment_chartRepository {
  final Payment_chartRemoteDataSource remoteDataSource;
  Payment_chartRepositoryImp({required this.remoteDataSource});

  @override
  Future<Either<Failure, List>> fetchClinicBySpecialty(String Query) async {
    return await Payment_chartRemoteDataSource()
        .fetchClinicBySpecialty(Query)
        .then((value) => right(value));
  }

  // ... example ...
  //
  // Future<User> getUser(String userId) async {
  //     return remoteDataSource.getUser(userId);
  //   }
  // ...
}
