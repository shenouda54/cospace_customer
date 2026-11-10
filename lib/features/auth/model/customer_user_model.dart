import 'package:equatable/equatable.dart';

/// Data model representing a customer user.
class CustomerUserModel extends Equatable {
  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;

  const CustomerUserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  factory CustomerUserModel.fromJson(Map<String, dynamic> json) {
    return CustomerUserModel(
      uid: json['uid'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
      };

  @override
  List<Object?> get props => [uid, fullName, email, phoneNumber];
}
