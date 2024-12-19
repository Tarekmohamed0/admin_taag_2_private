import 'package:admin_taag/features/create_clinics/data/models/date_model.dart';
import 'package:admin_taag/features/create_clinics/presentation/cubit/create_clinics_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/sources/create_clinec_data_source.dart';

class CreateClinicsCubit extends Cubit<CreateClinicsState> {
  CreateClinicsCubit() : super(CreateClinicsState.initial());

  final TextEditingController clinicNameController = TextEditingController();
  final TextEditingController clinicAddressController = TextEditingController();
  final TextEditingController clinicPhoneController = TextEditingController();
  final TextEditingController clinicEmailController = TextEditingController();
  final TextEditingController clinicDescriptionController =
      TextEditingController();

  Future<void> createClinic({
    required String clinicName,
    required String clinicAddress,
    required String clinicPhone,
    required String clinicDescription,
    required List<DateModel> date,
  }) async {
    emit(CreateClinicsState.loading());
    try {
      await CreateClinecDataSource().createClinic(
        clinicName,
        clinicAddress,
        clinicPhone,
        clinicDescription,
        date,
      );
      emit(CreateClinicsState.created());
    } catch (e) {
      emit(CreateClinicsState.error());
    }
  }

  // fetch the clinic data from firestore
  Future<List<Map<String, dynamic>>> fetchClinicData() async {
    emit(CreateClinicsState.loading());
    try {
      final data = await CreateClinecDataSource().fetchClinicData();
      emit(CreateClinicsState.loaded(data));
      return data;
    } on FirebaseFirestore catch (e) {
      emit(CreateClinicsState.error());
      return [];
    }
  }
}
