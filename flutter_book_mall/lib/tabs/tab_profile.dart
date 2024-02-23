import 'package:flutter/material.dart';
import 'package:flutter_book_mall/models/model_auth.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authClient =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Profile'),
          TextButton(
              onPressed: () async {
                await authClient.logout();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text("로그아웃 되었습니다.")),
                  );
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: const Text('Logout')),
        ],
      ),
    );
  }
}
