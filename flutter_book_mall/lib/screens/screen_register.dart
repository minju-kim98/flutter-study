import 'package:flutter/material.dart';
import 'package:flutter_book_mall/models/model_auth.dart';
import 'package:flutter_book_mall/models/model_register.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterFieldModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('회원가입 화면'),
        ),
        body: const Column(
          children: [
            EmailInput(),
            PasswordInput(),
            PasswordConfirmInput(),
            RegisterButton(),
          ],
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    final registerField =
        Provider.of<RegisterFieldModel>(context, listen: false);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: TextField(
        onChanged: (email) {
          registerField.setEmail(email);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: '이메일',
          helperText: '',
        ),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    final registerField =
        Provider.of<RegisterFieldModel>(context, listen: false);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: TextField(
        onChanged: (password) {
          registerField.setPassword(password);
        },
        obscureText: true,
        decoration: const InputDecoration(
          labelText: '비밀번호',
          helperText: '',
        ),
      ),
    );
  }
}

class PasswordConfirmInput extends StatelessWidget {
  const PasswordConfirmInput({super.key});

  @override
  Widget build(BuildContext context) {
    final registerField = Provider.of<RegisterFieldModel>(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: TextField(
        onChanged: (password) {
          registerField.setPasswordConfirm(password);
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: '비밀번호 확인',
          helperText: '',
          errorText: registerField.password != registerField.passwordConfirm
              ? '비밀번호가 일치하지 않습니다.'
              : null,
        ),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authClient =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
    final registerField =
        Provider.of<RegisterFieldModel>(context, listen: false);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () async {
          await authClient
              .registerWithEmail(registerField.email, registerField.password)
              .then((registerStatus) {
            if (registerStatus == AuthStatus.registerSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('회원가입이 완료되었습니다!')),
                );
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('회원가입을 실패했습니다. 다시 시도해주세요.')),
                );
            }
          });
        },
        child: const Text('회원가입'),
      ),
    );
  }
}
