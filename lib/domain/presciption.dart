import 'package:project1/domain/doctor.dart';
import 'package:project1/domain/patient.dart';
import 'package:project1/domain/staff.dart';
import 'package:uuid/uuid.dart';

class Presciption {
  final String _id;
  List<String> _diagnosis;
  final double _totalAmount;
  String _medicalDescription;
  Staff? staff;
  final Patient patient;
  final Doctor doctor;
  static var idGenerator = Uuid();
  Presciption({
    required String id,
    required List<String> diagnosis,
    required double totalAmount,
    String medicalDescription = '',
    this.staff,
    required this.patient,
    required this.doctor
  }) : _id = idGenerator.v4(),
       _totalAmount = totalAmount,
       _diagnosis = diagnosis,
       _medicalDescription = medicalDescription;

       String get getId=>_id;
       double get getTotalAmount=>_totalAmount;
       String get getMedicalDescription=>_medicalDescription;

       set setMedicalDescription(String string)=>_medicalDescription=string;
        @override
  String toString() {
    return 'Prescription(id: $_id, patient: ${patient.getName}, doctor: ${doctor.getName}, '
        'staff: ${staff?.getName ?? "None"}, diagnosis: ${_diagnosis.join(", ")}, '
        'totalAmount: $_totalAmount, medicalDescription: $_medicalDescription)';
  }

}
