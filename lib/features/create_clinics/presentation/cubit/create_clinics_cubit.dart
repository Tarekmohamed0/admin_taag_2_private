import 'package:admin_taag/features/create_clinics/data/models/date_model.dart';
import 'package:admin_taag/features/create_clinics/presentation/cubit/create_clinics_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/sources/create_clinec_data_source.dart';

class CreateClinicsCubit extends Cubit<CreateClinicsState> {
  CreateClinicsCubit() : super(const CreateClinicsState.initial());

  final TextEditingController clinicNameController = TextEditingController();
  final TextEditingController clinicAddressController = TextEditingController();
  final TextEditingController clinicPhoneController = TextEditingController();
  final TextEditingController clinicEmailController = TextEditingController();
  final TextEditingController clinicDescriptionController =
      TextEditingController();

  final TextEditingController clinicPriceOrder = TextEditingController();
  final TextEditingController clinicDiscountOrder = TextEditingController();

  Future<void> createClinic({
    required String clinicName,
    required String clinicAddress,
    required String clinicPhone,
    required String clinicDescription,
    required List<DateModel> date,
    required String clinicPriceOrder,
    required String clinicDiscountOrder,
  }) async {
    emit(const CreateClinicsState.loading());
    try {
      await CreateClinecDataSource().createClinic(
          clinicName,
          clinicAddress,
          clinicPhone,
          clinicDescription,
          date,
          clinicPriceOrder,
          clinicDiscountOrder);
      emit(const CreateClinicsState.created());
    } catch (e) {
      emit(const CreateClinicsState.error());
    }
  }

  // fetch the clinic data from firestore
  Future<List<Map<String, dynamic>>> fetchClinicData() async {
    emit(const CreateClinicsState.loading());
    try {
      final data = await CreateClinecDataSource().fetchClinicData();
      emit(CreateClinicsState.loaded(data));
      return data;
    } on FirebaseFirestore catch (e) {
      emit(const CreateClinicsState.error());
      return [];
    }
  }
}
