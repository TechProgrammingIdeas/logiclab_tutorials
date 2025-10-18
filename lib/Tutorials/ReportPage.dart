// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized(); // ✅ Required
// //   runApp(MaterialApp(
// //     debugShowCheckedModeBanner: false,
// //     home: ReportPage(),
// //   ));
// // }

// class ReportPage extends StatelessWidget {

//   Future<void> _shareReport() async {
//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final filePath = '${directory.path}/report.pdf';

//       final file = File(filePath);
//       if (!await file.exists()) {
//         await file.writeAsBytes([0x25, 0x50, 0x44, 0x46]); // Dummy PDF
//       }

//       await Share.shareXFiles(
//         [XFile(filePath)],
//         text: "Here is your report PDF 📄",
//       );
//     } catch (e) {
//       print("Error sharing file: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Report Page")),
//       body: Center(
//         child: ElevatedButton.icon(
//           icon: Icon(Icons.share),
//           label: Text("Share Report"),
//           onPressed: _shareReport,
//         ),
//       ),
//     );
//   }
// }
