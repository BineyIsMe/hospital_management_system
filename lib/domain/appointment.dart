import 'package:project1/domain/doctor.dart';
import 'package:project1/domain/patient.dart';
import 'package:uuid/uuid.dart';

class Appointment {
  static var idGenerator = Uuid();
  final String _id;
  final Patient patient;
  final Doctor doctor;
  DateTime _date;
  Appointment({
    required String id,
    required DateTime date,
    required this.patient,
    required this.doctor,
  }) : _id = idGenerator.v4(),
       _date = date;
String get getId=>_id;
DateTime get getdate=>_date;
set setdate(DateTime date)=> _date=date;

 @override
  String toString() {
    return 'Appointment(id: $_id, patient: ${patient.getName}, doctor: ${doctor.getName}, date: $_date)';
  }
}
