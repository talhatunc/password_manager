import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'createpassword.dart';
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
  PageController _pageController = PageController();

  List<PasswordItem> allPasswords = [
    PasswordItem(icon: FaIcon(FontAwesomeIcons.instagram), title: 'Instagram', username: 'talhatuncc__', tab: 'S'),
    PasswordItem(icon: FaIcon(FontAwesomeIcons.xTwitter), title: 'X', username: 'talhatunc', tab: 'S'),
    PasswordItem(icon: FaIcon(FontAwesomeIcons.linkedinIn), title: 'LinkedIn', username: 'talhatunc', tab: 'S'),
    PasswordItem(icon: FaIcon(FontAwesomeIcons.amazon), title: 'Amazon', username: 'talhatunc', tab: 'S'),
    PasswordItem(icon: FaIcon(FontAwesomeIcons.n), title: 'Netflix', username: 'talhatunc', tab: 'M'),
    PasswordItem(icon: FaIcon(FontAwesomeIcons.u), title: 'Udemy', username: 'talhatunc', tab: 'E'),
  ];

  List<PasswordItem> get socialPasswords => allPasswords.where((item) => item.tab == 'S').toList();

  List<PasswordItem> get entertainmentPasswords => allPasswords.where((item) => item.tab == 'M').toList();

  List<PasswordItem> get educationPasswords => allPasswords.where((item) => item.tab == 'E').toList();

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = [
      PasswordListScreen(passwords: allPasswords),
      PasswordListScreen(passwords: socialPasswords),
      PasswordListScreen(passwords: entertainmentPasswords),
      PasswordListScreen(passwords: educationPasswords),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Keep your Passwords safe'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PasswordGeneratorScreen()),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: widgetOptions,
      ),
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
        unselectedItemColor: Color(0xFFDCDCDC), //gainsboro
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class PasswordListScreen extends StatelessWidget {
  final List<PasswordItem> passwords;

  PasswordListScreen({required this.passwords});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          Text('${passwords.length} Passwords', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          ...passwords,
        ],
      ),
    );
  }
}

class PasswordItem extends StatelessWidget {
  final FaIcon icon;
  final String title;
  final String username;
  final String tab;

  PasswordItem({required this.icon, required this.title, required this.username, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: icon,
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(username),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}