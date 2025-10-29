import 'package:uuid/uuid.dart';

abstract class  Person  {
  final String _id;
  final String _name;
  final String _address;
  int _age;
  static var idGenerator = Uuid();
  Person({required String name, required String address, required int age})
    : _id = idGenerator.v4(),
      _name = name,
      _address = address,
      _age = age;
      
}
