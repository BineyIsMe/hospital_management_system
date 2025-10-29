import 'package:project1/domain/staff.dart';

enum Department { oncology, hematology, cardiology, neurology, other }

class Doctor extends Staff {
  final Department department;

  Doctor({
    required super.name,
    required super.address,
    required super.age,
    super.bonus,
    super.salary,
    super.status,
    this.department = Department.other,
  });
   @override
  String toString() {
    return 'Doctor(name: $getName, age: $getAge, address: $getAddress, '
        'position: $position, salary: $salary, bonus: $bonus, '
        'status: $status, department: $department)';
  }
}
