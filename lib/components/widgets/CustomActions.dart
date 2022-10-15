import 'package:flutter/material.dart';

import '../../mixins/ItemAction.dart';

class CustomActions with ItemAction {
  Widget QuickAdd(context) {
    return IconButton(
      onPressed: _add(context),
      icon: const Icon(Icons.add),
    );
  }

  _add(context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, //重
      builder: itemAdd,
    );
  }
}
