import 'package:uuid/uuid.dart';

abstract class Person {
  final String _id;
  final String _name;
  final String _address;
  int _age;
  final String _phoneNumber;
  final String gender;
  static var idGenerator = Uuid();
  Person({
    required String name,
    required String address,
    required int age,
    required String phoneNumber,
    required this.gender,
  }) : _id = idGenerator.v4(),
       _name = name,
       _address = address,
       _age = age,
       _phoneNumber = phoneNumber;
  String get getId => _id;
  String get getName => _name;
  String get getAddress => _address;
  int get getAge => _age;
  String get getPhoneNumber => _phoneNumber;
  set setAge(int int) => _age = int;

  @override
  String toString();
}
