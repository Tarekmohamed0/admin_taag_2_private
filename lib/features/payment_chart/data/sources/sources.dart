import 'package:cloud_firestore/cloud_firestore.dart';

class Payment_chartRemoteDataSource {
  Future<List<dynamic>> fetchClinicBySpecialty(String query) async {
    List<dynamic> clinicList = [];
    try {
      // الحصول على جميع البيانات من Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('clinics').get();

      // تصفية البيانات محليًا بناءً على الحرف المطلوب
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String clinicName = data['clinicName'] ?? '';

        // التحقق إذا كان النص يحتوي على الحرف
        if (clinicName.contains(query)) {
          clinicList.add(data);
        }
      }

      return clinicList;
    } catch (e) {
      throw Exception("Error fetching clinics: ${e.toString()}");
    }
  }
}
