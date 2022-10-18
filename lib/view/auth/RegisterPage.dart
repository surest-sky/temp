import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/styles/app_colors.dart';
import 'package:kwh/view/auth/LoginPage.dart';
import 'package:kwh/widgets/custom_button.dart';
import 'package:kwh/widgets/custom_formfield.dart';
import 'package:kwh/widgets/custom_header.dart';
import 'package:kwh/widgets/custom_richtext.dart';

import '../../components/VerifyButton.dart';
import '../../http/apis.dart';
import '../../models/LoginUser.dart';
import '../../rules/validate.dart';
import '../../services/AuthService.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _verifyCodeController = TextEditingController();
  final _nameController = TextEditingController();

  String get phone => _phoneController.text.trim();

  String get email => _emailController.text.trim();

  String get password => _passwordController.text.trim();

  String get confirmPassword => _confirmPasswordController.text.trim();

  String get verifyCode => _verifyCodeController.text.trim();

  String get name => _nameController.text.trim();

  final _validate = Validate();
  bool _hiddenPassword = true;
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
            text: '注册',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewLoginPage(),
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
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   height: 40,
                    //   width: MediaQuery.of(context).size.width * 0.8,
                    //   child: const Text('👏🏻注册', style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 30
                    //   ), textAlign: TextAlign.center,),
                    // ),
                    // const SizedBox(
                    //   height: 16,
                    // ),
                    CustomFormField(
                      headingText: "用户名称",
                      hintText: "请输入用户名称",
                      obsecureText: false,
                      suffixIcon: const SizedBox(),
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      controller: _nameController,
                      validator: (value) => _validate.validateName(value),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      headingText: "手机号码",
                      hintText: "请输入手机号码",
                      obsecureText: false,
                      suffixIcon: const SizedBox(),
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.phone,
                      controller: _phoneController,
                      validator: (value) => _validate.validatePhone(value),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      controller: _passwordController,
                      headingText: "密码",
                      hintText: "6 ~ 12 个字符串",
                      obsecureText: _hiddenPassword,
                      suffixIcon: passwordVisible(),
                      validator: (value) => _validate.validatePassword(value),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      controller: _confirmPasswordController,
                      headingText: "确认密码",
                      hintText: "6 ~ 12 个字符串(保持密码一致)",
                      obsecureText: _hiddenPassword,
                      suffixIcon: passwordVisible(),
                      validator: (value) => _validate.validateConfirmPassword(
                          value, confirmPassword),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _formLoginVerifycode(),
                    const SizedBox(
                      height: 16,
                    ),
                    AuthButton(
                      onTap: _registerAction,
                      text: '注册',
                    ),
                    CustomRichText(
                      discription: '已经有帐户了吗？',
                      text: '点这里登录',
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewLoginPage(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
          suffixIcon: IconButton(
            icon: const Icon(Icons.developer_mode),
            onPressed: () {},
          ),
          controller: _verifyCodeController,
          validator: (value) => _validate.validateCode(value),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 30, right: 24),
        width: 100,
        child: VerifyButton(
          send: verifySend,
          text: "获取验证码",
        ),
      )
    ]);
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

  _registerAction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final message =
        _validate.validateConfirmPassword(password, confirmPassword);
    if (message != null) {
      EasyLoading.showToast(message);
      return;
    }

    final queryParams = {
      'name': name,
      'phone': phone,
      'email': "",
      'pw': password,
      'sms_code': verifyCode,
    };
    EasyLoading.show(status: '请稍后...');

    final response = await Apis.registerApi(queryParams).whenComplete(() {
      EasyLoading.dismiss();
    });
    if (response.code != 200) {
      EasyLoading.showError(response.message);
      return;
    }
    EasyLoading.showToast('注册成功...');
    final loginResult = LoginUser.fromJson(response.data);
    await AuthService.saveUser(loginResult);
    Navigator.pushReplacementNamed(context, "appPage");
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verifyCodeController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
