
import 'package:flutter/material.dart';
import 'package:logiclab_tutorials/Tutorials/PDFScreen.dart';


class PDFIndex extends StatelessWidget {
  const PDFIndex({super.key});

  @override
  Widget build(BuildContext context) {
    // Example Google Drive PDF link
    const pdfUrl = "https://drive.google.com/uc?export=download&id=1J3kcH0O6v1NFRajK4fP1_4v4pY2H6cHY";

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open PDF'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PDFScreen(url: pdfUrl),
              ),
            );
          },
        ),
      ),
    );
  }
}
