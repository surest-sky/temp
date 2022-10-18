import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/styles/app_colors.dart';
import '../../components/VerifyButton.dart';
import '../../http/apis.dart';
import '../../models/LoginUser.dart';
import '../../rules/validate.dart';
import '../../services/AuthService.dart';
import 'ForgetPasswordPage.dart';
import 'RegisterPage.dart';
import 'package:kwh/widgets/custom_button.dart';
import 'package:kwh/widgets/custom_formfield.dart';
import 'package:kwh/widgets/custom_header.dart';
import 'package:kwh/widgets/custom_richtext.dart';

class NewLoginPage extends StatefulWidget {
  const NewLoginPage({Key? key}) : super(key: key);

  @override
  State<NewLoginPage> createState() => _NewLoginPageState();
}

class _NewLoginPageState extends State<NewLoginPage> {
  final _phoneController = TextEditingController(text: "18270952773");
  final _passwordController = TextEditingController(text: "123456");
  final _verifyCodeController = TextEditingController(text: "123456");

  String get phone => _phoneController.text.trim();

  String get password => _passwordController.text.trim();

  bool _passwordLogin = true;
  bool _hiddenPassword = true;
  final _validate = Validate();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.appPrimaryColor,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          CustomHeader(
            text: '登录',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterPage(),
                ),
              );
            },
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: AppColors.whiteshade,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.09),
                      child: Image.asset("assets/images/login.png"),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomFormField(
                      headingText: "手机号码",
                      hintText: "请输入手机号码",
                      obsecureText: false,
                      suffixIcon: const SizedBox(),
                      controller: _phoneController,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.phone,
                      validator: (value) => _validate.validatePhone(value),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _passwordLogin
                        ? _formLoginPassword()
                        : _formLoginVerifycode(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 4,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgetPassword(),
                                ),
                              );
                            },
                            child: Text(
                              "忘记密码 ?",
                              style: TextStyle(
                                color: AppColors.blue.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 4,
                            right: 24,
                            top: 16,
                            bottom: 16,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _passwordLogin = !_passwordLogin;
                                _passwordController.text = "";
                                _verifyCodeController.text = "";
                              });
                            },
                            child: Text(
                              _passwordLogin ? "验证码登录" : '密码登录',
                              style: TextStyle(
                                color: AppColors.blue.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AuthButton(
                      onTap: submitAction,
                      text: '登录',
                    ),
                    CustomRichText(
                      discription: "还没有账户？",
                      text: "注册",
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formLoginPassword() {
    return CustomFormField(
      headingText: "密码",
      maxLines: 1,
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.text,
      hintText: "6 ~ 12 个字符串",
      obsecureText: _hiddenPassword,
      suffixIcon: passwordVisible(),
      controller: _passwordController,
      validator: (value) => _validate.validatePassword(value),
    );
  }

  Widget _formLoginVerifycode() {
    return Row(children: [
      Expanded(
        child: CustomFormField(
          headingText: "请输入验证码",
          maxLines: 1,
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.text,
          hintText: "验证码",
          obsecureText: false,
          suffixIcon: passwordVisible(),
          controller: _verifyCodeController,
          validator: (value) => _validate.validateCode(value),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 30, right: 24),
        width: 100,
        child: VerifyButton(send: verifySend, text: "获取验证码",),
      )
    ]);
  }

  Future submitAction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final phone = _phoneController.text;
    final password = _passwordController.text;
    final code = _verifyCodeController.text;
    final queryParams = {
      'phone': phone,
      'email': "",
      'pw': password,
      'sms_code': code,
    };
    EasyLoading.show(status: '登录中...');
    final response = await Apis.loginApi(queryParams).whenComplete(() {
      EasyLoading.dismiss();
    });
    if (response.code != 200) {
      EasyLoading.showError(response.message);
      return;
    }
    final loginResult = LoginUser.fromJson(response.data);
    await AuthService.saveUser(loginResult);
    Navigator.pushReplacementNamed(context, "appPage");
  }

  Future<bool> verifySend() async {
    final phone = _phoneController.text;
    final response = await Apis.sendVerifyCode(phone);
    if (response.code != 200) {
      EasyLoading.showToast("服务异常,请稍后重试");
      return false;
    }

    return true;
  }

  Widget passwordVisible() {
    return IconButton(
      icon: Icon(_hiddenPassword ? Icons.visibility : Icons.visibility_off),
      onPressed: () {
        setState(() => _hiddenPassword = !_hiddenPassword);
      },
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _verifyCodeController.dispose();
    super.dispose();
  }
}
