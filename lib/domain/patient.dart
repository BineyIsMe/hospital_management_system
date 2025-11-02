import 'package:project1/domain/person.dart';

class Patient extends Person {
  Patient({
    required super.name,
    required super.address,
    required super.age,
    required super.phoneNumber,
    required super.gender,
  });
  @override
  String toString() {
    return 'Patient(id: $getId, name: $getName, age: $getAge, address: $getAddress)';
  }
  Map<String, dynamic> toJson() => {
        'name': getName,
        'address': getAddress,
        'age': getAge,
        'phoneNumber': getPhoneNumber,
        'gender': gender,
      };

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        name: json['name'],
        address: json['address'],
        age: json['age'],
        phoneNumber: json['phoneNumber'],
        gender: json['gender'],
      );
}
