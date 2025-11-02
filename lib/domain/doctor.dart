import 'package:project1/domain/staff.dart';

enum Specialization { oncology, hematology, cardiology, neurology, other }

class Doctor extends Staff {
  final Specialization specialization;

  Doctor({
    required super.name,
    required super.address,
    required super.age,
    required super.phoneNumber,
    required super.gender,
    super.bonus,
    super.salary,
    super.status,
    this.specialization = Specialization.other,
  });
   @override
  String toString() {
    return 'Doctor(name: $getName, age: $getAge, address: $getAddress, '
        'position: $position, salary: $salary, bonus: $bonus, '
        'status: $status, Specialization: $specialization)';
  }
   Map<String, dynamic> toJson() => {
        'name': getName,
        'address': getAddress,
        'age': getAge,
        'phoneNumber': getPhoneNumber,
        'gender': gender,
        'specialization': specialization.name,
      };

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        name: json['name'],
        address: json['address'],
        age: json['age'],
        phoneNumber: json['phoneNumber'],
        gender: json['gender'],
        specialization: Specialization.values.firstWhere(
          (e) => e.name == json['specialization'],
          orElse: () => Specialization.other,
        ),
      );
}
