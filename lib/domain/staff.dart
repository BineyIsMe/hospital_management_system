import 'package:project1/domain/person.dart';

enum Position { nurse, receptionist, janitor, pharmacist,other }

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
    this.position = Position.other,
    this.salary = 0,
    this.bonus = 0,
    this.status = Status.noActive,
  });
   @override
  String toString() {
    return 'Staff(name: ${super.getName}, age: ${super.getAge}, address: ${super.getAddress}, '
        'position: $position, salary: $salary, bonus: $bonus, status: $status)';
  }
}
