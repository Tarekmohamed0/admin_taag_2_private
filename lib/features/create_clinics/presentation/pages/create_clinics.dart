import 'package:admin_taag/features/create_clinics/presentation/cubit/create_clinics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/date_model.dart';

class CreateClinics extends StatefulWidget {
  const CreateClinics({Key? key}) : super(key: key);

  @override
  State<CreateClinics> createState() => _CreateClinicsState();
}

class _CreateClinicsState extends State<CreateClinics> {
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  String? selectedDay;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  // تعديل الخريطة لتكون مباشرة
  List<DateModel> clinicSchedule = [];

  Future<void> _selectTime(BuildContext context, String timeType) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (timeType == 'start') {
          startTime = pickedTime;
        } else if (timeType == 'end') {
          endTime = pickedTime;
        }
      });
    }
  }

  void _addSchedule() {
    if (selectedDay != null && startTime != null && endTime != null) {
      setState(() {
        clinicSchedule.add(DateModel(
          day: selectedDay!,
          startTime: startTime!.format(context), // Format to string
          endTime: endTime!.format(context), // Format to string
        ));
        selectedDay = null;
        startTime = null;
        endTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateClinicsCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Clinic'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                child: Column(
                  children: [
                    // حقول النصوص
                    TextFormField(
                      controller: context
                          .read<CreateClinicsCubit>()
                          .clinicNameController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(),
                        ),
                        filled: true,
                        labelText: 'Clinic Name',
                        hintText: 'Enter Clinic Name',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: context
                          .read<CreateClinicsCubit>()
                          .clinicAddressController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(),
                        ),
                        filled: true,
                        labelText: 'Clinic Address',
                        hintText: 'Enter Clinic Address',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: context
                          .read<CreateClinicsCubit>()
                          .clinicPhoneController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(),
                        ),
                        filled: true,
                        labelText: 'Clinic Phone',
                        hintText: 'Enter Clinic Phone',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: context
                          .read<CreateClinicsCubit>()
                          .clinicDescriptionController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(),
                        ),
                        filled: true,
                        labelText: 'Clinic Description',
                        hintText: 'Enter Clinic Description',
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedDay,
                      hint: const Text('Select Day'),
                      items: daysOfWeek.map((day) {
                        return DropdownMenuItem(
                          value: day,
                          child: Text(day),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDay = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    // اختيار الوقت
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            'Start Time: ${startTime?.format(context) ?? 'Not Set'}'),
                        ElevatedButton(
                          onPressed: () => _selectTime(context, 'start'),
                          child: const Text('Set Start'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            'End Time: ${endTime?.format(context) ?? 'Not Set'}'),
                        ElevatedButton(
                          onPressed: () => _selectTime(context, 'end'),
                          child: const Text('Set End'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addSchedule,
                      child: const Text('Add Schedule'),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Selected Schedule:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: clinicSchedule.length,
                      itemBuilder: (context, index) {
                        final schedule =
                            clinicSchedule[index]; // Access DateModel
                        return ListTile(
                          title: Text(schedule.day),
                          subtitle: Text(
                            'Start: ${schedule.startTime} - End: ${schedule.endTime}',
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await context.read<CreateClinicsCubit>().createClinic(
                              clinicName: context
                                  .read<CreateClinicsCubit>()
                                  .clinicNameController
                                  .text,
                              clinicAddress: context
                                  .read<CreateClinicsCubit>()
                                  .clinicAddressController
                                  .text,
                              clinicPhone: context
                                  .read<CreateClinicsCubit>()
                                  .clinicPhoneController
                                  .text,
                              clinicDescription: context
                                  .read<CreateClinicsCubit>()
                                  .clinicDescriptionController
                                  .text,
                              date: clinicSchedule,
                            );
                        print(clinicSchedule);
                      },
                      child: const Text('Create Clinic'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
