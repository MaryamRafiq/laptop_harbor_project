import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  bool showCurrent = false;
  bool showNew = false;
  bool showConfirm = false;
  bool isLoading = false;

  String? currentError;
  String? newError;
  String? confirmError;

  @override
  void dispose() {
    currentController.dispose();
    newController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
  final user = FirebaseAuth.instance.currentUser;
  final currentPassword = currentController.text.trim();
  final newPassword = newController.text.trim();
  final confirmPassword = confirmController.text.trim();

  setState(() {
    currentError = null;
    newError = null;
    confirmError = null;
  });

  bool hasError = false;

  if (currentPassword.isEmpty) {
    currentError = "Current password is required";
    hasError = true;
  }

  if (newPassword.isEmpty) {
    newError = "New password is required";
    hasError = true;
  } else if (newPassword.length < 6) {
    newError = "Password must be at least 6 characters";
    hasError = true;
  }

  if (confirmPassword.isEmpty) {
    confirmError = "Confirm password is required";
    hasError = true;
  } else if (newPassword != confirmPassword) {
    confirmError = "Passwords do not match";
    hasError = true;
  }

  if (hasError) {
    setState(() {});
    return;
  }

  if (user == null || user.email == null) return;

  setState(() {
    isLoading = true;
  });

  try {
    // Re-authenticate
    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(cred);

    // Update password
    await user.updatePassword(newPassword);
    await user.reload();

    setState(() {
      currentController.clear();
      newController.clear();
      confirmController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Password updated successfully 🎉"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } on FirebaseAuthException catch (e) {
    setState(() {
      if (e.code == 'wrong-password') {
        currentError = "Please enter your correct current password"; // <-- Changed
      } else if (e.code == 'requires-recent-login') {
        currentError = "Please re-login and try again";
      } else {
        currentError = e.message ?? "Failed to update password";
      }
    });
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFad0023), Color(0xFF6e0212)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.25),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_reset, color: Colors.white, size: 40),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Update your password\nKeep your account secure",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Form card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Current password
                      TextField(
                        controller: currentController,
                        obscureText: !showCurrent,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          errorText: currentError,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(showCurrent
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                setState(() => showCurrent = !showCurrent),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primary, width: 1.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // New password
                      TextField(
                        controller: newController,
                        obscureText: !showNew,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          errorText: newError,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(showNew
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setState(() => showNew = !showNew),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primary, width: 1.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Confirm password
                      TextField(
                        controller: confirmController,
                        obscureText: !showConfirm,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          errorText: confirmError,
                          prefixIcon: const Icon(Icons.check_circle_outline),
                          suffixIcon: IconButton(
                            icon: Icon(showConfirm
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                setState(() => showConfirm = !showConfirm),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primary, width: 1.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                // Update button
                GestureDetector(
                  onTap: _changePassword,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFad0023), Color(0xFF6e0212)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.25),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save_outlined, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Update Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
