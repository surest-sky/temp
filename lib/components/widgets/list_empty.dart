import 'package:flutter/material.dart';

class ListEmpty extends StatelessWidget {
  const ListEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 40)),
          Image.asset(
            "assets/images/empty.png",
            width: MediaQuery.of(context).size.width - 50,
            height: 200,
            alignment: Alignment.center,
          ),
          const Text(
            "好像没有找到数据哦",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
