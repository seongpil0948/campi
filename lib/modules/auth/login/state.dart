import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class LoginState extends Equatable {
  const LoginState({
    // this.email = const Email.pure(),
    // this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  // final Email email;
  // final Password password;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [status];
  // List<Object> get props => [email, password, status];

  LoginState copyWith({
    // Email? email,
    // Password? password,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      // email: email ?? this.email,
      // password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


// class Email extends FormzInput<String, EmailValidationError> {
//   /// {@macro email}
//   const Email.pure() : super.pure('');

//   /// {@macro email}
//   const Email.dirty([String value = '']) : super.dirty(value);

//   static final RegExp _emailRegExp = RegExp(
//     r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
//   );

//   @override
//   EmailValidationError? validator(String? value) {
//     return _emailRegExp.hasMatch(value ?? '')
//         ? null
//         : EmailValidationError.invalid;
//   }
// }


// import 'package:formz/formz.dart';

// /// Validation errors for the [Password] [FormzInput].
// enum PasswordValidationError {
//   /// Generic invalid error.
//   invalid
// }

// /// {@template password}
// /// Form input for an password input.
// /// {@endtemplate}
// class Password extends FormzInput<String, PasswordValidationError> {
//   /// {@macro password}
//   const Password.pure() : super.pure('');

//   /// {@macro password}
//   const Password.dirty([String value = '']) : super.dirty(value);

//   static final _passwordRegExp =
//       RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

//   @override
//   PasswordValidationError? validator(String? value) {
//     return _passwordRegExp.hasMatch(value ?? '')
//         ? null
//         : PasswordValidationError.invalid;
//   }
// }
