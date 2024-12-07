import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_night_app/utils/app_state.dart';
import 'package:flutter_movie_night_app/utils/http_helper.dart';
import 'package:provider/provider.dart';

class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({super.key});

  @override
  State<ShareCodeScreen> createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  String code = "Unset";

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Share Code',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Code: $code')],
          ),
        ));
  }

  Future<void> _startSession() async {
    String? deviceId = Provider.of<AppState>(context, listen: false).deviceId;
    if (kDebugMode) {
      print('Device id from Share Code Screen: $deviceId');
    }
    //call api
    final response = await HttpHelper.startSession(deviceId);
    if (kDebugMode) {
      print(response['data']['code']);
    }
    setState(() {
      code = response['data']['code'];
    });
  }
}
