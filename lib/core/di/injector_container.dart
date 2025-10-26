import 'package:dairy_app/core/cubits/connection_cubit.dart';
import 'package:dairy_app/core/data/datasources/local/datasource/core_local_datasource.dart';
import 'package:dairy_app/core/domain/repository/core_repository.dart';
import 'package:dairy_app/feature/auth/data/datasources/login_remote_data_source.dart';
import 'package:dairy_app/feature/collections/presentation/blocs/collector_daily_cubit.dart';
import 'package:dairy_app/feature/collections/presentation/blocs/cubit/collector_supply_cubit.dart';
import 'package:dairy_app/feature/collections/presentation/blocs/cubit/farmer_details_cubit.dart';
import 'package:dairy_app/feature/collections/presentation/blocs/cubit/location_cubit.dart';
import 'package:dairy_app/feature/farmers/data/datasources/remote/farmers_remote_data_source.dart';
import 'package:dairy_app/feature/farmers/domain/repository/farmers_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../feature/auth/data/repository/login_repository_impl.dart';
import '../../feature/auth/domain/repository/login_repository.dart';
import '../../feature/auth/presentation/bloc/login_cubit.dart';
import '../../feature/auth/presentation/bloc/toggle_password_cubit.dart';
import '../../feature/collections/data/datasources/local/collections_local_data_source.dart';
import '../../feature/collections/data/datasources/remote/collections_remote_data_source.dart';
import '../../feature/collections/data/repository/collections_repository_impl.dart';
import '../../feature/collections/domain/repository/collections_repository.dart';
import '../../feature/collections/presentation/blocs/add_collection_cubit.dart';
import '../../feature/collections/presentation/blocs/collections_cubit.dart';
import '../../feature/collections/presentation/blocs/cubit/can_cubit.dart';
import '../../feature/collections/presentation/blocs/cubit/pending_collections_cubit.dart';
import '../../feature/collections/presentation/blocs/cubit/sync_collections_cubit.dart';
import '../../feature/collections/presentation/blocs/filter_collections_cubit.dart';
import '../../feature/collections/presentation/blocs/today_collection_cubit.dart';
import '../../feature/farmers/data/datasources/local/farmers_local_data_source.dart';
import '../../feature/farmers/data/repository/farmers_repository_impl.dart';
import '../../feature/farmers/presentation/blocs/add_farmer_cubit.dart';
import '../../feature/farmers/presentation/blocs/farmers_cubit.dart';
import '../../feature/home/presentation/cubit/home_cubit.dart';
import '../../feature/home/presentation/cubit/routes_cubit.dart';
import '../../feature/totals/data/datasources/milk_accumulation_data_source.dart';
import '../../feature/totals/data/repository/acc_milk_collection_repository_impl.dart';
import '../../feature/totals/domain/repository/aac_milk_collection_repository.dart';
import '../../feature/totals/presentation/cubits/accumulation_history_cubit.dart';
import '../../feature/totals/presentation/cubits/add_accumulative_collection_cubit.dart';
import '../../feature/totals/presentation/cubits/cummulator_stats_cubit.dart';
import '../../feature/totals/presentation/cubits/milk_collectors_cubit.dart';
import '../cubits/sync_state_cubit.dart';
import '../data/database/app_database.dart';
import '../data/datasources/remote/core_remote_data_source.dart';
import '../data/repository/core_repository_impl.dart';
import '../network/network.dart';

final sl = GetIt.instance;

Future<void> init() async {
  initFeatures();

  initCore();
  await initExternal();
}

void initFeatures() {
  //Cubits
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
  sl.registerFactory<FarmersCubit>(() => FarmersCubit(sl()));
  sl.registerFactory<CollectionsCubit>(() => CollectionsCubit(sl()));
  sl.registerFactory<FarmerDetailsCubit>(() => FarmerDetailsCubit(sl()));
  sl.registerFactory<CanCubit>(() => CanCubit(sl()));
  sl.registerFactory<HomeCubit>(() => HomeCubit(sl(), sl()));
  sl.registerFactory<ConnectionCubit>(() => ConnectionCubit(sl()));
  sl.registerFactory<AddFarmerCubit>(() => AddFarmerCubit(sl(), sl()));
  sl.registerFactory<LocationCubit>(() => LocationCubit());
  sl.registerFactory<AddCollectionCubit>(() => AddCollectionCubit(sl()));
  sl.registerFactory<TogglePasswordCubit>(() => TogglePasswordCubit());
  sl.registerFactory<RoutesCubit>(() => RoutesCubit(sl()));
  sl.registerFactory<TodayCollectionCubit>(() => TodayCollectionCubit(sl()));
  sl.registerFactory<FilterCollectionsCubit>(
      () => FilterCollectionsCubit(sl()));
  sl.registerFactory<PendingCollectionsCubit>(
      () => PendingCollectionsCubit(sl()));
  sl.registerFactory<SyncCollectionsCubit>(() => SyncCollectionsCubit(sl()));
  sl.registerFactory<SyncStateCubit>(() => SyncStateCubit(sl()));
  sl.registerFactory<MilkCollectorsCubit>(() => MilkCollectorsCubit(sl()));
  sl.registerFactory<AddAccumulativeCollectionCubit>(
      () => AddAccumulativeCollectionCubit(sl()));
  sl.registerFactory<AccumulationHistoryCubit>(
      () => AccumulationHistoryCubit(sl()));
  sl.registerFactory<CummulatorStatsCubit>(() => CummulatorStatsCubit(sl()));
  sl.registerFactory<CollectorDailyCubit>(() => CollectorDailyCubit(sl()));
  sl.registerFactory<CollectorSupplyCubit>(() => CollectorSupplyCubit(sl()));
  //Use cases

  //Repositories
  sl.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(sl(), sl(), sl()));
  sl.registerLazySingleton<FarmersRepository>(
      () => FarmersRepositoryImpl(sl(), sl(), sl()));
  sl.registerLazySingleton<CollectionsRepository>(
      () => CollectionsRepositoryImpl(sl(), sl(), sl()));
  sl.registerLazySingleton<CoreRepository>(
      () => CoreRepositoryImpl(sl(), sl(), sl()));
  sl.registerLazySingleton<AccMilkCollectionRepository>(
      () => AccMilkCollectionRepositoryImpl(sl(), sl()));

  //sl.registerLazySingleton<LocalStorageRepository>(() => LocalStorageRepositoryImpl( sl()));

  //Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
      () => LoginRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<FarmersRemoteDataSource>(
      () => FarmersRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<CollectionsRemoteDataSource>(
      () => CollectionsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<CoreLocalDataSource>(
      () => AppLocalDataSourceImpl(sl(), sl()));
  sl.registerLazySingleton<CoreRemoteDataSource>(
      () => CanRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<MilkAccumulationDataSource>(
      () => MilkAccumulationDataSourceImpl(sl()));
  sl.registerLazySingleton<CollectionsLocalDataSource>(
      () => CollectionsLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<FarmersLocalDataSource>(
      () => FarmersLocalDataSourceImpl(sl()));
}

void initCore() {
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
}

Future<void> initExternal() async {
  //Dio

  sl.registerFactory<Dio>(() {
    Dio dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    return dio;
  });

  //Network info
  // sl.registerLazySingleton(() => InternetConnectionChecker());

  //SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //Database
  final database =
      await $FloorJufredsDatabase.databaseBuilder('app_database.db').build();

  sl.registerFactory(() => database);
}
