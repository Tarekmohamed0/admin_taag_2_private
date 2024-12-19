import 'package:admin_taag/features/create_clinics/data/models/date_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateClinecDataSource {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createClinic(
    String clinicName,
    String clinicAddress,
    String clinicPhone,
    String clinicDescription,
    List<DateModel> date,
  ) async {
    try {
      final data = await _firestore.collection('clinics').add({
        'clinicName': clinicName,
        'clinicAddress': clinicAddress,
        'clinicPhone': clinicPhone,
        'clinicDescription': clinicDescription,
        'date': date.map((e) => e.DateModeltoJson()).toList(),
      });
      // print(data.get());
    } on FirebaseFirestore catch (e) {
      print(e.toString());
    }
  }

  // fetch the clinic data from firestore
  Future<List<Map<String, dynamic>>> fetchClinicData() async {
    try {
      final data = await _firestore.collection('clinics').get();
      print(data);
      return data.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    } on FirebaseFirestore catch (e) {
      print(e.toString());
      return [];
    }
  }
}
