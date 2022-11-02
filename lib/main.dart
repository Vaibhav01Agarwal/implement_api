import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DataFromAPI(),
    );
  }
}

class DataFromAPI extends StatefulWidget {
  const DataFromAPI({Key? key}) : super(key: key);

  @override
  State<DataFromAPI> createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  Future getUserData() async {
    var response =
        await http.get(Uri.https('jsonplaceholder.typicode.com', 'users'));
    var jsonData = jsonDecode(response.body);
    List<User> users = [];

    for (var u in jsonData) {
      User user = User(u["name"], u["email"], u["userName"]);
      users.add(user);
    }
    // ignore: avoid_print
    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Data"),
        ),
        // I can also put future builder into the container , it will not affect anything but i am giving this because providing the color to the card. It will look good after
        // providing a color.
        body: Card(
          color: Colors.amber,
          child: FutureBuilder<dynamic>(
            future: getUserData(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: Text('Loading....'),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, int i) {
                      return ListTile(
                        title: Text(snapshot.data![i].name.toString()),
                        subtitle: Text(snapshot.data![i].userName.toString()),
                        trailing: Text(snapshot.data![i].email.toString()),
                      );
                    });
              }
            },
          ),
        ));
  }
}

class User {
  final String? name, email, userName;

  User(this.name, this.email, this.userName);
}
