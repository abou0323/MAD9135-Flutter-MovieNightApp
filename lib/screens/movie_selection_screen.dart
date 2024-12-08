import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_night_app/screens/welcome_screen.dart';
import 'package:flutter_movie_night_app/utils/app_state.dart';
import 'package:flutter_movie_night_app/utils/http_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
  int currentIndex = 0;

  String? matchingMovieId;
  bool match = false;

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
              key: Key(movies[currentIndex].id.toString()),
              onDismissed: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  // dislike; vote = false
                  var movieId = movies[currentIndex].id.toString();
                  var vote = 'false';
                  await _voteForMovie(movieId, vote);
                } else if (direction == DismissDirection.startToEnd) {
                  // like; vote = true
                  var movieId = movies[currentIndex].id.toString();
                  var vote = 'true';
                  await _voteForMovie(movieId, vote);

                  if (match == true) {
                    if (kDebugMode) {
                      print("show dialog");
                    }
                    _showDialog();
                  }
                }
                setState(() {
                  movies[currentIndex++];
                  if (currentIndex == movies.length - 1) {
                    page++;
                    _fetchMovies();
                  }
                });
              },
              background: Container(
                child: Center(
                    child: const Icon(
                  Icons.thumb_up,
                  size: 75,
                )),
              ),
              secondaryBackground: Container(
                child: const Icon(
                  Icons.thumb_down,
                  size: 75,
                ),
              ),
              child: Center(
                child: Container(
                  width: 400,
                  child: Card(
                    margin: EdgeInsets.all(32),
                    color: Theme.of(context).colorScheme.onPrimary,
                    elevation: 5.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          child: movies[currentIndex].posterPath == null
                              ? Image.asset(
                                  'assets/images/film-reel.png',
                                  width: 400,
                                  height: 400,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  '$imageBaseUrl${movies[currentIndex].posterPath}',
                                  width: 400,
                                  height: 400,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                                movies[currentIndex]
                                    .voteAverage
                                    .toStringAsFixed(1),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                          ),
                          title: Text(
                            movies[currentIndex].title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          subtitle: Text(
                              'Released: ${movies[currentIndex].releaseDate}'),
                        ),
                      ],
                    ),
                  ),
                ),
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

  Future<void> _voteForMovie(movieId, vote) async {
    String? sessionId = Provider.of<AppState>(context, listen: false).sessionId;

    final response = await HttpHelper.voteForMovie(sessionId, movieId, vote);

    if (kDebugMode) {
      print(response);
    }

    final response_match = response['data']['match'];

    if (response_match == true) {
      setState(() {
        matchingMovieId = response['data']['movie_id'];
        match = true;
      });
    }
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Align(
            alignment: Alignment.center,
            child: Text(
              'Winner!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                movies[currentIndex - 1].posterPath == null
                    ? Image.asset(
                        'assets/images/film-reel.png',
                        width: 400,
                        height: 400,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        '$imageBaseUrl${movies[currentIndex - 1].posterPath}',
                        width: 400,
                        height: 400,
                        fit: BoxFit.cover,
                      ),
                SizedBox(height: 16.0),
                Text("${movies[currentIndex - 1].title} was a match",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomeScreen(),
                    ));
              },
            ),
          ],
        );
      },
    );
  }
}
