import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final GestureTapCallback? onTap;
  final List<Widget> children;

  const ListItem({Key? key, required this.children, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        // boxShadow: const [
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 5.0,
        //   ),
        // ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            ),
          )
        ],
      ),
    );
  }

  Widget BorderTop({double width = 1}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: width,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}
