import 'dart:io';
import 'package:project1/data/data.dart';
import 'package:project1/domain/appointment.dart';
import 'package:project1/domain/doctor.dart';
import 'package:project1/domain/patient.dart';
import 'package:project1/domain/hospital.dart';
import 'package:project1/domain/staff.dart';
import 'package:project1/domain/room.dart';
import 'package:project1/domain/presciption.dart';



Future<void> runHospitalConsole(Hospital hospital) async {
  final filePath = './lib/data/hospital.json';
  while (true) {
    print('\n=====  Hospital Management System =====');
    print('1. Show all appointments');
    print('2. Add new appointment');
    print('3. Cancel appointment');
    print('4. Change appointment date');
    print('5. Find appointment by doctor');
    print('6. Find appointment by patient');
    print('7. Find patient by name');
    print('8. View upcoming appointments');
    print('9. View past appointments');
    print('10. Check doctor availability');
    print('--- Registration ---');
    print('11. Register new patient');
    print('12. Register new doctor');
    print('13. Register new staff');
    print('14. Add new room');
    print('15. Add prescription');
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
        changeAppointment(hospital);
        break;
      case '5':
        findByDoctor(hospital);
        break;
      case '6':
        findByPatient(hospital);
        break;
      // case '7':
      //   findPatientByIdUI(hospital);
      //   break;
      case '7':
        findPatientByNameUI(hospital);
        break;
      case '8':
        showUpcomingAppointments(hospital);
        break;
      case '9':
        showPastAppointments(hospital);
        break;
      case '10':
        checkDoctorAvailabilityUI(hospital);
        break;
      case '11':
        registerPatientUI(hospital);
        break;
      case '12':
        registerDoctorUI(hospital);
        break;
      case '13':
        registerStaffUI(hospital);
        break;
      case '14':
        addRoomUI(hospital);
        break;
      case '15':
        addPrescriptionUI(hospital);
        break;
      case '0':
        print('Goodbye!');
        return;
      default:
        print('Invalid choice, please try again.');
    }

    await saveHospitalFile(hospital, filePath);
    print(' Data saved to $filePath');
  }
}

//  UI FUNCTION
void showAppointments(Hospital hospital) {
  print('\n--- All Appointments ---');
  if (hospital.appointments.isEmpty) {
    print('No appointments found.');
    return;
  }

  for (var a in hospital.appointments) {
    print(
      '${a.getId} | Patient: ${a.patient.getName} | Doctor: ${a.doctor.getName} | Date: ${a.getdate} | Status: ${a.status}',
    );
  }
}

