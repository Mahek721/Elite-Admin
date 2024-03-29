import 'dart:convert';
import 'package:elite_admin_panel/Screen/home_screen.dart';
import 'package:elite_admin_panel/admin_shared_prefernces/loggedadmin.dart';
import 'package:elite_admin_panel/admin_shared_prefernces/save_admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../API/api.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_form_field.dart';

class Login_page_admin extends StatefulWidget {
  const Login_page_admin({super.key});

  @override
  State<Login_page_admin> createState() => Login_page_admin_state();
}

class Login_page_admin_state extends State<Login_page_admin>{

  final loginpagekey = GlobalKey<FormState>();
  final admin_email = TextEditingController();
  final admin_pass=TextEditingController();
  bool isshowpass = true;
  bool a = true;
  bool b = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: loginpagekey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text_Form_Field(
                    hintText: 'Email',
                    controller: admin_email,
                    textInputAction: TextInputAction.next,
                    picon: Icon(
                      Icons.email_outlined,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email Is Required';
                      } else if(a){
                        return 'Email Is Not Register';
                      }else if (!isValidEmail(value)){
                        return 'Wrong Email';
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text_Form_Field(
                    hintText: 'Password',
                    controller: admin_pass,
                    picon: Icon(
                      Icons.lock,
                    ),
                    sicon: toggelepassword(),
                    obscureText: isshowpass,
                    maxlength: 12,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is Required';
                      } else if(b){
                        return 'Password is Wrong';
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Elevated_Button(
                  otap: () async {
                    setState(() {
                      a=false;
                      b=false;
                    });
                    if (loginpagekey.currentState!.validate()) {
                      var res = await http.post(
                        Uri.parse(API.signUpAdmin),
                        body: {"admin_email":admin_email.text}
                      );
                      print(jsonDecode(res.body));
                      var response = jsonDecode(res.body);

                      List<dynamic> validUser = response;
                      if(validUser.length==0){
                        setState(() {
                          a=true;
                        });
                      }
                      if(validUser.length!=0) {
                        if(admin_pass.text != validUser[0]["admin_pass"]){
                          setState(() {
                            b=true;
                          });
                        }
                      }
                    }
                    if (loginpagekey.currentState!.validate()) {
                      SaveAdmin().CreateAdmin(admin_email.text);
                      LoggedAdmin.email = admin_email.text;
                      Get.off(Home_page_admin());
                    }
                  },
                  text: 'Login',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget toggelepassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          isshowpass = !isshowpass;
        });
      },
      icon: isshowpass ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
    );
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );

    return emailRegex.hasMatch(email);
  }
}