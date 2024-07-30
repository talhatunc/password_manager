import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
void main() {
  runApp(PasswordManagerApp());
}

class PasswordManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PasswordManagerScreen(),
    );
  }
}

class PasswordManagerScreen extends StatefulWidget {
  @override
  _PasswordManagerScreenState createState() => _PasswordManagerScreenState();
}

class _PasswordManagerScreenState extends State<PasswordManagerScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    PasswordListScreen(),
    Center(child: Text('Social', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    Center(child: Text('Entertainment', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    Center(child: Text('Education', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keep your Passwords safe'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {

            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Social',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Entertainment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Education',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PasswordListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          Text('0 Passwords', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          PasswordItem(icon: FaIcon(FontAwesomeIcons.instagram), title: 'Instagram', username: 'talhatuncc__'),
          PasswordItem(icon: FaIcon(FontAwesomeIcons.twitter), title: 'X', username: 'talhatunc'),
          PasswordItem(icon: FaIcon(FontAwesomeIcons.linkedinIn),title: 'LinkedIn', username: 'talhatunc',),
        ],
      ),
    );
  }
}

class PasswordItem extends StatelessWidget {
  final FaIcon icon;
  final String title;
  final String username;

  PasswordItem({required this.icon, required this.title, required this.username});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: icon,
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(username),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}