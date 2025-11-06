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
Future<Hospital> loadOrCreateHospital(String filePath, Hospital defaultHospital) async {
  final file = File(filePath);

  if (await file.exists()) {
    try {
      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        await saveHospitalFile(defaultHospital, filePath);
        return defaultHospital;
      }
      final hospital = Hospital.fromJson(jsonDecode(content));
      print(' Hospital data loaded from $filePath');
      return hospital;

    } catch (e) {
      print(' Failed to parse $filePath: $e');
      print(' Overwriting with default hospital.');
      await saveHospitalFile(defaultHospital, filePath);
      return defaultHospital;
    }

  } else {
    await file.create(recursive: true);
    await saveHospitalFile(defaultHospital, filePath);
    print(' Created new hospital file at $filePath');
    return defaultHospital;
  }
}
