
import 'package:admin_taag/core/services/fire_storage.dart';
import 'package:admin_taag/core/services/stoarage_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetit() {
  
  getIt.registerSingleton<StoarageService>(FireStorage());
  // getIt.registerSingleton<ProductsRepo>(
  //   ProductsRepoImpl(
  //     getIt<DatabaseService>(),
  //   ),
  // );
}
