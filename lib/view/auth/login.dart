import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:drop_down_list/drop_down_list.dart';
import './validate.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _areaCodeControlller = TextEditingController(text: '+86');
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
              validator: (value) => _validate.validateAreaCode(value)),
          TextFormField(
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
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {}
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formLoginPassword() {
    return Row(children: [
      Expanded(
        child: TextFormField(
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
        ),
      ),
      ElevatedButton(
        onPressed: () => {
          setState(() {
            _passwordLogin = false;
          })
        },
        child: const Text('验证码登录'),
      ),
    ]);
  }

  Widget _formLoginVerifycode() {
    return Row(children: [
      Expanded(
        child: TextFormField(
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
          validator: (value) => _validate.validatePassword(value),
        ),
      ),
      ElevatedButton(
        style: const ButtonStyle(),
        onPressed: () => {
          setState(() {
            _passwordLogin = true;
          })
        },
        child: const Text('密码登录'),
      ),
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
    super.dispose();
  }
}
