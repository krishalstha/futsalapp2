// // User model
// class User {
//   final String username;
//   final String phoneNumber;
//   final String email;
//   final String password;
//   final String role;
//
//   User({
//     required this.username,
//     required this.phoneNumber,
//     required this.email,
//     required this.password,
//     this.role = 'user', // Default role is 'user'
//   });
//
//   // You can add methods like toJson, fromJson for serialization if needed.
//   Map<String, dynamic> toJson() {
//     return {
//       'username': username,
//       'phoneNumber': phoneNumber,
//       'email': email,
//       'password': password,
//       'role': role,
//     };
//   }
//
//   static User fromJson(Map<String, dynamic> json) {
//     return User(
//       username: json['username'],
//       phoneNumber: json['phoneNumber'],
//       email: json['email'],
//       password: json['password'],
//       role: json['role'],
//     );
//   }
// }
//
// // Admin model
// class Admin {
//   final String adminName;
//   final String phoneNumber;
//   final String email;
//   final String password;
//   final String role;
//
//   Admin({
//     required this.adminName,
//     required this.phoneNumber,
//     required this.email,
//     required this.password,
//     this.role = 'admin', // Default role is 'admin'
//   });
//
//   // You can add methods like toJson, fromJson for serialization if needed.
//   Map<String, dynamic> toJson() {
//     return {
//       'adminName': adminName,
//       'phoneNumber': phoneNumber,
//       'email': email,
//       'password': password,
//       'role': role,
//     };
//   }
//
//   static Admin fromJson(Map<String, dynamic> json) {
//     return Admin(
//       adminName: json['adminName'],
//       phoneNumber: json['phoneNumber'],
//       email: json['email'],
//       password: json['password'],
//       role: json['role'],
//     );
//   }
// }
