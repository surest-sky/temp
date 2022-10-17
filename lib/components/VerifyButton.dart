import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:kwh/themes/colors.dart';

class VerifyButton extends StatefulWidget {
  final Function send;

  const VerifyButton({Key? key, required this.send}) : super(key: key);

  @override
  State<VerifyButton> createState() => _VerifyButtonState();
}

class _VerifyButtonState extends State<VerifyButton> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  late Timer _timer;
  int _countdownTime = 0;
  bool disabled = false;
  String verifyCodeText = "验证码登录";
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      controller: _btnController,
      child: Text(verifyCodeText),
      height: 40,
      color: disabled ? Colors.grey.shade400 : Colors.blue,
      onPressed: disabled
          ? null
          : () async {
              final isSuccess = await widget.send();
              if (isSuccess) {
                _btnController.start();
                if (_countdownTime == 0) {
                  setState(() {
                    _countdownTime = 5;
                    disabled = true;
                  });
                  startCountdownTimer();
                }
              }
            },
    );
  }

  void startCountdownTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownTime == 0) {
          _timer.cancel();
          verifyCodeText = "获取验证码";
          disabled = false;
        } else {
          _countdownTime = _countdownTime - 1;
          verifyCodeText = "请 $_countdownTime s后重试";
          _btnController.stop();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
}
