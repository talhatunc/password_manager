import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/main.dart';

import 'dbservice.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  @override
  _PasswordGeneratorScreenState createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  int _numbers = 0;
  int _uppercases = 0;
  int _symbols = 0;
  int _characters = 9;
  String _generatedPassword = "ztsqmxnlc";

  void _generatePassword() {
    const String numbers = '0123456789';
    const String uppercases = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String symbols = '!@#\$%^&*()_+[]{}|;:,.<>?';
    const String lowercases = 'abcdefghijklmnopqrstuvwxyz';

    String allChars = lowercases;
    if (_numbers > 0) allChars += numbers;
    if (_uppercases > 0) allChars += uppercases;
    if (_symbols > 0) allChars += symbols;

    Random random = Random();

    String newPassword = '';
    for (int i = 0; i < _characters; i++) {
      newPassword += allChars[random.nextInt(allChars.length)];
    }

    setState(() {
      _generatedPassword = newPassword;
    });
  }

  void _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _generatedPassword)).then((result) {
      final snackBar = SnackBar(content: Text('Password copied to clipboard'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  void _confirmPassword() async {
    final serviceIdController = TextEditingController();
    final accountIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              cursorColor: Colors.blue,
              controller: serviceIdController,
              decoration: InputDecoration(labelText: 'Service',
                labelStyle: TextStyle(color: Colors.blue),
                focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),),
              ),
            ),
            TextField(
              cursorColor: Colors.blue,
              controller: accountIdController,
              decoration: InputDecoration(labelText: 'Account ID',
                labelStyle: TextStyle(color: Colors.blue),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            onPressed: () {
              final serviceId = serviceIdController.text;
              final accountId = accountIdController.text;

              if (serviceId.isNotEmpty && accountId.isNotEmpty) {
                Dbservice().insertPassword(
                  _generatedPassword,
                  serviceId,
                  accountId,
                );
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordManagerApp()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password saved to database')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in all fields')),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Generator'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Create a Solid Password",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCounter("Numbers", _numbers, (val) {
                    setState(() {
                      _numbers = val;
                    });
                  }),
                  _buildCounter("Uppercases", _uppercases, (val) {
                    setState(() {
                      _uppercases = val;
                    });
                  }),
                  _buildCounter("Symbols", _symbols, (val) {
                    setState(() {
                      _symbols = val;
                    });
                  }),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "CHARACTERS",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "$_characters",
                        style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                      Slider(
                        activeColor: Colors.blue,
                        value: _characters.toDouble(),
                        min: 1,
                        max: 20,
                        divisions: 19,
                        label: _characters.toString(),
                        onChanged: (double value) {
                          setState(() {
                            _characters = value.toInt();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "GENERATED PASSWORD",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _generatedPassword,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: _copyToClipboard,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                    onPressed: _generatePassword,
                    child: Row(
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 5),
                        Text("Generate"),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                      onPressed: _confirmPassword,
                    child: Row(
                      children: [
                        Icon(Icons.check),
                        SizedBox(width: 5),
                        Text("Confirm"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounter(String label, int value, Function(int) onChanged) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_downward),
              onPressed: () {
                if (value > 0) {
                  onChanged(value - 1);
                }
              },
            ),
            Text("$value", style: TextStyle(fontSize: 20)),
            IconButton(
              icon: Icon(Icons.arrow_upward),
              onPressed: () {
                onChanged(value + 1);
              },
            ),
          ],
        ),
      ],
    );
  }
}