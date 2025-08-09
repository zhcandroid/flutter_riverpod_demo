import "package:flutter/material.dart";

///  author : zhc 2025/8/9 22:58
///  desc   :

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;

  UserModel({this.id, this.name, this.email, this.phone});

  UserModel copyWith({String? id, String? name, String? email, String? phone}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'phone': phone};
  }
}
