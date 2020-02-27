import 'package:get_it/get_it.dart';
import 'package:test_clone/global_navigator/router.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}