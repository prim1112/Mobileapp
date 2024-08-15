import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/config.dart';
import 'package:flutter_application_2/model/request/customer_login_post_req.dart';
import 'package:flutter_application_2/model/response/customer_login_post_res.dart';
import 'package:flutter_application_2/pages/register.dart';
import 'package:flutter_application_2/pages/showtrip.dart';
import 'package:flutter_application_2/model/request/customer_login_post_req.dart';
import 'package:flutter_application_2/model/response/customer_login_post_res.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int num = 0;
  String phoneNo = '';
  var phoneCtl = TextEditingController();
  TextEditingController password = TextEditingController();
  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (value) {
        log(value['apiEndpoint']);
        url = value['apiEndpoint'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                  onDoubleTap: () {
                    log("onDoubleTap is fired");
                  },
                  child: Image.asset('assets/images/logo.png')),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 50, 0),
                    child: Text(
                      'หมายเลขมือถือ',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: phoneCtl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1))),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 50, 0),
                    child: Text(
                      'รหัสผ่าน',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1))),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: TextButton(
                        onPressed: register,
                        child: const Text('ลงทะเบียนใหม่')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 20),
                    child: FilledButton(
                        onPressed: login, child: const Text('เข้าสู่ระบบ')),
                  ),
                ],
              ),
              Text(text)
            ],
          ),
        ));
  }

//Async/Await
  void login() {
    var data = {"phone": "0817399999", "password": "1111"};
    CustomerLoginPostRequest req =
        CustomerLoginPostRequest(phone: phoneCtl.text, password: password.text);
    http
        .post(Uri.parse("$url/customers/login"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: customerLoginPostRequestToJson(req))
        .then(
      (value) {
        log(value.body);
        CustomerLoginPostResponse customer =
            customerLoginPostResponseFromJson(value.body);
        log(customer.customer.fullname);
        log(customer.customer.email);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => showtrip(
                idx: customer.customer.idx,
              ),
            ));
      },
    ).catchError((error) {
      log('Error $error');
    });
  }

  void register() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        ));
  }
}
