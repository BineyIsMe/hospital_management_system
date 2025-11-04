import 'dart:io';
import 'dart:convert';

import 'package:project1/domain/hospital.dart';



Future<void> saveHospitalFile(Hospital hospital, String filePath) async {
  final file = File(filePath);
  await file.writeAsString(jsonEncode(hospital.toJson()));
  print('Hospital data saved.');
}

Future<Hospital> loadHospitalFile(String filePath) async {
  final file = File(filePath);
  final content = await file.readAsString();
  return Hospital.fromJson(jsonDecode(content));
}
