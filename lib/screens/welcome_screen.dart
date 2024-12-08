import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_night_app/screens/enter_code_screen.dart';
import 'package:flutter_movie_night_app/screens/share_code_screen.dart';
import 'package:flutter_movie_night_app/utils/app_state.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Night'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShareCodeScreen(),
                    ));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.start),
                  SizedBox(width: 8.0),
                  Text('Start Session'),
                ],
              ),
            ),
            Text("Choose an option to begin",
                style: Theme.of(context).textTheme.titleMedium),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EnterCodeScreen(),
                    ));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.code),
                  SizedBox(width: 8.0),
                  Text('Join Session'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initializeDeviceId() async {
    String deviceId = await _fetchDeviceId();
    if (!mounted) return;
    Provider.of<AppState>(context, listen: false).setDeviceId(deviceId);
  }

  Future<String> _fetchDeviceId() async {
    String deviceId = "";

    try {
      if (Platform.isAndroid) {
        const androidPlugin = AndroidId();
        deviceId = await androidPlugin.getId() ?? 'Unknown id';
      } else if (Platform.isIOS) {
        var deviceInfoPlugin = DeviceInfoPlugin();
        var iOSInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iOSInfo.identifierForVendor ?? 'Unknown id';
      } else {
        deviceId = 'Unsupported platform';
      }
    } catch (e) {
      deviceId = 'Error: $e';
    }

    if (kDebugMode) {
      print('Device id: $deviceId');
    }
    return deviceId;
  }
}
