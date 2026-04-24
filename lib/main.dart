import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/explore/presentation/cubit/explore_cubit.dart';
import 'features/saved/presentation/cubit/saved_cubit.dart';
import 'features/explore/presentation/views/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // 🌟
  runApp(const ZooEyeApp());
}

class ZooEyeApp extends StatelessWidget {
  const ZooEyeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ExploreCubit()),
        BlocProvider(create: (context) => SavedCubit()),
      ],
      child: MaterialApp(
        title: 'ZooEye',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Cairo',
          scaffoldBackgroundColor: const Color(
            0xFF1A3A0A,
          ), 
          canvasColor: const Color(0xFF1A3A0A),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D5016)),
        ),
        home: const SplashView(),
      ),
    );
  }
}
