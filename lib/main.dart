import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Ensures Flutter is ready before we connect to the database
  WidgetsFlutterBinding.ensureInitialized();

  // Connects to your specific Zero-Knowledge Vault database
  await Supabase.initialize(
    url: 'https://bhmitraqbedgvodriutd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJobWl0cmFxYmVkZ3ZvZHJpdXRkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTE4NTM1MDgsImV4cCI6MjEwNzQyOTUwOH0.e2uJiV_MwgQ7vFcDVMyjdnPkw9UvmHqBKNhTkuxOUJQ',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zero-Knowledge Vault',
      theme: ThemeData.dark(), // Standard dark mode UI
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _supabase = Supabase.instance.client;

  // Backend Logic: Sign Up Request
  Future<void> _signUp() async {
    try {
      await _supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Check Supabase.'))
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Auth Error: $e'))
        );
      }
    }
  }

  // Backend Logic: Login Request
  Future<void> _signIn() async {
    try {
      await _supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful! Token received.'))
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Auth Error: $e'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vault Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email Address'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Master Password'),
              obscureText: true, // Hides the password input
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _signIn, child: const Text('Login')),
                TextButton(onPressed: _signUp, child: const Text('Sign Up')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}