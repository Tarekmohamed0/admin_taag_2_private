import 'package:admin_taag/features/create_clinics/presentation/cubit/create_clinics_cubit.dart';
import 'package:admin_taag/features/create_clinics/presentation/cubit/create_clinics_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/add_doctor.dart';

class AddDoctorToClinics extends StatefulWidget {
  const AddDoctorToClinics({super.key});

  @override
  State<AddDoctorToClinics> createState() => _AddDoctorToClinicsState();
}

class _AddDoctorToClinicsState extends State<AddDoctorToClinics> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final data = fetchClinicData();
  }

  void fetchClinicData() async {
    final data = await context.read<CreateClinicsCubit>().fetchClinicData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Doctor To Clinics'),
        leading: IconButton(
            onPressed: () async {
              await context.read<CreateClinicsCubit>().fetchClinicData();
            },
            icon: Icon(Icons.refresh)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: BlocBuilder<CreateClinicsCubit, CreateClinicsState>(
            buildWhen: (previous, current) =>
                current is Loaded || current is Error || current is Loading,
            builder: (context, state) {
              return state.maybeWhen(
                loaded: (data) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text('Clinics'),
                      const SizedBox(height: 20),
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const AddDoctor();
                                      },
                                    ),
                                  );
                                },
                                title: Text(data[index]['clinicName']),
                              );
                            }),
                      ),
                      const SizedBox(height: 20),
                      const Text('Doctors'),
                      const SizedBox(height: 20),
                      DropdownButton<String>(
                        items: data
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e['clinicName'],
                                child: Text(e['clinicName']),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Add Doctor To Clinic'),
                      ),
                    ],
                  );
                },
                error: () {
                  return const Text('Error');
                },
                loading: () {
                  return const CircularProgressIndicator();
                },
                orElse: () {
                  return const SizedBox();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
