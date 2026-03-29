import 'package:flutter/material.dart';
import '../../services/location_service.dart';
import '../../services/push_notification_service.dart';

class CrmDashboardScreen extends StatefulWidget {
  final String authToken;
  
  const CrmDashboardScreen({super.key, required this.authToken});

  @override
  State<CrmDashboardScreen> createState() => _CrmDashboardScreenState();
}

class _CrmDashboardScreenState extends State<CrmDashboardScreen> {
  final LocationService _locationService = LocationService();
  final PushNotificationService _pushService = PushNotificationService();
  
  bool _isLoading = true;
  bool _isCheckingIn = false;
  Map<String, dynamic>? _status;
  Map<String, dynamic>? _todayStats;

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupPushNotifications();
  }

  Future<void> _setupPushNotifications() async {
    await _pushService.registerToken(authToken: widget.authToken);
    _pushService.onNotificationTap = (data) {
      _handleNotificationAction(data);
    };
  }

  void _handleNotificationAction(Map<String, dynamic> data) {
    final action = data['action'];
    if (action == 'open_checkin') {
      _performCheckIn();
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final statusResult = await _locationService.getStatus(authToken: widget.authToken);
    final statsResult = await _locationService.getTodayStats(authToken: widget.authToken);

    if (mounted) {
      setState(() {
        if (statusResult['success'] == true) {
          _status = statusResult['data'];
        }
        if (statsResult['success'] == true) {
          _todayStats = statsResult['data'];
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _performCheckIn() async {
    setState(() => _isCheckingIn = true);

    final result = await _locationService.checkIn(
      authToken: widget.authToken,
      checkType: 'manual',
    );

    if (mounted) {
      setState(() => _isCheckingIn = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Check-in complete'),
          backgroundColor: result['success'] == true ? Colors.green : Colors.red,
        ),
      );

      _loadData();
    }
  }

  Future<void> _startTracking() async {
    try {
      await _locationService.startTracking(
        authToken: widget.authToken,
        interval: const Duration(minutes: 10),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location tracking started'), backgroundColor: Colors.green),
      );
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start tracking: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _stopTracking() {
    _locationService.stopTracking();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location tracking stopped'), backgroundColor: Colors.orange),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isInZone = _status?['last_checkin']?['is_in_zone'] == true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CRM Dashboard'),
        backgroundColor: const Color(0xFF001F3F),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Status Card
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              isInZone ? Icons.check_circle : Icons.warning,
                              color: isInZone ? Colors.green : Colors.orange,
                              size: 40,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isInZone ? 'In Your Zone' : 'Outside Zone',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  if (_status?['last_checkin'] != null)
                                    Text(
                                      'Last: ${_status!['last_checkin']['time_ago']}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Check-in Button
                    ElevatedButton.icon(
                      onPressed: _isCheckingIn ? null : _performCheckIn,
                      icon: _isCheckingIn
                          ? const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.location_on),
                      label: Text(_isCheckingIn ? 'Checking In...' : 'Check In Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC9A24E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Today's Stats
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Today's Activity", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _statItem('Check-ins', '${_todayStats?['total_checkins'] ?? 0}', Icons.pin_drop, Colors.blue),
                                _statItem('In Zone', '${_todayStats?['in_zone_count'] ?? 0}', Icons.check_circle, Colors.green),
                                _statItem('Zone %', '${(_todayStats?['in_zone_percentage'] ?? 0).toStringAsFixed(0)}%', Icons.pie_chart, Colors.purple),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tracking Controls
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _locationService.isTracking ? Icons.gps_fixed : Icons.gps_off,
                                  color: _locationService.isTracking ? Colors.green : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _locationService.isTracking ? 'Auto-tracking Active' : 'Auto-tracking Off',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _locationService.isTracking ? _stopTracking : _startTracking,
                                icon: Icon(_locationService.isTracking ? Icons.stop : Icons.play_arrow),
                                label: Text(_locationService.isTracking ? 'Stop Tracking' : 'Start Tracking'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _locationService.isTracking ? Colors.red : Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _statItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}