# Password Manager

A simple and secure Flutter application for managing and generating passwords. This app provides functionalities to create, store, and organize passwords securely using SQLite for local data persistence.

## Features

- **Password Generation**: Generate strong passwords with customizable options.
- **Password Management**: Save, view, and delete passwords.
- **Categorization**: Organize passwords into categories such as All, Social, Entertainment, and Education.
- **Copy Password**: Copy passwords to clipboard for easy use.
- **UI/UX**: Clean and intuitive interface with a modern design.

## Screens

### Password Manager Screen

- **All Passwords**: View all saved passwords.
- **Social**: View passwords related to social media accounts.
- **Entertainment**: View passwords for entertainment services.
- **Education**: View passwords related to educational services.
- **Add Password**: Navigate to the Password Generator screen to create and save a new password.

### Password Generator Screen

- **Generate Password**: Customize and generate a password with specific criteria (numbers, uppercases, symbols).
- **Confirm and Save**: Input details and save the generated password to the database.

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/talhatunc/password_manager
   
2. **Navigate to the project directory:**

  cd password_manager

3. **Install dependencies:**

flutter pub get

4. **Run the app:**

flutter run

## Database Schema

The app uses SQLite for local storage. The database schema is as follows:

- **Table: passwords**
  - id (INTEGER, PRIMARY KEY, AUTOINCREMENT)
  - password (TEXT)
  - service_id (TEXT)
  - account_id (TEXT)
 
## Technologies Used

- Flutter: For building the user interface and handling application logic.
- SQLite: For local database management.
- Font Awesome: For icons.

## Contributing

- Fork the repository
- Create a new branch (git checkout -b feature-branch)
- Commit your changes (git commit -am 'Add new feature')
- Push to the branch (git push origin feature-branch)
- Create a new Pull Request

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/talhatunc/password_manager/blob/master/LICENSE) file for details
