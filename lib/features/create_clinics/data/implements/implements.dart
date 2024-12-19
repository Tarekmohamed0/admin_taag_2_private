
    import '../sources/sources.dart';
    import '../../domain/repositories/repositories.dart';
    
    class Create_clinicsRepositoryImp implements Create_clinicsRepository{

        final Create_clinicsRemoteDataSource remoteDataSource;
        Create_clinicsRepositoryImp({required this.remoteDataSource});
      
        // ... example ...
        //
        // Future<User> getUser(String userId) async {
        //     return remoteDataSource.getUser(userId);
        //   }
        // ...
    }
    