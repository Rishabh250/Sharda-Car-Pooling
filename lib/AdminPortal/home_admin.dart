import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  var finalName;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.getString("email");
    final SharedPreferences sharedPreferences03 =
        await SharedPreferences.getInstance();
    sharedPreferences03.getString("table");

    String url = "https://guam-monoliths.000webhostapp.com/fetch_data.php";
    var data = {
      "email": sharedPreferences.getString("email"),
      "table": sharedPreferences03.getString("table")
    };

    print(sharedPreferences.getString("email"));
    print(sharedPreferences03.getString("table"));

    var res = await http.post(Uri.parse(url), body: data);
    var responseBody = jsonDecode(res.body);
    print(responseBody);
    finalName = responseBody;
    return responseBody;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error in Fetching Data"),
          );
        }
        return Center(
          child: Text("$finalName"),
        );
      },
    )));
  }
}
