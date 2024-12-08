import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_night_app/screens/movie_selection_screen.dart';
import 'package:flutter_movie_night_app/utils/app_state.dart';
import 'package:flutter_movie_night_app/utils/http_helper.dart';
import 'package:provider/provider.dart';

class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({super.key});

  @override
  State<ShareCodeScreen> createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  bool isLoading = true;
  String? code;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Share Code',
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (code == null)
                    const CircularProgressIndicator()
                  else
                    Text(
                      '$code',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  Text("Share the code with your friend",
                      style: Theme.of(context).textTheme.titleMedium),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MovieSelectionScreen(),
                          ));
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.start),
                        SizedBox(width: 8.0),
                        Text('Begin'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
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
      isLoading = false;
      code = response['data']['code'];
    });
    if (kDebugMode) {
      print("Session ID:");
      print(response['data']['session_id']);
    }
    if (!mounted) return;
    Provider.of<AppState>(context, listen: false)
        .setSessionId(response['data']['session_id']);
  }
}
