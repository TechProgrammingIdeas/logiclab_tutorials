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

class PaginationButton extends StatefulWidget {
  const PaginationButton({super.key});

  @override
  State<PaginationButton> createState() => _PaginationButtonState();
}

class _PaginationButtonState extends State<PaginationButton> {
  List<MyItem> _items = [];
  int _currentPage = 1;
  final int _itemsPerPage = 10;
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
    final url = 'http://192.168.1.36/logiclab_tutorials/get_searchstudentsbutton.php?limit=$_itemsPerPage&offset=$offset';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        final List<dynamic> data = responseData['data'];
        final int totalRecords = int.parse(responseData['totalRecords'].toString());

        final List<MyItem> newItems =
            data.map((json) => MyItem.fromJson(json)).toList();

        setState(() {
          _items = newItems;
          _currentPage = page;
          _totalPages = (totalRecords / _itemsPerPage).ceil();
          _isLoading = false;
        });

       
        //print("✅ Page $page loaded (${_items.length} items)");
      } else {
        setState(() => _isLoading = false);
        //print("❌ Server Error: ${response.statusCode}");
      }
    } catch (e) {
      //print("⚠️ Error fetching items: $e");
      setState(() => _isLoading = false);
    }
  }

  //pagination bar ....
  Widget _buildPaginationBar() {
    List<Widget> buttons = [];

    // Always show first page
    buttons.add(_pageButton(1));

    // Show "..." if needed
    if (_currentPage > 3) {
      buttons.add(_dots());
    }

    // Pages around current page
    for (int i = _currentPage - 1; i <= _currentPage + 1; i++) {
      if (i > 1 && i < _totalPages) {
        buttons.add(_pageButton(i));
      }
    }

    // Show "..." before last page
    if (_currentPage < _totalPages - 2) {
      buttons.add(_dots());
    }

    // Always show last page if more than 1 page
    if (_totalPages > 1) {
      buttons.add(_pageButton(_totalPages));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 16),
          onPressed: _currentPage > 1
              ? () => _fetchItems(page: _currentPage - 1)
              : null,
        ),
        ...buttons,
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: _currentPage < _totalPages
              ? () => _fetchItems(page: _currentPage + 1)
              : null,
        ),
      ],
    );
  }
 
  Widget _pageButton(int page) {
    bool isActive = page == _currentPage;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () {
          _fetchItems(page: page);
          //_loadPage(page);
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
      child: Text("...", style: TextStyle(fontSize: 16, color: Colors.black54)),
    );
  }
  
  //pagination bar ....


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paginated Button List"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
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
          const Divider(),
          const SizedBox(height: 8),
          _buildPaginationBar(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
