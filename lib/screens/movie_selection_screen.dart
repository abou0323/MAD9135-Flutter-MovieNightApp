import 'package:flutter/material.dart';

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({super.key});

  @override
  State<MovieSelectionScreen> createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Movie Selection Screen"),
    );
  }
}
