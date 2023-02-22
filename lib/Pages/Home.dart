import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/ApiConsult.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _MyHome createState() => _MyHome();
}

class _MyHome extends State<Home> {
  int _paginaActual = 0;

  Future<List<ApiConsult>>? _listApi;

  Future<List<ApiConsult>> _getApi() async {
    final response = await http.get(Uri(
        scheme: 'https', host: 'rickandmortyapi.com', path: '/api/character'));

    List<ApiConsult> data = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData["results"]) {
        data.add(ApiConsult(item["name"], item["image"]));
      }
      return data;
    } else {
      throw Exception("no sirvio bro");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listApi = _getApi();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: _listApi,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 2,
                children: _listusers(snapshot.data),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text("Error");
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _listusers(data) {
    List<Widget> users = [];

    for (var user in data) {
      users.add(Card(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: SizedBox(
            width: 300,
            height: 100,
            child: Column(
              children: [
                Expanded(
                    child: Image.network(
                  user.url,
                  fit: BoxFit.fill,
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(user.name),
                ),
              ],
            ),
          )));
    }

    return users;
  }
}
