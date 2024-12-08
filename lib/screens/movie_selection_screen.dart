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
                        child: Image.network(
                          '$imageBaseUrl${movies[0].posterPath}',
                          width: 350,
                          height: 450,
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
                          child: Text(movies[0].voteAverage.toStringAsFixed(1),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ),
                        title: Text(
                          movies[0].title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        subtitle: Text('Released: ${movies[0].releaseDate}'),
                      ),
                    ],
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
}
