import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Paginationbutton1(),
  ));
}

class Paginationbutton1 extends StatefulWidget {
  const Paginationbutton1({super.key});

  @override
  State<Paginationbutton1> createState() => _Paginationbutton1State();
}

class _Paginationbutton1State extends State<Paginationbutton1> {
  final int totalItems = 98; // Example total records (from MySQL count)
  final int itemsPerPage = 10;
  int currentPage = 1;
  List<String> currentItems = [];

  int get totalPages => (totalItems / itemsPerPage).ceil();

  @override
  void initState() {
    super.initState();
    _loadPage(currentPage);
  }

  void _loadPage(int page) {
    setState(() {
      currentPage = page;
      int start = (page - 1) * itemsPerPage;
      int end = min(start + itemsPerPage, totalItems);
      currentItems = List.generate(end - start, (i) => 'Item ${start + i + 1}');
    });
  }

  List<Widget> _buildPageButtons() {
    List<Widget> buttons = [];
    int maxVisible = 5;

    // Always show first page
    buttons.add(_pageButton(1));

    int start = max(2, currentPage - 1);
    int end = min(totalPages - 1, currentPage + 1);

    if (start > 2) {
      buttons.add(_dots());
    }

    for (int i = start; i <= end; i++) {
      buttons.add(_pageButton(i));
    }

    if (end < totalPages - 1) {
      buttons.add(_dots());
    }

    if (totalPages > 1) {
      buttons.add(_pageButton(totalPages));
    }

    return buttons;
  }

  Widget _pageButton(int page) {
    bool isActive = page == currentPage;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () {
          _loadPage(page);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.deepPurple : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            page.toString(),
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dots() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        "...",
        style: TextStyle(fontSize: 16, color: Colors.black54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination Demo'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: currentItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.label_outline),
                  title: Text(currentItems[index]),
                );
              },
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageButtons(),
            ),
          ),
        ],
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyItem {
  final String admission_number;
  final String student_name;

  MyItem({required this.admission_number, required this.student_name});

  factory MyItem.fromJson(Map<String, dynamic> json) {
    return MyItem(
      admission_number: json['admission_number'],
      student_name: json['student_name'],
    );
  }
}

class Paginationbutton extends StatefulWidget {
  @override
  _PaginationbuttonState createState() => _PaginationbuttonState();
}

class _PaginationbuttonState extends State<Paginationbutton> {
  List<MyItem> _items = [];
  int _currentPage = 1;
  final int _itemsPerPage = 5;
  bool _isLoading = false;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _fetchItems(page: _currentPage);
  }

  Future<void> _fetchItems({required int page}) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final offset = (page - 1) * _itemsPerPage;
    final url =
        'http://192.168.1.36/logiclab_tutorials/get_searchstudentsbutton.php?limit=$_itemsPerPage&offset=$offset';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        final List<dynamic> data = responseData['data'];
        final int totalRecords = responseData['totalRecords'];

        final List<MyItem> newItems =
            data.map((json) => MyItem.fromJson(json)).toList();

        setState(() {
          _items = newItems;
          _currentPage = page;
          _totalPages = (totalRecords / _itemsPerPage).ceil();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error fetching items: $e");
      setState(() => _isLoading = false);
    }
  }

  Widget _buildPaginationBar() {
    List<Widget> pageButtons = [];

    // Show up to 5 visible page numbers around current
    int start = (_currentPage - 2).clamp(1, _totalPages);
    int end = (_currentPage + 2).clamp(1, _totalPages);

    for (int i = start; i <= end; i++) {
      pageButtons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _currentPage == i ? Colors.deepPurple : Colors.grey.shade200,
              foregroundColor:
                  _currentPage == i ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              minimumSize: Size(40, 40),
            ),
            onPressed: () => _fetchItems(page: i),
            child: Text('$i'),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 16),
          onPressed: _currentPage > 1
              ? () => _fetchItems(page: _currentPage - 1)
              : null,
        ),
        ...pageButtons,
        IconButton(
          icon: Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: _currentPage < _totalPages
              ? () => _fetchItems(page: _currentPage + 1)
              : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Pagination')),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return ListTile(
                        title: Text(item.student_name),
                        subtitle:
                            Text('Admission No: ${item.admission_number}'),
                      );
                    },
                  ),
          ),
          SizedBox(height: 8),
          _buildPaginationBar(),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyItem {
  final String admission_number;
  final String student_name;

  MyItem({required this.admission_number, required this.student_name});

  factory MyItem.fromJson(Map<String, dynamic> json) {
    return MyItem(
      admission_number: json['admission_number'],
      student_name: json['student_name'],
    );
  }
}

class Paginationbutton extends StatefulWidget {
  @override
  _PaginationbuttonState createState() => _PaginationbuttonState();
}

class _PaginationbuttonState extends State<Paginationbutton> {
  List<MyItem> _items = [];
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _totalPages = 10; // set manually or from API if available

  @override
  void initState() {
    super.initState();
    _fetchItems(page: _currentPage);
  }

  Future<void> _fetchItems({required int page}) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final offset = (page - 1) * _itemsPerPage;
    final url =
        'http://192.168.1.36/logiclab_tutorials/get_searchstudents.php?limit=$_itemsPerPage&offset=$offset';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<MyItem> newItems =
            data.map((json) => MyItem.fromJson(json)).toList();

        setState(() {
          _items = newItems;
          _currentPage = page;
          _hasMoreData = newItems.length == _itemsPerPage;
          _isLoading = false;
        });

        print("=== Page $_currentPage Data ===");
        for (var item in _items) {
          print(
              'Admission Number: ${item.admission_number}, Student Name: ${item.student_name}');
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error fetching items: $e");
      setState(() => _isLoading = false);
    }
  }

  Widget _buildPaginationBar() {
    List<Widget> pageButtons = [];

    for (int i = 1; i <= _totalPages; i++) {
      pageButtons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _currentPage == i ? Colors.blue : Colors.grey.shade300,
              foregroundColor: _currentPage == i ? Colors.white : Colors.black,
              minimumSize: Size(40, 40),
            ),
            onPressed: () {
              _fetchItems(page: i);
            },
            child: Text('$i'),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: pageButtons,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Numbered Pagination')),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _items.isEmpty
                    ? Center(child: Text("No data found"))
                    : ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return ListTile(
                            title: Text(item.student_name),
                            subtitle:
                                Text('Admission No: ${item.admission_number}'),
                          );
                        },
                      ),
          ),
          SizedBox(height: 10),
          _buildPaginationBar(),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
*/