import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  bool isLoading = false;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  String selectedRole = 'user';

  Future<void> registerUser() async {
    if (nameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        passCtrl.text.isEmpty ||
        confirmPassCtrl.text.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }

    if (passCtrl.text != confirmPassCtrl.text) {
      _showMessage('Passwords do not match');
      return;
    }

    if (passCtrl.text.length < 6) {
      _showMessage('Password must be at least 6 characters');
      return;
    }

    setState(() => isLoading = true);

    try {
      final userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      await FirebaseFirestore.instance.collection('users').doc(userCred.user!.uid).set({
        'name': nameCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
        'phone': phoneCtrl.text.trim(),
        'role': selectedRole,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await userCred.user!.sendEmailVerification();

      if (mounted) {
        _showSuccessDialog(emailCtrl.text.trim());
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = switch (e.code) {
        'email-already-in-use' => 'This email is already registered.',
        'invalid-email' => 'The email address is invalid.',
        'operation-not-allowed' => 'Email/password accounts are not enabled.',
        'weak-password' => 'The password is too weak.',
        _ => 'Registration failed: ${e.message}',
      };

      _showMessage(errorMessage);
    } catch (e) {
      _showMessage('An error occurred: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccessDialog(String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Registration Successful', style: TextStyle(color: Colors.green)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('A verification email has been sent to:'),
            const SizedBox(height: 8),
            Text(email, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 16),
            const Text('Please verify your email before logging in.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('OK', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null && !user.emailVerified) {
                await user.sendEmailVerification();
                _showMessage('Verification email resent!');
              }
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Resend Email', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // light orange
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              children: [
                const Icon(Icons.app_registration, size: 80, color: Colors.green),
                const SizedBox(height: 10),
                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                _buildTextField(controller: nameCtrl, label: 'Name', icon: Icons.person),
                const SizedBox(height: 16),
                _buildTextField(controller: emailCtrl, label: 'Email', icon: Icons.email, inputType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildTextField(controller: phoneCtrl, label: 'Phone Number', icon: Icons.phone, inputType: TextInputType.phone),
                const SizedBox(height: 16),
                _buildPasswordField(controller: passCtrl, label: 'Password', isVisible: passwordVisible, toggleVisibility: () {
                  setState(() => passwordVisible = !passwordVisible);
                }),
                const SizedBox(height: 16),
                _buildPasswordField(controller: confirmPassCtrl, label: 'Confirm Password', isVisible: confirmPasswordVisible, toggleVisibility: () {
                  setState(() => confirmPasswordVisible = !confirmPasswordVisible);
                }),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'user', child: Text('User')),
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  ],
                  onChanged: (value) => setState(() => selectedRole = value!),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: isLoading ? null : registerUser,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Register', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
