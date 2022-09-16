import 'package:flutter/material.dart';

class ListEmpty extends StatelessWidget {
  const ListEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/search_empty.png",
      width: MediaQuery.of(context).size.width - 50,
      alignment: Alignment.center,
    );
  }
}
