// ignore_for_file: public_member_api_docs, sort_constructors_first
/*
 * Copyright (c) 2021 Akshay Jadhav <jadhavakshay0701@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 3 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  @JsonKey(name: 'created_at')
  String? createdAt;
  String? email; 
  String? role;
  String? name;
  String? gender;
  @JsonKey(name: 'user_id')
  String? userId;
  Account({
    this.createdAt,
    this.email,
    this.role,
    this.name,
    this.gender,
    this.userId,
  });

  Map<String, dynamic> toMap() => _$AccountToJson(this);

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  Account copyWith({
    String? createdAt,
    String? email,
    String? role,
    String? name,
    String? gender,
    String? userId,
  }) {
    return Account(
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      role: role ?? this.role,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      userId: userId ?? this.userId,
    );
  }
}
