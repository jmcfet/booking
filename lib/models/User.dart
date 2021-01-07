import 'package:json_annotation/json_annotation.dart';
//https://flutter.dev/docs/development/data-and-backend/json#serializing-json-inside-model-classes
//flutter packages pub run build_runner build
part 'User.g.dart';

@JsonSerializable(nullable: false)
class User{
  String Id;
  String firstName;
  String lastName;
  String Email;
  String Password;
  String ConfirmPassword;
  String PhoneNumber;


  User({this.Id,this.firstName,this.lastName,this.Email,this.Password,this.ConfirmPassword,this.PhoneNumber});

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}