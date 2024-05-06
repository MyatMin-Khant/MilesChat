
import 'dart:io';

import 'package:http/http.dart' as http;


Future<int> checkInternetConnection() async {
  try {
    final response = await http.get(Uri.parse('https://www.google.com'));

    if (response.statusCode == 200) {
      return 1;
    } else {
 
      return 0;
    }

  } on SocketException catch(_) {
    return 0;
  } catch (_) {
    return 0;
  }
    
  }