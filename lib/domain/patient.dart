import 'package:project1/domain/person.dart';

class Patient extends Person {
  Patient({required super.name, required super.address, required super.age});
   @override
  String toString() {
    return 'Patient(id: $getId, name: $getName, age: $getAge, address: $getAddress)';
  }
}
