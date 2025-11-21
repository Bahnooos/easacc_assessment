import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/cubit/login_cubit.dart';

class FacebookButtonWidget extends StatelessWidget {
  const FacebookButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.facebook, size: 28),
      label: const Text('Sign in with Facebook'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1877F2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: () => context.read<AuthCubit>().signInWithFacebook(),
    );
  }
}
