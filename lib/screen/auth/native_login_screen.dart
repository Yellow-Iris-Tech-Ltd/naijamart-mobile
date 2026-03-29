import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/constants/endpoints_uri.dart';
import '../dashboard/me_screen.dart';

class NativeLoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const NativeLoginScreen({super.key});
  @override
  State<NativeLoginScreen> createState() => _NativeLoginScreenState();
}

class _NativeLoginScreenState extends State<NativeLoginScreen> {
  // NaijaMart brand colors
  static const Color navyBlue = Color(0xFF001F3F);
  static const Color gold = Color(0xFFC9A24E);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Email/Password login
  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://naijamart.com/api/v1/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final String naijamartToken = data['data']['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('naijamart_token', naijamartToken);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MeDashboardScreen()),
        );
      } else {
        setState(() {
          _errorMessage = data['message'] ?? 'Login failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection error. Please check your internet.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Google Sign-In (existing working code preserved)
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
      _errorMessage = null;
    });
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isGoogleLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final response = await http.post(
        Uri.parse('https://naijamart.com/api/auth/google/mobile'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'id_token': googleAuth.idToken}),
      );
      if (response.statusCode != 200) {
        throw Exception('Sign-in failed. Please try again. (${response.statusCode})');
      }
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String naijamartToken = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('naijamart_token', naijamartToken);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MeDashboardScreen()),
      );
    } catch (e) {
      setState(() {
        _isGoogleLoading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _browseWithoutSignIn() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MeDashboardScreen()),
    );
  }

  void _navigateToForgotPassword() {
    // TODO: Implement forgot password screen or WebView
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening password reset...')),
    );
  }

  void _navigateToRegister() {
    // TODO: Implement register screen or WebView
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening registration...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),

                // Logo
                _buildLogo(),

                const SizedBox(height: 32),

                // Welcome text
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: navyBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Sign in to continue to NaijaMart',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Error message
                if (_errorMessage != null) _buildErrorMessage(),

                // Email field
                _buildEmailField(),

                const SizedBox(height: 14),

                // Password field
                _buildPasswordField(),

                const SizedBox(height: 8),

                // Forgot Password link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _navigateToForgotPassword,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: gold,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Login button
                _buildLoginButton(),

                const SizedBox(height: 24),

                // Divider with "Or continue with"
                _buildDivider(),

                const SizedBox(height: 24),

                // Google Sign-In button
                _buildGoogleButton(),

                const SizedBox(height: 28),

                // Create Account link
                _buildCreateAccountLink(),

                const SizedBox(height: 12),

                // Browse without signing in
                _buildBrowseWithoutSignInLink(),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Image.asset(
          'assets/images/naijamart_logo.png',
          height: 80,
          errorBuilder: (_, __, ___) => Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: navyBlue,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: navyBlue.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'N',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: gold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Naija',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: navyBlue,
                ),
              ),
              TextSpan(
                text: 'Mart',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: gold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Nigeria's No.1 Marketplace",
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700], size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red[700], fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'Enter your email',
        prefixIcon: const Icon(Icons.email_outlined, color: navyBlue, size: 22),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: gold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _signInWithEmail(),
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outline, color: navyBlue, size: 22),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
            size: 22,
          ),
          onPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: gold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _signInWithEmail,
        style: ElevatedButton.styleFrom(
          backgroundColor: navyBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: navyBlue.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'Or continue with',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: _isGoogleLoading ? null : _signInWithGoogle,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[300]!, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
        ),
        child: _isGoogleLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                    height: 22,
                    width: 22,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.g_mobiledata,
                      size: 26,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCreateAccountLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        GestureDetector(
          onTap: _navigateToRegister,
          child: const Text(
            'Create Account',
            style: TextStyle(
              color: gold,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBrowseWithoutSignInLink() {
    return Center(
      child: TextButton(
        onPressed: _browseWithoutSignIn,
        child: const Text(
          'Browse without signing in',
          style: TextStyle(
            color: navyBlue,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}