import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:shardapooling/Portals/admin.dart';
import 'Email/mail_otp.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

import 'Portals/parent.dart';
import 'Portals/student.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obsecureText = true;
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();
  var email, pass, id;
  bool _visible = false;
  var nextPage, pageName;
  var finalMail, finalPage;

  @override
  void initState() {
    getValidation().whenComplete(() async {
      if (finalPage == "ParentPage") {
        Get.offAll(finalMail == null ? const LoginPage() : const ParentPage());
      } else if (finalPage == "StudentPage") {
        Get.offAll(finalMail == null ? const LoginPage() : const StudentPage());
      } else if (finalPage == "AdminPage") {
        Get.offAll(finalMail == null ? const LoginPage() : const AdminPage());
      }
    });
    super.initState();
  }

  Future getValidation() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final SharedPreferences sharedPreferences02 =
        await SharedPreferences.getInstance();

    var obtainedMail = sharedPreferences.getString("email");
    var obtainedPage = sharedPreferences02.getString("page");
    setState(() {
      finalMail = obtainedMail;
      finalPage = obtainedPage;
    });
    print(finalMail);
    print(finalPage);
  }

  Future getData() async {
    String url2 = "https://guam-monoliths.000webhostapp.com/login.php";
    var data = {"email": mail.text, "password": password.text, "table": id};
    if (mail.text.isNotEmpty && password.text.isNotEmpty && id != "") {
      var res = await http.post(Uri.parse(url2), body: data);
      print(res.body);
      if (convert.jsonDecode(res.body) == "Login") {
        print("object");
        setState(() {
          _visible = false;
        });

        if (id == "Parent/Gurdian") {
          setState(() {
            nextPage = const ParentPage();
            pageName = "ParentPage";
          });
        }
        if (id == "Student" || id == "Faculty") {
          setState(() {
            nextPage = const StudentPage();
            pageName = "StudentPage";
          });
        }
        if (id == "Admin") {
          setState(() {
            nextPage = const AdminPage();
            pageName = "AdminPage";
          });
        }

        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        final SharedPreferences sharedPreferences02 =
            await SharedPreferences.getInstance();

        final SharedPreferences sharedPreferences03 =
            await SharedPreferences.getInstance();

        String newPage = pageName;
        sharedPreferences.setString("email", mail.text);
        sharedPreferences03.setString("table", id.toString());
        sharedPreferences02.setString("page", newPage);
        print(newPage);
        Get.offAll(nextPage);
      } else if (convert.jsonDecode(res.body) == "Invalid Email or Password") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            "\n Invalid Email or Password \n",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          backgroundColor: Colors.red,
        ));
        setState(() {
          _visible = false;
        });
      }
    } else if (mail.text.isEmpty || password.text.isEmpty || id == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "\n Fields can't be empty \n",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Colors.red,
      ));
      setState(() {
        _visible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color.fromRGBO(10, 34, 85, 1),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Image.asset(
                "images/shardaLogo.png",
                height: 100,
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    width: 400,
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0, 2.5),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            Shadow(
                              blurRadius: 8.0,
                              color: Color.fromARGB(125, 0, 0, 255),
                            ),
                          ],
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        child: const Text(
                          "Please sign in to continue...",
                          style: TextStyle(
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(0, 2.5),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                Shadow(
                                  blurRadius: 8.0,
                                  color: Color.fromARGB(125, 0, 0, 255),
                                ),
                              ],
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset:
                              const Offset(1, 7), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: DropdownSearch<String>(
                              maxHeight: 240,
                              mode: Mode.BOTTOM_SHEET,
                              items: const [
                                "Student",
                                "Faculty",
                                "Parent/Gurdian",
                                'Admin'
                              ],
                              label: "I am a ....",
                              onChanged: (value) {
                                setState(() {
                                  id = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Sharda Mail ID",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Card(
                                color: Colors.transparent,
                                shadowColor: Colors.transparent,
                                child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 1.5,
                                          blurRadius: 4,
                                          offset: const Offset(2,
                                              7), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(40),
                                          bottomRight: Radius.circular(40)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8,
                                          left: 0.0,
                                          right: 25.0,
                                          bottom: 8),
                                      child: TextFormField(
                                        onChanged: (value) {
                                          email = value;
                                        },
                                        controller: mail,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.email),
                                        ),
                                        validator: MultiValidator([
                                          EmailValidator(
                                              errorText:
                                                  "Invaild Sharda Mail ID")
                                        ]),
                                      ),
                                    ))),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Password",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Card(
                                color: Colors.transparent,
                                shadowColor: Colors.transparent,
                                child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 1.5,
                                          blurRadius: 4,
                                          offset: const Offset(2,
                                              7), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(40),
                                          bottomRight: Radius.circular(40)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8,
                                          left: 0.0,
                                          right: 25.0,
                                          bottom: 8),
                                      child: TextFormField(
                                        controller: password,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            prefixIcon: const Icon(Icons.lock),
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _obsecureText =
                                                      !_obsecureText;
                                                });
                                              },
                                              child: Icon(_obsecureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                            )),
                                        obscureText: _obsecureText,
                                      ),
                                    ))),
                          ),
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(1, 7),
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                            ),
                            child: FlatButton(
                              splashColor: Colors.blue.shade400,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              onPressed: () {
                                setState(() {
                                  _visible = true;
                                });
                                getData();
                              },
                              child: Row(
                                children: const [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.arrow_right_rounded,
                                    size: 40,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                (context),
                                MaterialPageRoute(
                                    builder: (context) => const MailSender()));
                          },
                          child: const Text(
                            "Forget Password",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _visible,
                child: Tab(
                  child: LoadingBouncingLine.circle(
                    size: 50,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  print("Help");
                },
                child: const Text(
                  "Need Help !",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
