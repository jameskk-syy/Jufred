import 'package:dairy_app/core/cubits/connection_cubit.dart';
import 'package:dairy_app/core/di/injector_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/theme/colors.dart';
import 'core/cubits/sync_state_cubit.dart';
import 'core/presentation/navigation/navigation_container.dart';
import 'feature/auth/presentation/pages/login_page.dart';
import 'core/di/injector_container.dart' as di;
import 'feature/collections/domain/repository/collections_repository.dart';
import 'feature/collections/presentation/blocs/cubit/pending_collections_cubit.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({super.key});

  final sharedPrefs = sl<SharedPreferences>();
  final bool dbHasData = false;

  @override
  Widget build(BuildContext context) {
    final syncDialogCubit = SyncStateCubit(sl<CollectionsRepository>());
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<PendingCollectionsCubit>()..getPendingCollections(),
        ),
        BlocProvider(
          create: (context) => sl<ConnectionCubit>()..checkConnection(),
        ),
        BlocProvider.value(
          value: syncDialogCubit,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorScheme: AppColors.lightColorScheme),
        themeMode: ThemeMode.light,
        /*home: sharedPrefs.getBool('isLoggedIn') ?? false
            ? const BottomNavigationContainer()
            : LoginPage(),*/
        home: FutureBuilder<bool>(
          future: syncDialogCubit.stream.first, // Wait for the checkLocalStorage method to complete
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!) {
              return syncDialog(context); // Show the sync dialog if local storage has data
            } else {
              return sharedPrefs.getBool('isLoggedIn') ?? false
                  ? const BottomNavigationContainer()
                  : LoginPage();
            }
          },
        ),
      ),
    );
  }

  Widget syncDialog(BuildContext  context) {
    return BlocBuilder<SyncStateCubit, bool>(
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Sync Data'),
          content: const Text('Do you want to sync data from the server?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const BottomNavigationContainer(),
                  ),
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}


