

import 'package:device_info/device_info.dart';

Future<String> getDeviceID() async {
  final DeviceInfoPlugin infoplugin = DeviceInfoPlugin(); 
  final androiddeviceinfo = await infoplugin.androidInfo;
  return androiddeviceinfo.androidId;
}