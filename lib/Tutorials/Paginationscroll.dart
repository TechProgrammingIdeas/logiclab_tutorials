
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

class Paginationscroll extends StatefulWidget {
  @override
  _PaginationscrollState createState() => _PaginationscrollState();
}

class _PaginationscrollState extends State<Paginationscroll> {
  final List<MyItem> _items = [];
  ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  int _itemsPerPage = 12;
  bool _isLoading = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading && _hasMoreData) {
        _fetchItems();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchItems() async {

    setState(() {
      _isLoading = true;
    });

    final offset = _currentPage * _itemsPerPage;
    
    final url = 'http://192.168.1.36/logiclab_tutorials/get_searchstudents.php?limit=$_itemsPerPage&offset=$offset'; // Replace with your actual API endpoint
    
    try {
      final response = await http.get(Uri.parse(url));

      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<MyItem> newItems = data.map((json) => MyItem.fromJson(json)).toList();

        //print(newItems);

        setState(() {
          _items.addAll(newItems);
          _currentPage++;
          _isLoading = false;
          _hasMoreData = newItems.length == _itemsPerPage; // Check if fewer items than limit, indicating end
        });

        //print(newItems);
        //print(_items);
        //


print("********");
        for (var item in _items) {
    print('Admission Number: ${item.admission_number}, Student Name: ${item.student_name}');
  }

  print("*****111111***");
        for (var item in newItems) {
    print('Admission Number: ${item.admission_number}, Student Name: ${item.student_name}');
  }


      } else {
           setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Paginated List')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _items.length + (_isLoading && _hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return Center(child: CircularProgressIndicator());
          }
          final item = _items[index];
          return ListTile(
            title: Text(item.student_name),
            subtitle: Text('ID: ${item.admission_number}'),
          );
        },
      ),
    );
  }
}
    
    

    /*
    import 'package:flutter/material.dart';
    import 'package:http/http.dart' as http;
    import 'dart:convert';

    class Paginationscroll extends StatefulWidget {
      @override
      _PaginationscrollState createState() => _PaginationscrollState();
    }

    class _PaginationscrollState extends State<Paginationscroll> {
      List<String> _items = [];
      int _pageNumber = 1;
      bool _isLoading = false;
      bool _hasMore = true;
      int _currentPage = 0;
      int _itemsPerPage = 12;
      ScrollController _scrollController = ScrollController();

      @override
      void initState() {
        super.initState();
        _fetchItems();
        _scrollController.addListener(() {
          if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading && _hasMore) {
            _fetchItems();
          }
        });
      }

      @override
      void dispose() {
        _scrollController.dispose();
        super.dispose();
      }

      Future<void> _fetchItems() async {
        if (_isLoading || !_hasMore) return;

        setState(() {
          _isLoading = true;
        });

        // Replace with your actual API endpoint
        //final response = await http.get(Uri.parse('http://192.168.1.35/logiclab_tutorials/get_searchstudents.php?page=$_pageNumber&limit=10'));

        final offset = _currentPage * _itemsPerPage;
        // final url = 'http://192.168.1.33/flutter_dsms/api/get_pagination.php?limit=$_itemsPerPage&offset=$offset';

        final response = await http.get(Uri.parse('http://192.168.1.35/logiclab_tutorials/get_searchstudents.php?limit=$_itemsPerPage&offset=$offset'));

        if (response.statusCode == 200) {
          final List<dynamic> newItems = json.decode(response.body);
          setState(() {
            _items.addAll(newItems.map((item) => item['student_name'] as String)); // Adjust based on your JSON structure
            print(_items);
            //_pageNumber++;
            _currentPage++;
            _isLoading = false;
            if (newItems.isEmpty || newItems.length < 10) { // Assuming 10 items per page
              _hasMore = false;
            }
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          // Handle error
          print('Failed to load items: ${response.statusCode}');
        }
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('Paginated List')),
          body: ListView.builder(
            controller: _scrollController,
            itemCount: _items.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _items.length) {
                return ListTile(title: Text(_items[index]));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      }
    }
    */