import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDoctor extends StatelessWidget {
  AddDoctor({super.key, this.clinics});
  final dynamic clinics;
  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController doctorSpecialityController =
      TextEditingController();
  final TextEditingController doctorPhoneController = TextEditingController();
  final TextEditingController doctorEmailController = TextEditingController();
  final TextEditingController doctorAddressController = TextEditingController();
  final TextEditingController doctorPasswordController =
      TextEditingController();
  final TextEditingController doctorConfirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () =>
              FocusScope.of(context).unfocus(), // إزالة التركيز عند النقر
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              // لتجنب مشاكل التمرير
              child: Column(
                children: [
                  const Text('Add Doctor'),
                  const SizedBox(height: 16),
                  _buildTextField(
                      controller: doctorNameController, label: 'Doctor Name'),
                  _buildTextField(
                      controller: doctorSpecialityController,
                      label: 'Doctor Speciality'),
                  _buildTextField(
                      controller: doctorPhoneController, label: 'Doctor Phone'),
                  _buildTextField(
                      controller: doctorEmailController, label: 'Doctor Email'),
                  _buildTextField(
                      controller: doctorAddressController,
                      label: 'Doctor Address'),
                  _buildTextField(
                      controller: doctorPasswordController,
                      label: 'Doctor Password'),
                  _buildTextField(
                      controller: doctorConfirmPasswordController,
                      label: 'Doctor Confirm Password'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (doctorNameController.text.isEmpty ||
                          doctorEmailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all required fields'),
                          ),
                        );
                        return;
                      }
                      try {
                        FirebaseFirestore.instance
                            .collection('clinics')
                            .get()
                            .then(
                          (snapshot) {
                            for (var element in snapshot.docs) {
                              if (element['clinicName'] ==
                                  clinics['clinicName']) {
                                FirebaseFirestore.instance
                                    .collection('clinics')
                                    .doc(element.id)
                                    .update({
                                  'doctors': FieldValue.arrayUnion(
                                    [
                                      {
                                        'doctorName': doctorNameController.text,
                                        'doctorSpeciality':
                                            doctorSpecialityController.text,
                                        'doctorPhone':
                                            doctorPhoneController.text,
                                        'doctorEmail':
                                            doctorEmailController.text,
                                        'doctorAddress':
                                            doctorAddressController.text,
                                        'doctorPassword':
                                            doctorPasswordController.text,
                                        'doctorConfirmPassword':
                                            doctorConfirmPasswordController
                                                .text,
                                      },
                                    ],
                                  ),
                                });
                              }
                            }
                          },
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Doctor added successfully to clinic'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                          ),
                        );
                      }
                    },
                    child: const Text('Add Doctor'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String label}) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
