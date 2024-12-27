
    import '../sources/sources.dart';
    import '../../domain/repositories/repositories.dart';
    
    class Payment_chartRepositoryImp implements Payment_chartRepository{

        final Payment_chartRemoteDataSource remoteDataSource;
        Payment_chartRepositoryImp({required this.remoteDataSource});
      
        // ... example ...
        //
        // Future<User> getUser(String userId) async {
        //     return remoteDataSource.getUser(userId);
        //   }
        // ...
    }
    