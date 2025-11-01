import 'dart:io';
import 'package:project1/domain/appointment.dart';
import 'package:project1/domain/doctor.dart';
import 'package:project1/domain/patient.dart';
import 'package:project1/domain/hospital.dart';

void main() {
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


  final hospital = Hospital(
    doctors: [doctor1],
    patients: [patient1, patient2],
    staffs: [],
    rooms: [],
    appointments: [],
    presciptions: [],
  );

  // --- Run the UI menu ---
  runHospitalConsole(hospital);
}

void runHospitalConsole(Hospital hospital) {
  while (true) {
    print('\n===== Hospital Appointment System =====');
    print('1. Show all appointments');
    print('2. Add new appointment');
    print('3. Cancel appointment');
    print('4. Find appointment by doctor');
    print('5. Find appointment by patient');
    print('0. Exit');
    stdout.write('Enter your choice: ');
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        showAppointments(hospital);
        break;
      case '2':
        addAppointment(hospital);
        break;
      case '3':
        cancelAppointment(hospital);
        break;
      case '4':
        findByDoctor(hospital);
        break;
      case '5':
        findByPatient(hospital);
        break;
      case '0':
        print('Goodbye!');
        return;
      default:
        print('Invalid choice, please try again.');
    }
  }
}

// ================== UI FUNCTIONS ==================

void showAppointments(Hospital hospital) {
  print('\n--- All Appointments ---');
  if (hospital.appointments.isEmpty) {
    print('No appointments found.');
    return;
  }

  for (var a in hospital.appointments) {
    print('${a.getId} | Patient: ${a.patient.getName} | Doctor: ${a.doctor.getName} | Date: ${a.getdate} | Status: ${a.status}');
  }
}

void addAppointment(Hospital hospital) {
  print('\n--- Add New Appointment ---');

  // Choose patient
  print('\nAvailable Patients:');
  for (var i = 0; i < hospital.patients.length; i++) {
    print('${i + 1}. ${hospital.patients[i].getName}');
  }
  stdout.write('Choose patient number: ');
  final patientChoice = int.tryParse(stdin.readLineSync() ?? '');
  if (patientChoice == null || patientChoice < 1 || patientChoice > hospital.patients.length) {
    print('Invalid patient choice.');
    return;
  }
  final patient = hospital.patients[patientChoice - 1];

  // Choose doctor
  print('\nAvailable Doctors:');
  for (var i = 0; i < hospital.doctors.length; i++) {
    print('${i + 1}. ${hospital.doctors[i].getName} (${hospital.doctors[i].specialization})');
  }
  stdout.write('Choose doctor number: ');
  final doctorChoice = int.tryParse(stdin.readLineSync() ?? '');
  if (doctorChoice == null || doctorChoice < 1 || doctorChoice > hospital.doctors.length) {
    print('Invalid doctor choice.');
    return;
  }
  final doctor = hospital.doctors[doctorChoice - 1];

  // Enter date
  stdout.write('Enter appointment date (YYYY-MM-DD): ');
  final dateInput = stdin.readLineSync();
  if (dateInput == null || dateInput.isEmpty) {
    print('Date cannot be empty.');
    return;
  }

  try {
    final date = DateTime.parse(dateInput);
    final appointment = Appointment(date: date, doctor: doctor, patient: patient);
    hospital.addAppointment(appointment);
    print('✅ Appointment added successfully!');
  } catch (e) {
    print('❌ Invalid date format. Example: 2025-11-03');
  }
}

void cancelAppointment(Hospital hospital) {
  print('\n--- Cancel Appointment ---');
  if (hospital.appointments.isEmpty) {
    print('No appointments to cancel.');
    return;
  }

  showAppointments(hospital);
  stdout.write('Enter appointment ID to cancel: ');
  final id = stdin.readLineSync();

  if (id == null || id.isEmpty) {
    print('Invalid ID.');
    return;
  }

  final appointment = hospital.appointments.firstWhere(
    (a) => a.getId == id,
    orElse: () => throw Exception('Appointment not found'),
  );

  hospital.cancelAppointment(appointment);
}

void findByDoctor(Hospital hospital) {
  print('\n--- Find Appointment by Doctor ---');
  for (var i = 0; i < hospital.doctors.length; i++) {
    print('${i + 1}. ${hospital.doctors[i].getName}');
  }
  stdout.write('Choose doctor number: ');
  final choice = int.tryParse(stdin.readLineSync() ?? '');
  if (choice == null || choice < 1 || choice > hospital.doctors.length) {
    print('Invalid choice.');
    return;
  }

  final doctor = hospital.doctors[choice - 1];
  final result = hospital.findAppointmentByDoctor(doctor);
  if (result.isEmpty) {
    print('No appointments found for ${doctor.getName}.');
  } else {
    print('\nAppointments for Dr. ${doctor.getName}:');
    for (var a in result) {
      print('${a.getId} | ${a.getdate} | Patient: ${a.patient.getName}');
    }
  }
}

void findByPatient(Hospital hospital) {
  print('\n--- Find Appointment by Patient ---');
  for (var i = 0; i < hospital.patients.length; i++) {
    print('${i + 1}. ${hospital.patients[i].getName}');
  }
  stdout.write('Choose patient number: ');
  final choice = int.tryParse(stdin.readLineSync() ?? '');
  if (choice == null || choice < 1 || choice > hospital.patients.length) {
    print('Invalid choice.');
    return;
  }

  final patient = hospital.patients[choice - 1];
  final result = hospital.findAppointmentByPatient(patient);
  if (result.isEmpty) {
    print('No appointments found for ${patient.getName}.');
  } else {
    print('\nAppointments for ${patient.getName}:');
    for (var a in result) {
      print('${a.getId} | ${a.getdate} | Doctor: ${a.doctor.getName}');
    }
  }
}
