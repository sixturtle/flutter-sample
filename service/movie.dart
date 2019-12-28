import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Movie {
  final int year;
  final String title;
  String actor;

  Movie({this.year, this.title, this.actor});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        actor: json["actor"], title: json["title"], year: json["year"]);
  }

  Map<String, dynamic> toJson() =>
      {'year': this.year, 'title': this.title, 'actor': this.actor};

  String toString() {
    return json.encode(this);
  }
}

class MovieService {
  final baseUrl = 'http://localhost:3000/movies';

  Future<List<Movie>> list() async {
    final response = await http.get(this.baseUrl + '/movies');

    if (response.statusCode == 200) {
      var list = json.decode(response.body) as List;
      return list.map((json) => Movie.fromJson(json)).toList();
    } else {
      print('Failed to load, status: ${response.statusCode}');
    }
  }

  Future<bool> create(Movie movie) async {
    var status = false;
    var m = json.encode(movie);
    final response = await http.post('http://localhost:3000/movies', body: m);

    if (response.statusCode == 201) {
      status = true;
      print("successfully created");
    } else {
      print('Failed to create, status: ${response.statusCode}');
    }

    return status;
  }

  Future<bool> update(Movie movie) async {
    var status = false;
    var m = json.encode(movie);
    final response = await http.put('http://localhost:3000/movies', body: m);

    if (response.statusCode == 204) {
      status = true;
      print("successfully updated");
    } else {
      print('Failed to update, status: ${response.statusCode}');
    }

    return status;
  }

  Future<bool> delete(var year, var title) async {
    var status = false;

    final response = await http
        .delete('http://localhost:3000/movies?year=${year}&title=${title}');

    if (response.statusCode == 204) {
      status = true;
      print("successfully deleted");
    } else {
      print('Failed to delete, status: ${response.statusCode}');
    }

    return status;
  }

  Future<Movie> find(var year, var title) async {
    Movie m;
    final response =
        await http.get('http://localhost:3000/movies?year=$year&title=$title');

    if (response.statusCode == 200) {
      m = Movie.fromJson(json.decode(response.body));
    } else {
      print('Failed to find, status: ${response.statusCode}');
    }

    return m;
  }
}

void main() async {
  var service = MovieService();
  List<Movie> movies = await service.list();
  print(movies);

  var m = movies[0];
  m.actor = "Changed Actor";
  await service.update(m);
  m = await service.find(m.year, m.title);
  print("Updated: $m");

  await service.delete(m.year, m.title);
  await service.find(m.year, m.title);

  await service.create(m);
  m = await service.find(m.year, m.title);
  print("Created: $m");
}
