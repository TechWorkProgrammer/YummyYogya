import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Password dan konfirmasi password tidak cocok")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // URL endpoint Django
    const String url = 'http://127.0.0.1:8000/authentication/register_flutter/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password1': password,
          'password2': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Parsing respon JSON
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          String message = data['message'];

          // Navigasi kembali ke halaman login
          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        }
      } else {
        // Gagal registrasi
        final Map<String, dynamic> data = jsonDecode(response.body);
        String errorMessage = data['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $errorMessage")),
        );
      }
    } catch (e) {
      // Jika ada error saat koneksi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Masukkan username Anda',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Masukkan password Anda',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Konfirmasi Password',
                      hintText: 'Masukkan ulang password Anda',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24.0),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          child: const Text('Register'),
                        ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Kembali ke halaman login
                    },
                    child: Text(
                      'Sudah punya akun? Login di sini',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
