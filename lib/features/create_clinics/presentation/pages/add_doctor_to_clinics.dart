import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/create_clinics_state.dart';
import '../widgets/add_doctor.dart';
import '../cubit/create_clinics_cubit.dart';

class AddDoctorToClinics extends StatefulWidget {
  const AddDoctorToClinics({super.key});

  @override
  State<AddDoctorToClinics> createState() => _AddDoctorToClinicsState();
}

class _AddDoctorToClinicsState extends State<AddDoctorToClinics> {
  @override
  void initState() {
    super.initState();
    fetchClinicData();
  }

  void fetchClinicData() async {
    await context.read<CreateClinicsCubit>().fetchClinicData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Doctor To Clinics'),
        leading: IconButton(
          onPressed: () async {
            FocusScope.of(context).unfocus(); // إزالة التركيز قبل التحديث
            fetchClinicData();
          },
          icon: const Icon(Icons.refresh),
        ),
      ),
      body: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(), // إزالة التركيز عند النقر
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: BlocBuilder<CreateClinicsCubit, CreateClinicsState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loaded: (data) {
                    return Column(
                      children: [
                        const Text('Clinics'),
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AddDoctor(
                                      clinics: data[index],
                                    ),
                                  ),
                                );
                              },
                              title: Text(data[index]['clinicName']),
                            );
                          },
                        ),
                      ],
                    );
                  },
                  error: () => const Center(
                    child: Text('Error loading clinics'),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  orElse: () => const SizedBox(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
