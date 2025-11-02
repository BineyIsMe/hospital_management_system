import 'package:project1/domain/patient.dart';
import 'package:project1/domain/staff.dart';
import 'package:uuid/uuid.dart';

enum Roomtype { icu, or, private, appointment, general }

class Room {
  final String _id;
  final String roomName;
  final Roomtype _typeRoom;
  static var idGenerator = Uuid();
  final Patient? patient;
  List<Staff> staffs;
  Status status;

  Room({
    required this.roomName,
    required Roomtype typeRoom,
    required this.status,
    required this.staffs,
    this.patient,
  })  : _id = idGenerator.v4(),
        _typeRoom = typeRoom;

  String get getId => _id;
  Roomtype get typeRoom => _typeRoom;

  @override
  String toString() {
    return 'Room(id: $_id, roomName: $roomName, type: $_typeRoom, status: $status, '
        'patient: ${patient?.getName ?? "No patient"}, '
        'staffs: ${staffs.map((s) => s.getName).join(", ")})';
  }
  void changeStatus(Status newStatus)=> status=newStatus;
   Map<String, dynamic> toJson() => {
        'id': _id,
        'roomName': roomName,
        'typeRoom': _typeRoom.name,
        'status': status.name,
        'staffs': staffs.map((s) => s.toJson()).toList(),
        'patient': patient?.toJson(),
      };

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        roomName: json['roomName'],
        typeRoom: Roomtype.values.firstWhere(
          (e) => e.name == json['typeRoom'],
          orElse: () => Roomtype.general,
        ),
        status: Status.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => Status.noActive,
        ),
        staffs:
            (json['staffs'] as List).map((s) => Staff.fromJson(s)).toList(),
        patient:
            json['patient'] != null ? Patient.fromJson(json['patient']) : null,
      );


}
