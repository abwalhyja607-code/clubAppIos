import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';


class Crud {
  getReq(String url)async{
    try{

      var res =  await http.get(Uri.parse(url));

      // print("Response body: ${res.body}"); // Add this line

      if(res.statusCode == 200){
        // print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        var resBody = jsonDecode(res.body);
        return resBody ;
      }else{
        print("Error : ${res.statusCode}");
      }
    }catch(e){
      print("Error catch : $e");
    }
  }

  // postReq(String url , Map data , {Map<String, String>? headers})async{
  //   try{
  //
  //     var res =  await http.post(Uri.parse(url) , body: data  , headers: headers);
  //
  //     // print("Response body: ${res.body}"); // Add this line
  //
  //     var resBody = jsonDecode(res.body );
  //     return resBody ;
  //
  //     if(res.statusCode == 200){
  //
  //       var resBody = jsonDecode(res.body);
  //       return resBody ;
  //     }else{
  //       print("Error mmmmmmmmmmmm : ${res.statusCode}");
  //     }
  //   }catch(e){
  //     print("Error catch : $e");
  //   }
  // }


  Future<Map<String, dynamic>> postReq(String url, Map data) async {
    try {
      final response = await http.post(Uri.parse(url), body: data);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);
        return decoded is Map<String, dynamic> ? decoded : {"status": "error", "message": "Invalid format"};
      } else {
        return {"status": "error", "message": "Server error"};
      }
    } catch (e) {
      print("Error in postReq: $e");
      return {"status": "error", "message": "Network error"};
    }
  }



  // طلب GET مع إمكانية تمرير header



  // طلب GET مع إمكانية تمرير headers
  Future getReqH(String url, {Map<String, String>? headers}) async {
    try{

      var res =  await http.get(Uri.parse(url) , headers:headers );

      // print("Response body: ${res.body}"); // Add this line

      if(res.statusCode == 200){
        // print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        var resBody = jsonDecode(res.body);
        return resBody ;
      }else{
        print("Error : ${res.statusCode}");
      }
    }catch(e){
      print("Error catch : $e");
    }
  }




  // طلب POST مع إمكانية تمرير headers
  Future<dynamic> postReqH(String url, Map data, {Map<String, String>? headers}) async {
    try {
      var res =  await http.post(Uri.parse(url) , headers:headers  , body: data);

      // print("Response body: ${res.body}"); // Add this line

      if(res.statusCode == 200){
        // print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        var resBody = jsonDecode(res.body);
        return resBody ;
      }else{
        print("Error : ${res.statusCode}");
      }
    } catch (e) {
      print("POST Exception: $e");
    }
  }














}









class CrudDio {
  Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  // طلب GET بدون headers
  Future getReq(String url) async {
    try {
      var res = await dio.get(url);
      return res.data;
    } catch (e) {
      _handleError(e);
    }
  }

  // طلب POST بدون headers
  Future postReq(String url, Map data) async {
    try {
      var res = await dio.post(url, data: data);
      return res.data;
    } catch (e) {
      _handleError(e);
    }
  }

  // طلب GET مع headers
  Future getReqH(String url, {Map<String, String>? headers}) async {
    try {
      var res = await dio.get(
        url,
        options: Options(headers: headers),
      );
      return res.data;
    } catch (e) {
      _handleError(e);
    }
  }

  // طلب POST مع headers
  Future postReqH(String url, Map data, {Map<String, String>? headers}) async {
    try {
      var res = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      return res.data;
    } catch (e) {
      _handleError(e);
    }
  }

  // دالة لمعالجة الأخطاء
  void _handleError(dynamic e) {
    if (e is DioException) {
      print("Dio error: ${e.response?.data ?? e.message}");
    } else {
      print("Unexpected error: $e");
    }
  }
}










