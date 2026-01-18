import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PDFScreen extends StatefulWidget {
  final String url;
  const PDFScreen({super.key, required this.url});

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  String? localPath;
  bool loading = true;

  int pages = 0;
  int currentPage = 0;

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  @override
  void initState() {
    super.initState();
    downloadPDF();
  }

  Future<void> downloadPDF() async {
    final response = await http.get(Uri.parse(widget.url));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/temp.pdf');
    await file.writeAsBytes(response.bodyBytes, flush: true);

    setState(() {
      localPath = file.path;
      loading = false;
    });
  }

  Future<void> _goToPage(int page) async {
    if (!_controller.isCompleted) return;

    final controller = await _controller.future;
    await controller.setPage(page);

    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Page ${currentPage + 1} / $pages'),
      ),
      body: PDFView(
        filePath: localPath!,
        enableSwipe: true,
        autoSpacing: true,
        pageFling: true,

        onViewCreated: (PDFViewController controller) {
          if (!_controller.isCompleted) {
            _controller.complete(controller);
          }
        },

        onRender: (totalPages) {
          setState(() {
            pages = totalPages ?? 0;
          });
        },

        onPageChanged: (page, total) {
          setState(() {
            currentPage = page ?? 0;
          });
        },
      ),

      floatingActionButton: Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    FloatingActionButton(
      heroTag: 'prev',
      mini: true,
      child: const Icon(Icons.chevron_left),
      onPressed: currentPage > 0
          ? () => _goToPage(currentPage - 1)
          : null,
    ),
    const SizedBox(width: 8),
    FloatingActionButton(
      heroTag: 'next',
      mini: true,
      child: const Icon(Icons.chevron_right),
      onPressed: currentPage < pages - 1
          ? () => _goToPage(currentPage + 1)
          : null,
    ),
  

        ],
      ),
    );
  }
}


/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PDFScreen extends StatefulWidget {
  final String url;
  const PDFScreen({super.key, required this.url});

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  String? localPath;
  bool loading = true;
  int pages = 0;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    downloadPDF();
  }

  Future<void> downloadPDF() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/temp.pdf');
      await file.writeAsBytes(bytes, flush: true);

      setState(() {
        localPath = file.path;
        loading = false;
      });
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Page ${currentPage + 1} / $pages'),
      ),

      

      body: PDFView(
        filePath: localPath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onRender: (totalPages) {
          setState(() {
            pages = totalPages!;
          });
        },
        onPageChanged: (page, total) {
          setState(() {
            currentPage = page!;
          });
        },
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
      ),
    );
  }


  


}

*/