import 'dart:io';
// import 'dart:convert';
// import 'dart:vmservice_io';


import 'package:project1/data/data.dart';
import 'package:project1/domain/doctor.dart';
import 'package:project1/domain/patient.dart';
import 'package:project1/domain/hospital.dart';
import 'package:project1/ui/appointment_console.dart';

Future<void> main() async {
  final filePath = './lib/data/hospital.json';

  // --- Mock data setup ---
  final doctor1 = Doctor(
    name: 'Dr. Smith',
    address: 'Phnom Penh',
    age: 45,
    phoneNumber: '012345678',
    gender: 'Male',
    specialization: Specialization.cardiology,
  );

  final patient1 = Patient(
    name: 'John Doe',
    address: 'Siem Reap',
    age: 30,
    phoneNumber: '099887766',
    gender: 'Male',
  );

  final patient2 = Patient(
    name: 'Alice Brown',
    address: 'Battambang',
    age: 25,
    phoneNumber: '088998877',
    gender: 'Female',
  );

  // --- Load hospital data if file exists ---
  Hospital hospital;
  if (await File(filePath).exists()) {
    hospital = await loadHospitalFile(filePath);
    print(' Hospital data loaded from $filePath');
  } else {
    hospital = Hospital(
      doctors: [doctor1],
      patients: [patient1, patient2],
      staffs: [],
      rooms: [],
      appointments: [],
      presciptions: [],
    );
    print(' No saved data found. Created new hospital.');
  }

  // --- Run the console UI ---
  await runHospitalConsole(hospital);


}