void addAppointment(Hospital hospital) {
  print('\n--- Add New Appointment ---');
  if (hospital.patients.isEmpty || hospital.doctors.isEmpty) {
    print('Need at least one doctor and one patient.');
    return;  
  }
  print('\nAvailable Patients:');
  for (var i = 0; i < hospital.patients.length; i++) {
    print('${i + 1}. ${hospital.patients[i].getName}');
  }

  stdout.write('Choose patient number: ');
  final pIndex = int.tryParse(stdin.readLineSync() ?? '');
  if (pIndex == null || pIndex < 1 || pIndex > hospital.patients.length) {
    print(' Invalid patient selection.');
    return;
  }
  final patient = hospital.patients[pIndex - 1];

  print('\nAvailable Doctors:');
  for (var i = 0; i < hospital.doctors.length; i++) {
    print('${i + 1}. ${hospital.doctors[i].getName} (${hospital.doctors[i].specialization})');
  }

  stdout.write('Choose doctor number: ');
  final dIndex = int.tryParse(stdin.readLineSync() ?? '');
  if (dIndex == null || dIndex < 1 || dIndex > hospital.doctors.length) {
    print(' Invalid doctor selection.');
    return;
  }
  final doctor = hospital.doctors[dIndex - 1];
  stdout.write('Enter appointment date & time (YYYY-MM-DD HH:MM): ');
  final dateInput = stdin.readLineSync();

  try {
    final date = DateTime.parse(dateInput!.replaceFirst(' ', 'T'));
    for (var existing in hospital.appointments) {
      final diff = existing.getdate.difference(date).inMinutes.abs();
      if (diff < 60 &&
          (existing.doctor == doctor || existing.patient == patient)) {
        print(' Cannot create appointment .Reason doctor or patient is busy');
        return;
      }
    }
    hospital.addAppointment(Appointment(
      date: date,
      doctor: doctor,
      patient: patient,
    ));

    print(' Appointment added successfully at ${date.hour}:${date.minute.toString().padLeft(2, '0')} on ${date.toLocal().toIso8601String().split("T")[0]}.');
  } catch (e) {
    print(' Invalid date/time format. Please use YYYY-MM-DD HH:MM');
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
  final appointment = hospital.appointments
      .where((a) => a.getId == id)
      .toList();
  if (appointment.isEmpty) {
    print(' Appointment not found.');
    return;
  }
  hospital.cancelAppointment(appointment.first);
  print(' Appointment cancelled.');
}

void changeAppointment(Hospital hospital) {
  print('\n--- Change Appointment Date & Time ---');

  if (hospital.appointments.isEmpty) {
    print('No appointments to modify.');
    return;
  }

  showAppointments(hospital);

  stdout.write('Enter appointment ID to change: ');
  final id = stdin.readLineSync();

  final oldAppointments = hospital.appointments.where((a) => a.getId == id).toList();

  if (oldAppointments.isEmpty) {
    print('Appointment not found.');
    return;
  }
  final oldAppointment = oldAppointments.first;

  stdout.write('Enter new date and time (YYYY-MM-DD HH:MM): ');
  final newDateInput = stdin.readLineSync();
  if (newDateInput == null || newDateInput.trim().isEmpty) {
    print('Invalid date or time.');
    return;
  }
  try {
    final newDate = DateTime.parse(newDateInput.replaceFirst(' ', 'T'));
    final newAppointment = Appointment(
      patient: oldAppointment.patient,
      doctor: oldAppointment.doctor,
      date: newDate,
      status: oldAppointment.status,
    );
    hospital.changeAppointment(
      oldAppointment: oldAppointment,
      newAppointment: newAppointment,
    );
    print('Appointment updated successfully.');
  } catch (e) {
    print('Invalid date/time format. Please use YYYY-MM-DD HH:MM');
  }
}


//  REGISTRATION 


void registerPatientUI(Hospital hospital) {
  print('\n--- Register New Patient ---');
  stdout.write('Name: ');
  final name = stdin.readLineSync();
  stdout.write('Address: ');
  final address = stdin.readLineSync();
  stdout.write('Age: ');
  final age = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  stdout.write('Phone: ');
  final phone = stdin.readLineSync();
  stdout.write('Gender: ');
  final gender = stdin.readLineSync();

  final patient = Patient(
    name: name!,
    address: address!,
    age: age,
    phoneNumber: phone!,
    gender: gender!,
  );
  hospital.registerPatient(patient);
  print(' Patient registered.');
}

void registerDoctorUI(Hospital hospital) {
  print('\n--- Register New Doctor ---');
  stdout.write('Name: ');
  final name = stdin.readLineSync();
  stdout.write('Address: ');
  final address = stdin.readLineSync();
  stdout.write('Age: ');
  final age = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  stdout.write('Phone: ');
  final phone = stdin.readLineSync();
  stdout.write('Gender: ');
  final gender = stdin.readLineSync();

  print('Choose specialization:');
  for (var i = 0; i < Specialization.values.length; i++) {
    print('${i + 1}. ${Specialization.values[i].name}');
  }
  stdout.write('Select number: ');
  final specIndex = int.tryParse(stdin.readLineSync() ?? '') ?? 1;
  final specialization = Specialization.values[specIndex - 1];

  final doctor = Doctor(
    name: name!,
    address: address!,
    age: age,
    phoneNumber: phone!,
    gender: gender!,
    specialization: specialization,
  );
  hospital.registerDoctor(doctor);
  print(' Doctor registered.');
}

void registerStaffUI(Hospital hospital) {
  print('\n--- Register New Staff ---');

  stdout.write('Name: ');
  final name = stdin.readLineSync();
  if (name == null || name.isEmpty) {
    print(' Name cannot be empty.');
    return;
  }

  stdout.write('Address: ');
  final address = stdin.readLineSync();
  if (address == null || address.isEmpty) {
    print(' Address cannot be empty.');
    return;
  }

  stdout.write('Age: ');
  final age = int.tryParse(stdin.readLineSync() ?? '');
  if (age == null || age <= 0) {
    print(' Invalid age.');
    return;
  }

  stdout.write('Gender: ');
  final gender = stdin.readLineSync();
  if (gender == null || gender.isEmpty) {
    print(' Gender cannot be empty.');
    return;
  }

  stdout.write('Phone Number: ');
  final phoneNumber = stdin.readLineSync();
  if (phoneNumber == null || phoneNumber.isEmpty) {
    print(' Phone number cannot be empty.');
    return;
  }

  // Choose position
  print('Choose position:');
  for (var i = 0; i < Position.values.length; i++) {
    print('${i + 1}. ${Position.values[i].name}');
  }
  stdout.write('Select number: ');
  final posIndex = int.tryParse(stdin.readLineSync() ?? '');
  if (posIndex == null || posIndex < 1 || posIndex > Position.values.length) {
    print(' Invalid position.');
    return;
  }
  final position = Position.values[posIndex - 1];

  stdout.write('Salary: ');
  final salary = double.tryParse(stdin.readLineSync() ?? '');
  if (salary == null || salary < 0) {
    print(' Invalid salary.');
    return;
  }

  // Create staff and register
  final staff = Staff(
    name: name,
    address: address,
    age: age,
    gender: gender,
    phoneNumber: phoneNumber,
    position: position,
    salary: salary,
    bonus: 0,
    status: Status.onworking,
  );

  hospital.registerStaff(staff);
  print(' Staff registered successfully.');
}

void addRoomUI(Hospital hospital) {
  print('\n--- Add New Room ---');

  stdout.write('Room Name (e.g., A01): ');
  final roomName = stdin.readLineSync();
  if (roomName == null || roomName.isEmpty) {
    print(' Room name cannot be empty.');
    return;
  }

  // Choose Room Type
  print('Choose Room Type:');
  for (var i = 0; i < Roomtype.values.length; i++) {
    print('${i + 1}. ${Roomtype.values[i].name}');
  }
  stdout.write('Select number: ');
  final typeIndex = int.tryParse(stdin.readLineSync() ?? '');
  if (typeIndex == null ||
      typeIndex < 1 ||
      typeIndex > Roomtype.values.length) {
    print(' Invalid room type.');
    return;
  }
  final typeRoom = Roomtype.values[typeIndex - 1];
  final room = Room(
    roomName: roomName,
    typeRoom: typeRoom,
    status: Status.noActive,
    staffs: [],
  );

  hospital.addNewRoom(room);
  print(' Room added successfully.');
}

void addPrescriptionUI(Hospital hospital) {
  print('\n--- Add Prescription ---');

  if (hospital.patients.isEmpty ||
      hospital.doctors.isEmpty ||
      hospital.staffs.isEmpty) {
    print(
      ' Need at least one doctor, one patient, and one staff to add a prescription.',
    );
    return;
  }

  // Select patient
  print('\nAvailable Patients:');
  for (var i = 0; i < hospital.patients.length; i++) {
    print('${i + 1}. ${hospital.patients[i].getName}');
  }
  stdout.write('Choose patient number: ');
  final pIndex = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  if (pIndex < 1 || pIndex > hospital.patients.length) {
    print(' Invalid patient choice.');
    return;
  }
  final patient = hospital.patients[pIndex - 1];

  // Select doctor
  print('\nAvailable Doctors:');
  for (var i = 0; i < hospital.doctors.length; i++) {
    print('${i + 1}. ${hospital.doctors[i].getName}');
  }
  stdout.write('Choose doctor number: ');
  final dIndex = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  if (dIndex < 1 || dIndex > hospital.doctors.length) {
    print(' Invalid doctor choice.');
    return;
  }
  final doctor = hospital.doctors[dIndex - 1];

  // Select staff
  print('\nAvailable Staff:');
  for (var i = 0; i < hospital.staffs.length; i++) {
    print(
      '${i + 1}. ${hospital.staffs[i].getName} (${hospital.staffs[i].position})',
    );
  }
  stdout.write('Choose staff number: ');
  final sIndex = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  if (sIndex < 1 || sIndex > hospital.staffs.length) {
    print(' Invalid staff choice.');
    return;
  }
  final staff = hospital.staffs[sIndex - 1];

  // Enter diagnosis
  stdout.write('Enter diagnosis (comma separated if multiple): ');
  final diagInput = stdin.readLineSync() ?? '';
  final diagnosis = diagInput
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  // Enter total amount
  stdout.write('Enter total amount: ');
  final totalAmount = double.tryParse(stdin.readLineSync() ?? '');
  if (totalAmount == null || totalAmount < 0) {
    print(' Invalid amount.');
    return;
  }

  final prescription = Presciption(
    patient: patient,
    doctor: doctor,
    staff: staff,
    diagnosis: diagnosis,
    totalAmount: totalAmount,
  );

  hospital.addPresciption(prescription);
  print(' Prescription added successfully.');
}

void findAppointmentByDoctorUI(Hospital hospital) {
  print('\n--- Find Appointments by Doctor ---');
  if (hospital.doctors.isEmpty) {
    print('No doctors available.');
    return;
  }

  for (var i = 0; i < hospital.doctors.length; i++) {
    print('${i + 1}. ${hospital.doctors[i].getName}');
  }
  stdout.write('Choose doctor number: ');
  final choice = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  if (choice < 1 || choice > hospital.doctors.length) return;

  final doctor = hospital.doctors[choice - 1];
  final appointments = hospital.findAppointmentByDoctor(doctor);

  if (appointments.isEmpty) {
    print('No appointments for ${doctor.getName}.');
  } else {
    print('Appointments for ${doctor.getName}:');
    for (var a in appointments) {
      print('${a.getId} | ${a.getdate} | Patient: ${a.patient.getName}');
    }
  }
}

void findAppointmentByPatientUI(Hospital hospital) {
  print('\n--- Find Appointments by Patient ---');
  if (hospital.patients.isEmpty) {
    print('No patients available.');
    return;
  }

  for (var i = 0; i < hospital.patients.length; i++) {
    print('${i + 1}. ${hospital.patients[i].getName}');
  }
  stdout.write('Choose patient number: ');
  final choice = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  if (choice < 1 || choice > hospital.patients.length) return;

  final patient = hospital.patients[choice - 1];
  final appointments = hospital.findAppointmentByPatient(patient);

  if (appointments.isEmpty) {
    print('No appointments for ${patient.getName}.');
  } else {
    print('Appointments for ${patient.getName}:');
    for (var a in appointments) {
      print('${a.getId} | ${a.getdate} | Doctor: ${a.doctor.getName}');
    }
  }
}

void findPatientByIdUI(Hospital hospital) {
  stdout.write('Enter patient ID: ');
  final id = stdin.readLineSync();
  if (id == null || id.isEmpty) return;

  try {
    final patient = hospital.findPatientById(id);
    print(
      'Found: ${patient.getName}, Age: ${patient.getAge}, Gender: ${patient.gender}',
    );
  } catch (_) {
    print('Patient not found.');
  }
}

void findPatientByNameUI(Hospital hospital) {
  stdout.write('Enter patient name: ');
  final name = stdin.readLineSync();
  if (name == null || name.isEmpty) return;

  try {
    final patient = hospital.findPatientByName(name);
    print(
      'Found: ${patient.getName}, Age: ${patient.getAge}, Gender: ${patient.gender}',
    );
  } catch (_) {
    print('Patient not found.');
  }
}

void showUpcomingAppointments(Hospital hospital) {
  hospital.updateAppointmentStatuses(); 
  final upcoming = hospital.getUpcomingAppointments();
  if (upcoming.isEmpty) {
    print('No upcoming appointments.');
  } else {
    print('Upcoming Appointments:');
    for (var a in upcoming) {
      print('${a.getId} | ${a.getdate} | ${a.patient.getName} => ${a.doctor.getName}');
    }
  }
}

void showPastAppointments(Hospital hospital) {
  hospital.updateAppointmentStatuses(); 
  final past = hospital.getPastAppointments();
  if (past.isEmpty) {
    print('No past appointments.');
  } else {
    print('Past Appointments:');
    for (var a in past) {
      print('${a.getId} | ${a.getdate} | ${a.patient.getName} => ${a.doctor.getName}');
    }
  }
}

void checkDoctorAvailabilityUI(Hospital hospital) {
  if (hospital.doctors.isEmpty) {
    print('No doctors available.');
    return;
  }

  for (var i = 0; i < hospital.doctors.length; i++) {
    print('${i + 1}. ${hospital.doctors[i].getName}');
  }
  stdout.write('Choose doctor number: ');
  final choice = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  if (choice < 1 || choice > hospital.doctors.length) return;

  final doctor = hospital.doctors[choice - 1];
  stdout.write('Enter date (YYYY-MM-DD): ');
  final dateInput = stdin.readLineSync();
  if (dateInput == null || dateInput.isEmpty) return;

  try {
    final date = DateTime.parse(dateInput);
    final available = hospital.isDoctorAvailable(doctor, date);
    print(
      available
          ? '${doctor.getName} is available on ${date.toIso8601String().split("T")[0]}'
          : '${doctor.getName} is NOT available on ${date.toIso8601String().split("T")[0]}',
    );
  } catch (_) {
    print('Invalid date format.');
  }
}

void findByDoctor(Hospital hospital) {
  print('\n--- Find Appointments by Doctor ---');

  if (hospital.doctors.isEmpty) {
    print('No doctors available.');
    return;
  }
  for (var i = 0; i < hospital.doctors.length; i++) {
    final doctor = hospital.doctors[i];
    print('${i + 1}. ${doctor.getName}');
  }
  stdout.write('\nChoose doctor number: ');
  final input = stdin.readLineSync();
  if (input == null || input.isEmpty) {
    print('No input provided.');
    return;
  }
  final choice = int.tryParse(input);
  if (choice == null || choice < 1 || choice > hospital.doctors.length) {
    print('Invalid choice.');
    return;
  }
  final doctor = hospital.doctors[choice - 1];
  final appointments = hospital.findAppointmentByDoctor(doctor);
  print('\n--- Appointments for ${doctor.getName} ---');
  if (appointments.isEmpty) {
    print('No appointments found.');
  } else {
    for (var a in appointments) {
      print('• ID: ${a.getId}');
      print('  Date: ${a.getdate}');
      print('  Patient: ${a.patient.getName}');
      print('');
    }
  }
}

void findByPatient(Hospital hospital) {
  print('\n--- Find Appointments by Patient ---');
  if (hospital.patients.isEmpty) {
    print('No patients available.');
    return;
  }
  for (var i = 0; i < hospital.patients.length; i++) {
    print('${i + 1}. ${hospital.patients[i].getName}');
  }

  stdout.write('Choose patient number: ');
  final choice = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  if (choice < 1 || choice > hospital.patients.length) {
    print('Invalid choice.');
    return;
  }

  final patient = hospital.patients[choice - 1];
  final appointments = hospital.findAppointmentByPatient(patient);

  if (appointments.isEmpty) {
    print('No appointments found for ${patient.getName}.');
  } else {
    print('Appointments for ${patient.getName}:');
    for (var a in appointments) {
      print('${a.getId} | ${a.getdate} | Doctor: ${a.doctor.getName}');
    }
  }
}
