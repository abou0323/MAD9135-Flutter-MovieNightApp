import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_night_app/utils/http_helper.dart';
import 'package:http/http.dart' as http;

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({super.key});

  @override
  State<MovieSelectionScreen> createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  List movies = [];
  bool isLoading = true;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : (Dismissible(
              key: Key(movies[0].id.toString()),
              onDismissed: (direction) {
                setState(() {
                  movies.removeAt(0);
                  if (movies.length == 1) {
                    page++;
                    _fetchMovies();
                  }
                });
              },
              child: Stack(
                children: [
                  Image.network('$imageBaseUrl${movies[0].posterPath}'),
                  Text('${movies[0].title}'),
                ],
              ),
            )),
    );
  }

  Future<void> _fetchMovies() async {
    try {
      final response = await HttpHelper.fetchMovies(page);

      if (kDebugMode) {
        print(response);
      }
      setState(() {
        movies.addAll(response);
        isLoading = false;
      });
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      isLoading = false;
    }
  }
}
