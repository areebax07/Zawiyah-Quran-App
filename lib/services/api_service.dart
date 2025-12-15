import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://api.alquran.cloud/v1';

  Future<List<dynamic>> getSurahList() async {
    try {
      final response = await _dio.get('$_baseUrl/meta');
      if (response.statusCode == 200) {
        return response.data['data']['surahs']['references'];
      } else {
        throw Exception('Failed to load surah list');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to connect to the server');
    }
  }

  Future<Map<String, dynamic>> getSurah(int surahNumber) async {
    try {
      final response = await _dio.get('$_baseUrl/surah/$surahNumber');
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to load surah #$surahNumber');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to connect to the server');
    }
  }

  // FIX: I have modified the method to return the entire 'data' object (a Map<String, dynamic>)
  // which includes both timings and date information. I also added the country parameter.
  Future<Map<String, dynamic>> getPrayerTimes(String city, [String? country]) async {
    final String prayerApiUrl = 'http://api.aladhan.com/v1/timingsByCity';

    try {
      final response = await _dio.get(
        prayerApiUrl,
        queryParameters: {
          'city': city,
          'country': country ?? '',
          'method': 8, // Muslim World League
        },
      );

      if (response.statusCode == 200 && response.data['code'] == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to load prayer times: ${response.data['status']}');
      }
    } on DioError catch (e) {
      print(e.message);
      throw Exception('Failed to connect to the prayer times service. Check your internet connection.');
    } catch (e) {
      print(e);
      throw Exception('An unexpected error occurred while fetching prayer times.');
    }
  }
  
  Future<List<dynamic>> getRamadanCalendar(String city, String country) async {
    final String calendarApiUrl = 'http://api.aladhan.com/v1/hijriCalendarByCity';
    final now = DateTime.now();
    final formattedDate = "${now.day}-${now.month}-${now.year}";
    
    try {
      final hijriYearResponse = await _dio.get('http://api.aladhan.com/v1/gToH', queryParameters: {'date': formattedDate});
      final String hijriYear = hijriYearResponse.data['data']['hijri']['year'];

      final response = await _dio.get(
        calendarApiUrl,
        queryParameters: {
          'city': city,
          'country': country,
          'method': 8, 
          'month': 9,   
          'year': hijriYear,
        },
      );

      if (response.statusCode == 200 && response.data['code'] == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to load calendar: ${response.data['status']}');
      }
    } on DioError catch (e) {
      print(e.message);
      throw Exception('Failed to connect to the calendar service. Check your connection.');
    } catch (e) {
      print(e);
      throw Exception('An unexpected error occurred while fetching the calendar.');
    }
  }

  Future<List<dynamic>> getDuaList() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/duas.json');
      return json.decode(jsonString) as List<dynamic>;
    } catch (e) {
      print(e);
      throw Exception('Failed to load duas from local assets.');
    }
  }
}
