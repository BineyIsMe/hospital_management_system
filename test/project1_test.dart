import 'package:test/test.dart';
import 'package:project1/domain/hospital.dart';
import 'package:project1/domain/patient.dart';
import 'package:project1/domain/doctor.dart';
import 'package:project1/domain/staff.dart';
import 'package:project1/domain/room.dart';
import 'package:project1/domain/appointment.dart';
import 'package:project1/domain/presciption.dart';

void main() {
  group('Hospital class tests', () {
    late Hospital hospital;
    late Patient patient1;
    late Doctor doctor1;
    late Staff staff1;
    late Room room1;
    late Appointment appointment1;
    late Presciption prescription1;

    setUp(() {
      patient1 = Patient(
          name: 'John Doe',
          age: 30,
          gender: 'M',
          address: '123 Street',
          phoneNumber: "123");
      doctor1 = Doctor(
          name: 'Dr. Smith',
          age: 45,
          gender: 'M',
          address: '456 Street',
          phoneNumber: "321");
      staff1 = Staff(
          name: 'Nurse Jane',
          age: 28,
          gender: 'F',
          address: '789 Street',
          position: Position.nurse,
          salary: 2000,
          bonus: 100,
          status: Status.onworking,
          phoneNumber: "3214");
      room1 = Room(
          typeRoom: Roomtype.private,
          status: Status.noActive,
          staffs: [staff1],
          roomName: "a01");
      appointment1 = Appointment(
          patient: patient1,
          doctor: doctor1,
          date: DateTime.now(),
          status: AppointmentStatus.notYet);
      prescription1 = Presciption(
          patient: patient1,
          doctor: doctor1,
          diagnosis: ['Paracetamol'],
          totalAmount: 300.0,
          staff: staff1);

      hospital = Hospital(
        doctors: [],
        patients: [],
        staffs: [],
        rooms: [],
        appointments: [],
        presciptions: [],
      );
    });

    test('Register patient', () {
      hospital.registerPatient(patient1);
      expect(hospital.patients.length, 1);
      expect(hospital.patients.first.getName, 'John Doe');
    });

    test('Register doctor', () {
      hospital.registerDoctor(doctor1);
      expect(hospital.doctors.length, 1);
      expect(hospital.doctors.first.getName, 'Dr. Smith');
    });

    test('Register staff', () {
      hospital.registerStaff(staff1);
      expect(hospital.staffs.length, 1);
      expect(hospital.staffs.first.getName, 'Nurse Jane');
    });

    test('Add room', () {
      hospital.addNewRoom(room1);
      expect(hospital.rooms.length, 1);
      expect(hospital.rooms.first.roomName, 'a01');
    });

    test('Add appointment', () {
      hospital.addAppointment(appointment1);
      expect(hospital.appointments.length, 1);
      expect(hospital.appointments.first.patient.getName, 'John Doe');
    });

    test('Cancel appointment', () {
      hospital.addAppointment(appointment1);
      hospital.cancelAppointment(appointment1);
      expect(hospital.appointments.length, 0);
    });

    test('Find appointment by doctor', () {
      hospital.addAppointment(appointment1);
      final result = hospital.findAppointmentByDoctor(doctor1);
      expect(result.length, 1);
      expect(result.first.doctor.getName, 'Dr. Smith');
    });

    test('Find appointment by patient', () {
      hospital.addAppointment(appointment1);
      final result = hospital.findAppointmentByPatient(patient1);
      expect(result.length, 1);
      expect(result.first.patient.getName, 'John Doe');
    });

    test('Change appointment', () {
      final newAppointment = Appointment(
        patient: patient1,
        doctor: doctor1,
        date: DateTime.now().add(Duration(days: 1)),
        status: AppointmentStatus.notYet,
      );
      hospital.addAppointment(appointment1);
      hospital.changeAppointment(
          oldAppointment: appointment1, newAppointment: newAppointment);
      expect(hospital.appointments.contains(newAppointment), true);
      expect(hospital.appointments.contains(appointment1), false);
    });

    test('Check available rooms', () {
      hospital.addNewRoom(room1);
      final available = hospital.checkRoomAvailable();
      expect(available.length, 1);
      expect(available.first.status, Status.noActive);
    });

    test('Add prescription', () {
      hospital.addPresciption(prescription1);
      expect(hospital.presciptions.length, 1);
      expect(hospital.presciptions.first.getDiagnosis, contains('Paracetamol'));
    });

    // --- NEW TESTS BELOW ---

    test('Find patient by ID', () {
      hospital.registerPatient(patient1);
      final result = hospital.findPatientById(patient1.getId);
      expect(result.getName, 'John Doe');
    });

    test('Find patient by name', () {
      hospital.registerPatient(patient1);
      final result = hospital.findPatientByName('John Doe');
      expect(result.getId, patient1.getId);
    });

    test('Get upcoming appointments (inProgress)', () {
      final a1 = Appointment(
        patient: patient1,
        doctor: doctor1,
        date: DateTime.now(),
        status: AppointmentStatus.inProgress,
      );
      hospital.addAppointment(a1);
      final result = hospital.getUpcomingAppointments();
      expect(result.length, 1);
      expect(result.first.status, AppointmentStatus.inProgress);
    });

    test('Get past appointments (finished)', () {
      final a1 = Appointment(
        patient: patient1,
        doctor: doctor1,
        date: DateTime.now().subtract(Duration(days: 2)),
        status: AppointmentStatus.finished,
      );
      hospital.addAppointment(a1);
      final result = hospital.getPastAppointments();
      expect(result.length, 1);
      expect(result.first.status, AppointmentStatus.finished);
    });

    test('Doctor availability check', () {
      final date = DateTime.now();
      final busyAppointment = Appointment(
          patient: patient1,
          doctor: doctor1,
          date: date,
          status: AppointmentStatus.notYet);
      hospital.addAppointment(busyAppointment);

      final isAvailable = hospital.isDoctorAvailable(doctor1, date);
      final isAvailableOtherDate =
          hospital.isDoctorAvailable(doctor1, date.add(Duration(days: 1)));

      expect(isAvailable, false);
      expect(isAvailableOtherDate, true);
    });

    test('Hospital toJson and fromJson', () {
      hospital.registerDoctor(doctor1);
      hospital.registerPatient(patient1);
      hospital.registerStaff(staff1);
      hospital.addNewRoom(room1);
      hospital.addAppointment(appointment1);
      hospital.addPresciption(prescription1);

      final jsonData = hospital.toJson();
      final newHospital = Hospital.fromJson(jsonData);

      expect(newHospital.doctors.first.getName, doctor1.getName);
      expect(newHospital.patients.first.getName, patient1.getName);
      expect(newHospital.staffs.first.getName, staff1.getName);
      expect(newHospital.rooms.first.roomName, room1.roomName);
      expect(newHospital.appointments.first.patient.getName,
          appointment1.patient.getName);
      expect(newHospital.presciptions.first.getDiagnosis,
          prescription1.getDiagnosis);
    });
  });
}
