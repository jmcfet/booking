part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      Id: json['Id'] as String,
      Email: json['Email'] as String,
      Password: json['Password'] as String,
      ConfirmPassword: json['ConfirmPassword'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      PhoneNumber: json['phoneNumber'] as String);

}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.Id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'Email': instance.Email,
  'Password': instance.Password,
  'PhoneNumber': instance.PhoneNumber,

};
