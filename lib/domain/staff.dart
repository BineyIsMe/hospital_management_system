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
    required super.gender,
    required super.phoneNumber,
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
   Map<String, dynamic> toJson() => {
        'name': getName,
        'address': getAddress,
        'age': getAge,
        'gender': gender,
        'phoneNumber': getPhoneNumber,
        'position': position.name,
        'salary': salary,
        'bonus': bonus,
        'status': status.name,
      };
  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
        name: json['name'],
        address: json['address'],
        age: json['age'],
        gender: json['gender'],
        phoneNumber: json['phoneNumber'],
        position: Position.values.firstWhere(
          (e) => e.name == json['position'],
          orElse: () => Position.other,
        ),
        salary: (json['salary'] ?? 0).toDouble(),
        bonus: (json['bonus'] ?? 0).toDouble(),
        status: Status.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => Status.noActive,
        ),
      );
}
