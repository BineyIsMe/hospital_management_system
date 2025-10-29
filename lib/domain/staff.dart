import 'package:project1/domain/person.dart';

enum Position { nurse, receptionist, janitor, pharmacist }

enum Status { inActive, noActive, onworking }

class Staff extends Person {
  final Position position;
  double salary;
  double bonus;
  Status status;

  Staff({
    required super.name,
    required super.address,
    required super.age,
    required this.position,
    this.salary = 0,
    this.bonus = 0,
    this.status = Status.noActive,
  });
}
