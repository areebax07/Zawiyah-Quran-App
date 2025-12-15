import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({Key? key}) : super(key: key);

  @override
  _QiblaScreenState createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  bool _hasPermissions = false;
  double? _qiblaDirection;

  @override
  void initState() {
    super.initState();
    _fetchPermissionStatus();
  }

  void _fetchPermissionStatus() async {
    final permission = await Permission.location.request();
    if (permission.isGranted) {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final qibla = _calculateQiblaDirection(position.latitude, position.longitude);

      setState(() {
        _hasPermissions = true;
        _qiblaDirection = qibla;
      });
    } else {
      // Handle the case where permission is denied
      setState(() {
        _hasPermissions = false;
      });
    }
  }

  double _calculateQiblaDirection(double lat, double lon) {
    // Kaaba coordinates
    const kaabaLat = 21.422487;
    const kaabaLon = 39.826206;

    final double latRad = _toRadians(lat);
    final double lonRad = _toRadians(lon);
    final double kaabaLatRad = _toRadians(kaabaLat);
    final double kaabaLonRad = _toRadians(kaabaLon);

    final double lonDiff = kaabaLonRad - lonRad;

    final double y = math.sin(lonDiff);
    final double x = math.cos(latRad) * math.tan(kaabaLatRad) - math.sin(latRad) * math.cos(lonDiff);

    final double bearing = math.atan2(y, x);
    return _toDegrees(bearing);
  }

  double _toRadians(double degrees) => degrees * (math.pi / 180.0);
  double _toDegrees(double radians) => radians * (180.0 / math.pi);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Direction'),
        backgroundColor: const Color(0xFF8B46D7),
        foregroundColor: Colors.white,
      ),
      body: _buildCompass(),
    );
  }

  Widget _buildCompass() {
    if (!_hasPermissions) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Location permission is required to determine the Qibla direction. Please grant the permission in your device settings.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error reading compass: ${snapshot.error}'));
        }

        if (!snapshot.hasData || _qiblaDirection == null) {
          return const Center(child: CircularProgressIndicator());
        }

        double? deviceHeading = snapshot.data!.heading;
        if (deviceHeading == null) {
          return const Center(child: Text('Compass not available.'));
        }

        // The angle to rotate the compass image
        final compassRotation = -_toRadians(deviceHeading);
        // The angle to rotate the Qibla pointer
        final qiblaRotation = _toRadians(_qiblaDirection!);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Align the top of your device with the arrow',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                // Compass background
                Transform.rotate(
                  angle: compassRotation,
                  child: Image.asset('assets/images/comp.png', width: 300, height: 300),
                ),
                // Qibla direction arrow
                Transform.rotate(
                  angle: qiblaRotation - _toRadians(deviceHeading), // Adjust for device rotation
                  child: Image.asset('assets/images/arrow.png', width: 280, height: 280),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
