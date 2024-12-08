import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_movie_night_app/screens/movie_selection_screen.dart';
import 'package:flutter_movie_night_app/utils/app_state.dart';
import 'package:flutter_movie_night_app/utils/http_helper.dart';
import 'package:provider/provider.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final MyData _data = MyData();
  String success = 'false';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enter Code',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formStateKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter Code:',
                  // style: Theme.of(context)
                  //     .textTheme
                  //     .titleLarge
                  //     ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: '1234',
                    labelText: 'Code',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  onSaved: (value) {
                    _data.code = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter session code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                    onPressed: () async {
                      if (_formStateKey.currentState!.validate()) {
                        _formStateKey.currentState!.save();

                        await _joinSession();

                        if (success == 'true') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieSelectionScreen(),
                              ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to join session")),
                          );
                        }
                      }
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.start),
                        SizedBox(width: 8.0),
                        Text('Join Session'),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _joinSession() async {
    String? deviceId = Provider.of<AppState>(context, listen: false).deviceId;
    String? code = _data.code;

    if (kDebugMode) {
      print('Device id from Enter Code Screen: $deviceId');
    }

    try {
      final response = await HttpHelper.joinSession(deviceId, code);

      if (kDebugMode) {
        print(response['data']['session_id']);
      }
      if (kDebugMode) {
        print("Session ID:");
        print(response['data']['session_id']);
      }
      setState(() {
        success = 'true';
      });
      Provider.of<AppState>(context, listen: false)
          .setSessionId(response['data']['session_id']);
    } catch (error) {
      print(error);
    }
  }
}

class MyData {
  String code = '';
}
