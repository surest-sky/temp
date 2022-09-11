import 'package:flutter/material.dart';
import 'package:kwh/models/ListItem.dart';

import '../components/home_list_item.dart';
import '../services/ListService.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final service = ListService();
  final TextEditingController _searchController =
      TextEditingController(text: "");
  List<ListItem> _searchList = [];

  _search(String keyword) async {
    final List<ListItem> tempList = await service.searchListItem(keyword);

    setState(() {
      _searchList = tempList;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              controller: _searchController,
              onChanged: _search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _search("");
                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: _searchList.isNotEmpty
          ? ListView.builder(
              itemCount: _searchList.length,
              itemBuilder: (context, index) {
                return HomeListItem(item: _searchList[index],);
              },
            )
          : Empty(),
    );
  }

  Widget itemChild(String title) {
    return Container(
      child: Text(title),
    );
  }

  Widget Empty() {
    return Image.asset(
      "assets/images/search_empty.png",
      width: MediaQuery.of(context).size.width - 50,
      alignment: Alignment.center,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}
