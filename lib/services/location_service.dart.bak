import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Timer? _periodicTimer;
  bool _isTracking = false;
  List<Map<String, dynamic>> _offlineQueue = [];
  static const String _offlineQueueKey = 'offline_location_queue';

  bool get isTracking => _isTracking;

  Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) return null;
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
    } catch (e) {
      debugPrint('Error getting position: $e');
      return null;
    }
  }

  Future<void> startTracking({
    Duration interval = const Duration(minutes: 10),
    required String authToken,
  }) async {
    if (_isTracking) return;
    final hasPermission = await checkPermissions();
    if (!hasPermission) throw Exception('Location permissions not granted');

    _isTracking = true;
    await _loadOfflineQueue();
    if (_offlineQueue.isNotEmpty) await _syncOfflineLocations(authToken);
    await checkIn(authToken: authToken, checkType: 'checkin');

    _periodicTimer = Timer.periodic(interval, (timer) async {
      await checkIn(authToken: authToken, checkType: 'periodic');
    });
    debugPrint('Location tracking started');
  }

  void stopTracking() {
    _periodicTimer?.cancel();
    _isTracking = false;
    debugPrint('Location tracking stopped');
  }

  Future<Map<String, dynamic>> checkIn({
    required String authToken,
    String checkType = 'manual',
  }) async {
    try {
      final position = await getCurrentPosition();
      if (position == null) {
        return {'success': false, 'message': 'Could not get location'};
      }

      final locationData = {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'altitude': position.altitude,
        'speed': position.speed,
        'heading': position.heading,
        'check_type': checkType,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      };

      final result = await _sendCheckIn(locationData, authToken);
      if (!result['success']) await _addToOfflineQueue(locationData);
      return result;
    } catch (e) {
      debugPrint('Check-in error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> _sendCheckIn(Map<String, dynamic> locationData, String authToken) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/crm/location/checkin'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
        },
        body: jsonEncode(locationData),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'message': data['message'] ?? 'Check-in successful', 'data': data['data']};
      }
      return {'success': false, 'message': 'Server error: ${response.statusCode}'};
    } catch (e) {
      return {'success': false, 'message': 'Network error'};
    }
  }

  Future<Map<String, dynamic>> getStatus({required String authToken}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/crm/location/status'),
        headers: {'Authorization': 'Bearer $authToken', 'Accept': 'application/json'},
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
      return {'success': false, 'message': 'Failed to get status'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getTodayStats({required String authToken}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/crm/location/today'),
        headers: {'Authorization': 'Bearer $authToken', 'Accept': 'application/json'},
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
      return {'success': false, 'message': 'Failed to get stats'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<void> _loadOfflineQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final queueJson = prefs.getString(_offlineQueueKey);
    if (queueJson != null) {
      _offlineQueue = List<Map<String, dynamic>>.from(
        jsonDecode(queueJson).map((x) => Map<String, dynamic>.from(x)),
      );
    }
  }

  Future<void> _saveOfflineQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_offlineQueueKey, jsonEncode(_offlineQueue));
  }

  Future<void> _addToOfflineQueue(Map<String, dynamic> locationData) async {
    _offlineQueue.add(locationData);
    if (_offlineQueue.length > 100) _offlineQueue.removeAt(0);
    await _saveOfflineQueue();
  }

  Future<void> _syncOfflineLocations(String authToken) async {
    if (_offlineQueue.isEmpty) return;
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/crm/location/sync'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
        },
        body: jsonEncode({'locations': _offlineQueue}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        _offlineQueue.clear();
        await _saveOfflineQueue();
      }
    } catch (e) {
      debugPrint('Offline sync failed: $e');
    }
  }

  Future<Map<String, dynamic>> syncOffline({required String authToken}) async {
    await _loadOfflineQueue();
    if (_offlineQueue.isEmpty) return {'success': true, 'message': 'No offline locations to sync'};
    await _syncOfflineLocations(authToken);
    return {
      'success': _offlineQueue.isEmpty,
      'message': _offlineQueue.isEmpty ? 'All locations synced' : '${_offlineQueue.length} locations still pending',
    };
  }

  int get offlineQueueSize => _offlineQueue.length;
}