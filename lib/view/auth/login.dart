import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:tutor_page_h5/rules/validate.dart';
import 'package:tutor_page_h5/components/verify_button.dart';
import 'package:tutor_page_h5/http/request.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _areaCodeControlller = TextEditingController(text: '+86');
  final _phoneControlller = TextEditingController(text: '18270952773');
  final _passwordControlller = TextEditingController(text: '123456');
  final _codeControlller = TextEditingController(text: '');
  final _validate = Validate();
  bool _passwordLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          tooltip: 'Show Snackbar',
          onPressed: () {},
        ),
        title: const Text('登录'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Theme.of(context).colorScheme.shadow,
      ),
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(115, 212, 212, 212),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: const Text(
                "欢迎来到 TutorPage !!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _formWeight()
          ],
        ),
      ),
    );
  }

  Widget _formWeight() {
    final List<SelectedListItem> _areaCode = [
      SelectedListItem(
        name: "+86",
        value: "+86",
        isSelected: false,
      ),
      SelectedListItem(
        name: "+87",
        value: "+87",
        isSelected: false,
      ),
    ];

    void onTextFieldTap() {
      DropDownState(
        DropDown(
          bottomSheetTitle: const Text(
            '选择区号',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          submitButtonChild: const Text(
            '确定',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          data: _areaCode,
          selectedItems: (List<dynamic> selectedList) {
            List<String> list = [];
            for (var item in selectedList) {
              if (item is SelectedListItem) {
                list.add(item.name);
              }

              setState(() {
                _areaCodeControlller.text = "+87";
              });
            }
          },
        ),
      ).showModal(context);
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _areaCodeControlller,
            onTap: () {
              FocusScope.of(context).unfocus();
              onTextFieldTap();
            },
            decoration: const InputDecoration(
              labelText: '区号',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black12,
                ),
              ),
            ),
            // The validator receives the text that the user has entered.
            validator: (value) => _validate.validateAreaCode(value),
          ),
          TextFormField(
            controller: _phoneControlller,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: '手机号码',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black12,
                ),
              ),
            ),
            // The validator receives the text that the user has entered.
            validator: (value) => _validate.validatePhone(value),
          ),
          _passwordLogin ? _formLoginPassword() : _formLoginVerifycode(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text(_passwordLogin ? "验证码登录" : '密码登录'),
                onPressed: () {
                  setState(() {
                    _passwordLogin = !_passwordLogin;
                  });
                },
              )
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              onPressed: submitAction,
              child: const Text('登录'),
            ),
          ),
        ],
      ),
    );
  }

  Future submitAction() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final phone = _phoneControlller.text;
    final areacode = _areaCodeControlller.text;
    final password = _passwordControlller.text;
    final code = _codeControlller.text;
    final queryParams = {
      'phone': phone,
      'country_code': areacode,
      'password': password,
      'captcha': code,
      'mode': _passwordLogin ? "phone" : 'verifyCode',
    };
    if (_passwordLogin) {
      queryParams.remove("captcha");
    } else {
      queryParams.remove("password");
    }

    var responseMap = await loginApi(queryParams);
    if (responseMap.code == 200) {
      await prefs.setString("user", json.encode(responseMap.message));
      Navigator.pushNamed(context, "appPage");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseMap.message)),
      );
    }
  }

  Widget _formLoginPassword() {
    return TextFormField(
      controller: _passwordControlller,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: '密码',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black12,
          ),
        ),
      ),
      // The validator receives the text that the user has entered.
      validator: (value) => _validate.validatePassword(value),
    );
  }

  Widget _formLoginVerifycode() {
    return Row(children: [
      Expanded(
        child: TextFormField(
          controller: _codeControlller,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: '验证码',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12,
              ),
            ),
          ),
          // The validator receives the text that the user has entered.
          validator: (value) => _validate.validateCode(value),
        ),
      ),
      VerifyButton(onPressed: () => {}),
    ]);
  }

  void switchLoginMode() {
    setState(() {
      _passwordLogin = false;
    });
  }

  @override
  void dispose() {
    _areaCodeControlller.dispose();
    _phoneControlller.dispose();
    _codeControlller.dispose();
    _passwordControlller.dispose();
    super.dispose();
  }
}
