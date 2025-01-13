import 'package:admin_taag/features/payment_chart/data/implements/implements.dart';
import 'package:admin_taag/features/payment_chart/domain/repositories/repositories.dart';
import 'package:admin_taag/features/payment_chart/presentation/cubit/payment_chart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/sources/sources.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  // قائمة العمليات
  List<Map<String, dynamic>> paymentsList = [];

  // جلب البيانات من Firebase
  Future<void> fetchPayments() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('payments').get();
      paymentsList = snapshot.docs.map((doc) => doc.data()).toList();
      emit(PaymentSuccess());
    } catch (e) {
      emit(PaymentFailure("Error fetching payments: $e"));
      log("Error fetching payments: $e");
    }
  }

  Future<List<dynamic>> fetchClinicsBySpecialty(String Query) async {
    emit(PaymentLoading());
    try {
      final result =
          await Payment_chartRemoteDataSource().fetchClinicBySpecialty(Query);

      return result;
    } catch (e) {
      emit(PaymentFailure("Error fetching clinics: $e"));
      log("Error fetching clinics: $e");
      return [];
    }
  }

  @override
  void onChange(Change<PaymentState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
