import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'createpassword.dart';
import 'dbservice.dart';

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

  List<PasswordItemData> allPasswords = [];
  List<PasswordItemData> socialPasswords = [];
  List<PasswordItemData> entertainmentPasswords = [];
  List<PasswordItemData> educationPasswords = [];

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  Future<void> _loadPasswords() async {
    final List<Map<String, dynamic>> maps = await Dbservice().getPasswords();
    setState(() {
      allPasswords = maps.map((map) => PasswordItemData(
        id: map['id'].toString(),
        icon: _getIcon(map['service_id']),
        title: map['service_id'],
        pass: map['password'],
        username: map['account_id'],
        tab: _getTab(map['service_id']),
      )).toList();

      socialPasswords = allPasswords.where((item) => item.tab == 'S').toList();
      entertainmentPasswords = allPasswords.where((item) => item.tab == 'M').toList();
      educationPasswords = allPasswords.where((item) => item.tab == 'E').toList();
    });
  }

  String _getTab(String serviceId) {
    switch (serviceId) {
      case 'Instagram':
      case 'X':
      case 'LinkedIn':
      case 'Facebook':
        return 'S';
      case 'Amazon':
      case 'Netflix':
      case 'Disney+':
        return 'M';
      case 'Udemy':
        return 'E';
      default:
        return 'A';
    }
  }

  FaIcon _getIcon(String serviceId) {
    switch (serviceId) {
      case 'Instagram':
        return FaIcon(FontAwesomeIcons.instagram);
      case 'X':
        return FaIcon(FontAwesomeIcons.xTwitter);
      case 'Facebook':
        return FaIcon(FontAwesomeIcons.facebookF);
      case 'Disney+':
        return FaIcon(FontAwesomeIcons.film);
      case 'LinkedIn':
        return FaIcon(FontAwesomeIcons.linkedinIn);
      case 'Amazon':
        return FaIcon(FontAwesomeIcons.amazon);
      case 'Netflix':
        return FaIcon(FontAwesomeIcons.n);
      case 'Udemy':
        return FaIcon(FontAwesomeIcons.u);
      default:
        return FaIcon(FontAwesomeIcons.question);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = [
      PasswordListScreen(passwords: allPasswords, onPasswordDelete: _handlePasswordDelete),
      PasswordListScreen(passwords: socialPasswords, onPasswordDelete: _handlePasswordDelete),
      PasswordListScreen(passwords: entertainmentPasswords, onPasswordDelete: _handlePasswordDelete),
      PasswordListScreen(passwords: educationPasswords, onPasswordDelete: _handlePasswordDelete),
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
        unselectedItemColor: Color(0xFFDCDCDC),
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

  void _handlePasswordDelete(String id) async {
    await Dbservice().deletePassword(id);
    _loadPasswords(); // Refresh the list after deletion
    final snackBar = SnackBar(content: Text('Password deleted'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class PasswordListScreen extends StatelessWidget {
  final List<PasswordItemData> passwords;
  final Function(String) onPasswordDelete; // Callback for deletion

  PasswordListScreen({
    required this.passwords,
    required this.onPasswordDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          Text('${passwords.length} Passwords', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          ...passwords.map((password) => PasswordItem(
            id: password.id,
            icon: password.icon,
            title: password.title,
            username: password.username,
            pass: password.pass,
            tab: password.tab,
            onDelete: () => onPasswordDelete(password.id), // Pass callback
          )),
        ],
      ),
    );
  }
}

class PasswordItem extends StatelessWidget {
  final String id;
  final FaIcon icon;
  final String title;
  final String username;
  final String pass;
  final String tab;
  final VoidCallback onDelete; // Callback for deletion

  PasswordItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.username,
    required this.tab,
    required this.pass,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: icon,
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(username),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'copy') {
              _copyPassword(context, pass);
            } else if (value == 'delete') {
              _deletePassword(context);
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'copy',
              child: Text('Copy Password'),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  void _copyPassword(BuildContext context, String pass) async {
    await Clipboard.setData(ClipboardData(text: pass)).then((result) {
      final snackBar = SnackBar(content: Text('Password copied to clipboard'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  void _deletePassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this password?'),
        actions: [
          TextButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onDelete(); // Call the deletion callback
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class PasswordItemData {
  final String id;
  final FaIcon icon;
  final String title;
  final String username;
  final String pass;
  final String tab;

  PasswordItemData({
    required this.id,
    required this.icon,
    required this.title,
    required this.username,
    required this.pass,
    required this.tab,
  });
}
