import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/config.dart';
import 'package:flutter_application_2/model/request/customer_post_register_req.dart';
import 'package:flutter_application_2/pages/login.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  String text = '';
  int n = 0;
  String phoneNo = '';
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (value) {
        url = value['apiEndpoint'];
        log(value['apiEndpoint']);
      },
    ).catchError((err) {
      log(err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงทะเบียนสมาชิกใหม่'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 50, 0),
                  child: Text(
                    'ชื่อ-นามสกุล ',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                controller: fullname,
                // obscureText: true,
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
                    'หมายเลขโทรศัพท์',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ],
            ),
            Padding(
              ////กำหนดระยะห่าง
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
                    'อีเมล์',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                controller: email,
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
                obscureText: true, //ไม่ให้เห็นpassword
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
                    'ยืนยันรหัสผ่าน',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                controller: confirmpassword,
                obscureText: true,
                decoration: const InputDecoration(
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 1))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 20),
                  child: FilledButton(
                      onPressed: apply, child: const Text('สมัครสมาชิก')),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: TextButton(
                      onPressed: register,
                      child: const Text('หากมีบัญชีอยู่แล้ว?')),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 20),
                  child: FilledButton(
                      onPressed: login, child: const Text('เข้าสู่ระบบ')),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void login() {
    log(phoneCtl.text);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  }

  void apply() {
    //เช็คว่าเราพิมพ์มั้ย ถ้าไม่พิมพ์จะไม่บันทึกใช้
    if (phoneCtl.text.isNotEmpty &&
        password.text.isNotEmpty &&
        fullname.text.isNotEmpty &&
        email.text.isNotEmpty &&
        confirmpassword.text.isNotEmpty) {
      if (password.text == confirmpassword.text) {
        var data = CustomerResgisterPostRequest(
            fullname: fullname.text,
            phone: phoneCtl.text,
            email: email.text,
            image:
                "http://202.28.34.197:8888/contents/4a00cead-afb3-45db-a37a-c8bebe08fe0d.png",
            password: password.text);
        log(url);
        log(phoneCtl.text);
        log(fullname.text);
        http
            .post(Uri.parse('$url/customers'),
                headers: {"Content-Type": "application/json; charset=utf-8"},
                body: jsonEncode(data))
            .then(
          (value) {
            log("Login successful !!");
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ));
          },
        ).catchError((err) {
          log(err.toString());
          setState(() {
            text = "password is not connected";
          });
        });
      }
    }
  }

  void register() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  }
}
