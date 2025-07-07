part of 'register_bloc.dart';

abstract class RegisterEvent {}

class SubmitRegistration extends RegisterEvent {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password;
  final String gender;
  final String birthDate;

  SubmitRegistration({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.gender,
    required this.birthDate,
  });
}