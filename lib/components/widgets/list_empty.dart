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
          const Text(
            "暂无数据",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          Image.asset(
            "assets/images/search_empty.png",
            width: MediaQuery.of(context).size.width - 50,
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}
