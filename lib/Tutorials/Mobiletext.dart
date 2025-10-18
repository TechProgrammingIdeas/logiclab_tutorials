import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logiclab_tutorials/Global/PublicFunctions.dart';

class Mobiletext extends StatefulWidget {
  @override
  _MobiletextState createState() => _MobiletextState();
}

class _MobiletextState extends State<Mobiletext> {
  final TextEditingController _topController = TextEditingController();
  final TextEditingController _bottomController = TextEditingController();

  TextEditingController _mobileController = TextEditingController();
  FocusNode _mobileFocus = FocusNode();
  String? _errorMobile;

  @override
  void initState() {
    super.initState();

    _topController.addListener(() {
      final text = _topController.text;
      if (text.length > 10) {
        _bottomController.text = text.substring(text.length - 10);
      } else {
        _bottomController.text = text;
      }
    });

   

     _bottomController.addListener(() {
      final text = _bottomController.text;

      if (text.length > 10) {
        // Keep only the last 10 characters
        final last10 = text.substring(text.length - 10);
        _bottomController.value = TextEditingValue(
          text: last10,
          selection: TextSelection.collapsed(offset: last10.length),
        );
      }
    });


     _mobileController.addListener(() {
      final text = _mobileController.text;
      if (text.length > 10) {
        // Keep only the last 10 characters
        final last10 = text.substring(text.length - 10);
        _mobileController.value = TextEditingValue(
          text: last10,
          selection: TextSelection.collapsed(offset: last10.length),
        );
      }
    });

    _mobileFocus.addListener(() {
      if (!_mobileFocus.hasFocus && _mobileController.text.trim().isEmpty) {  // Check if focus is lost
        setState(() {
          _errorMobile = validateMobileNumber(_mobileController.text);
        });
      }
    });


  }

  @override
  void dispose() {
    _topController.dispose();
    _bottomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Last 10 Digits Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _topController,
              decoration: InputDecoration(
                labelText: "Paste full text here",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bottomController,
              //readOnly: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Last 10 digits",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 40),

            SizedBox(
              height: 40,
              //width: 271,
              child: TextField(
                style: TextStyle(
                  fontSize: 12,
                  color: (_errorMobile != null && _errorMobile!.isNotEmpty) 
                    ? Colors.red[900] 
                    : Colors.black87, 
                ),
                keyboardType: TextInputType.phone,
                controller: _mobileController,
                focusNode: _mobileFocus,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  //LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(15.0, 00.0, 10.0, 00.0),
                  labelText: "Mobile",
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: (_errorMobile != null && _errorMobile!.isNotEmpty) 
                    ? Colors.red[900] 
                    : Colors.black87, 
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: _errorMobile == null ? Colors.black45 : const Color.fromARGB(255, 178, 39, 29), // Normal border or error border
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${_mobileController.text.length}/10", // Count inside the field
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      if (_mobileController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _mobileController.clear();
                              _errorMobile = null;
                              FocusScope.of(context).requestFocus(_mobileFocus);
                            });
                          },
                        ),
                    ],
                  ),
                ),
                onChanged: (text) async {
                  setState(() {
                    _errorMobile = validateMobileNumber(text);
                    
                  });
        
                  if (_errorMobile == null) {
                    // bool exists = await checkMobileExists(text);
                    // setState(() {
                    //   if (exists) {
                    //     _errorMobile = "This mobile is already registered!";       
                    //   }
                    // });
                  }
          
                },
              ),
            ),
            if (_errorMobile != null && _errorMobile!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 4.0),
              child: Text(
                _errorMobile!,
                style: TextStyle(color: Colors.red[900], fontSize: 12),
              ),
            ),



          ],
        ),
      ),
    );
  }
}
