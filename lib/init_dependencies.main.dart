part of 'init_dependencies.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
      url: AppSecret.supabaseAppUrl, anonKey: AppSecret.supabaseAppApiKey);

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  // core

  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerFactory(() => InternetConnection());

  serviceLocator.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator<InternetConnection>()));
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLogin(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => CurrentUser(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(() => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ));
}

void _initBlog() {
  // Data source
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
        () => BlogRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<BlogLocalDataSource>(
        () => BlogLocalDataSourceImpl(serviceLocator()))
    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecase
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    // Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator<UploadBlog>(),
        getAllBlogs: serviceLocator<GetAllBlogs>(),
      ),
    );
}
