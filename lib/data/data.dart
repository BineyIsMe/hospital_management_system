import 'dart:io';
import 'dart:convert';

import 'package:project1/domain/hospital.dart';



void saveHospitalFile(Hospital hospital) async {
  final file = File('hospital.json');
  await file.writeAsString(jsonEncode(hospital.toJson()));
  print('Hospital data saved.');
}

Future<Hospital> loadHospitalFile() async {
  final file = File('hospital.json');
  final content = await file.readAsString();
  return Hospital.fromJson(jsonDecode(content));
}
