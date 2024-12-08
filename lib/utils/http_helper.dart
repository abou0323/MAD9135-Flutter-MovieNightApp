import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  static String movieNightBaseUrl = 'https://movie-night-api.onrender.com';
  static String tmdbBaseUrl = 'https://api.themoviedb.org/3/movie/popular';

  static startSession(String? deviceId) async {
    var response = await http
        .get(Uri.parse('$movieNightBaseUrl/start-session?device_id=$deviceId'));
    return jsonDecode(response.body);
  }

  static joinSession(String? deviceId, code) async {
    var response = await http.get(Uri.parse(
        '$movieNightBaseUrl/join-session?device_id=$deviceId&code=$code'));
    if (response.statusCode == HttpStatus.ok) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to Join Session');
    }
  }

  static Future<List<Movie>> fetchMovies(page) async {
    await dotenv.load(fileName: '.env');
    final apiKey = dotenv.env['TMDB_API_KEY'];

    final response =
        await http.get(Uri.parse('$tmdbBaseUrl?api_key=$apiKey&page=$page'));
    if (response.statusCode == HttpStatus.ok) {
      List jsonResponse = json.decode(response.body)['results'];
      return jsonResponse.map((data) => Movie.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static voteForMovie(String? sessionId, movieId, vote) async {
    var response = await http.get(Uri.parse(
        '$movieNightBaseUrl/vote-movie?session_id=$sessionId&movie_id=$movieId&vote=$vote'));
    if (response.statusCode == HttpStatus.ok) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to cast vote');
    }
  }
}

class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> data) {
    return Movie(
      id: data['id'],
      title: data['original_title'],
      posterPath: data['poster_path'],
      releaseDate: data['release_date'],
      voteAverage: data['vote_average'],
    );
  }
}
