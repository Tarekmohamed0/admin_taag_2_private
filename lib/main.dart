import 'package:admin_taag/core/services/get_it_service.dart';
import 'package:admin_taag/features/create_clinics/presentation/pages/create_clinics.dart';
import 'package:admin_taag/firebase_optionss.dart';
import 'package:admin_taag/view/dashboard_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/create_clinics/presentation/cubit/create_clinics_cubit.dart';
import 'features/create_clinics/presentation/pages/add_doctor_to_clinics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupGetit();
  //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<CreateClinicsCubit>(
            create: (context) => CreateClinicsCubit(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: DashboardView(),
          ),
        ));
  }
}
