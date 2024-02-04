import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  Future<bool> checkSession(String sessionToken) async {
    final Dio dio = Dio();

    try {
      //source check sessiom di sini
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String sessionToken = prefs.getString('session') ?? "";
      Map fdataMap = {'session_token': sessionToken};
      FormData fdata = FormData();
      fdata.fields
          .addAll(fdataMap.entries.map((e) => MapEntry(e.key, e.value)));
      final response = await dio.post(
        'https://lualimastuff.000webhostapp.com/session.php/',
        data: fdata,
      );

      log("check session $response");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.data);
        return data['status'] == 'succes';
      }
    } catch (error) {
      // Handle error if needed
    }
    return false;
  }

  Future logout() async {
    final Dio dio = Dio();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String sessionToken = prefs.getString('session') ?? "";
    Map fdataMap = {'session_token': sessionToken};
    FormData fdata = FormData();
    fdata.fields.addAll(fdataMap.entries.map((e) => MapEntry(e.key, e.value)));
    final response = await dio.post(
      'https://lualimastuff.000webhostapp.com/logout.php/',
      data: fdata,
    );
    prefs.remove('session_token');
  }

  Future login({required String username, required String password}) async {
    final Dio dio = Dio();
    Map fdataMap = {'user': username, 'pwd': password};
    FormData fdata = FormData();
    fdata.fields.addAll(fdataMap.entries.map((e) => MapEntry(e.key, e.value)));

    final response = await dio.post(
      'https://lualimastuff.000webhostapp.com/login.php/',
      data: fdata,
    );
    log("res $response");
    Map repoResponse = {"status": false, "data": Null};
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.data);
      if (data['status'] == 'success') {
        repoResponse['status'] = true;
        repoResponse['data'] = data;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('session', data['session_token']);
      } else {
        repoResponse['data'] = data;
      }
    }
    return repoResponse;
  }
}
