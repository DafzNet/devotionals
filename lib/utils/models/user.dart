// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  dynamic userID;
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  String? department;
  String? cell;
  String? gender;
  bool? memberOfhurch;
  String? photoUrl;
  String email;
  String phone;

  User({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.department,
    this.cell,
    this.gender,
    this.memberOfhurch,
    this.photoUrl,
    required this.email,
    required this.phone,
  });

  
  User copyWith({
    dynamic? userID,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? department,
    String? cell,
    String? gender,
    bool? memberOfhurch,
    String? photoUrl,
    String? email,
    String? phone,
  }) {
    return User(
      userID: userID ?? this.userID,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      department: department ?? this.department,
      cell: cell ?? this.cell,
      gender: gender ?? this.gender,
      memberOfhurch: memberOfhurch ?? this.memberOfhurch,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'department': department,
      'cell': cell,
      'gender': gender,
      'memberOfhurch': memberOfhurch,
      'photoUrl': photoUrl,
      'email': email,
      'phone': phone,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userID: map['userID'] as dynamic,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int),
      department: map['department'] != null ? map['department'] as String : null,
      cell: map['cell'] != null ? map['cell'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      memberOfhurch: map['memberOfhurch'] != null ? map['memberOfhurch'] as bool : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      email: map['email'] as String,
      phone: map['phone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(userID: $userID, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, department: $department, cell: $cell, gender: $gender, memberOfhurch: $memberOfhurch, photoUrl: $photoUrl, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.userID == userID &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.dateOfBirth == dateOfBirth &&
      other.department == department &&
      other.cell == cell &&
      other.gender == gender &&
      other.memberOfhurch == memberOfhurch &&
      other.photoUrl == photoUrl &&
      other.email == email &&
      other.phone == phone;
  }

  @override
  int get hashCode {
    return userID.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      dateOfBirth.hashCode ^
      department.hashCode ^
      cell.hashCode ^
      gender.hashCode ^
      memberOfhurch.hashCode ^
      photoUrl.hashCode ^
      email.hashCode ^
      phone.hashCode;
  }
}
