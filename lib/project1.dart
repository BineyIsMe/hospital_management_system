
import 'package:project1/data/data.dart';
import 'package:project1/domain/doctor.dart';
import 'package:project1/domain/patient.dart';
import 'package:project1/domain/hospital.dart';
import 'package:project1/ui/appointment_console.dart';

Future<void> main() async {
  final filePath = './lib/data/hospital.json';
  final defaultHospital = Hospital(
    doctors: [
      Doctor(
        name: 'Dr. NHA',
        address: 'Phnom Penh',
        age: 45,
        phoneNumber: '012345678',
        gender: 'Male',
        specialization: Specialization.cardiology,
      ),
      Doctor(
        name: 'Dr. OPP',
        address: 'Phnom Penh',
        age: 40,
        phoneNumber: '010345678',
        gender: 'Male',
        specialization: Specialization.cardiology,
      ),
    ],
    patients: [
      Patient(
        name: 'PU NAK',
        address: 'Siem Reap',
        age: 30,
        phoneNumber: '099887766',
        gender: 'Male',
      ),
      Patient(
        name: 'Bopha',
        address: 'Battambang',
        age: 25,
        phoneNumber: '088998877',
        gender: 'Female',
      ),
    ],
    staffs: [],
    rooms: [],
    appointments: [],
    presciptions: [],
  );

  final hospital = await loadOrCreateHospital(filePath, defaultHospital);


  await runHospitalConsole(hospital);


  await saveHospitalFile(hospital, filePath);
}
