  import 'package:project1/domain/appointment.dart';
  import 'package:project1/domain/doctor.dart';
  import 'package:project1/domain/patient.dart';
  import 'package:project1/domain/presciption.dart';
  import 'package:project1/domain/room.dart';
  import 'package:project1/domain/staff.dart';

  class Hospital {
    final List<Doctor> doctors;
    final List<Patient> patients;
    final List<Staff> staffs;
    final List<Room> rooms;
    final List<Appointment> appointments;
    final List<Presciption> presciptions;
    Hospital({
      required this.doctors,
      required this.appointments,
      required this.patients,
      required this.staffs,
      required this.rooms,
      required this.presciptions,
    });
  void registerPatient(Patient patient) {
    final exists = patients.any((p) => p.getName == patient.getName);
    if (exists) {
      print("User already exists");
      return;
    }
    patients.add(patient);
  }

  void registerDoctor(Doctor doctor) {
    final exists = doctors.any((d) => d.getName == doctor.getName);
    if (exists) {
      print("User already exists");
      return;
    }
    doctors.add(doctor);
  }


  void registerStaff(Staff staff) {
    final exists = staffs.any((s) => s.getName == staff.getName);
    if (exists) {
      print("User already exists");
      return;
    }
    staffs.add(staff);
  }


  void addNewRoom(Room room) {
    final exists = rooms.any((r) => r.roomName == room.roomName);
    if (exists) {
      print("Room already exists");
      return;
    }
    rooms.add(room);
  }


    void addAppointment(Appointment appointment) {
      for (var element in appointments) {
        if (element.getdate == appointment.getdate &&
            element.patient == appointment.patient &&
            element.doctor == appointment.doctor) {
          print("Appointment already exists");
          return;
        }
      }

      appointments.add(appointment);
    }

    void addPresciption(Presciption presciption) {
      presciptions.add(presciption);
    }

    void cancelAppointment(Appointment appointment) {
      final exists = appointments.any((a) => a.getId == appointment.getId);
      if (exists) {
        appointments.removeWhere((a) => a.getId == appointment.getId);
        print('Appointment with id ${appointment.getId} has been canceled.');
      } else {
        print('Appointment with id ${appointment.getId} was not found.');
      }
    }

    List<Appointment> findAppointmentByDoctor(Doctor doctor) {
      final List<Appointment> doctorAppointments = [];
      for (var a in appointments) {
        if (a.doctor.getId == doctor.getId) {
          doctorAppointments.add(a);
        }
      }
      return doctorAppointments;
    }

    List<Appointment> findAppointmentByPatient(Patient patient) {
      final List<Appointment> patientAppointments = [];
      for (var a in appointments) {
        if (a.patient.getId == patient.getId) {
          patientAppointments.add(a);
        }
      }
      return patientAppointments;
    }

    void changeAppointment({
      required Appointment oldAppointment,
      required Appointment newAppointment,
    }) {
      final exists = appointments.any((a) => a.getId == oldAppointment.getId);
      if (exists) {
        appointments.removeWhere((a) => a.getId == oldAppointment.getId);
        appointments.add(newAppointment);
        print("Update succesfully");
      } else {
        print("appointment not exists yet");
      }
    }
    List<Room> checkAvailable() =>
      rooms.where((room) => room.status == Status.noActive).toList();

  }
