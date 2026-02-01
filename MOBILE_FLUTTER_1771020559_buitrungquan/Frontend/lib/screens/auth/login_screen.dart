import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../constants/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLogin = true;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    bool success;

    if (_isLogin) {
      success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      success = await authProvider.register(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );
    }

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Đã xảy ra lỗi'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      _buildHeader(),
                      const SizedBox(height: 40),
                      _buildForm(),
                      const SizedBox(height: 24),
                      _buildToggleButton(),
                      const SizedBox(height: 24),
                      _buildDemoAccounts(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00F0FF), // Neon Cyan
                const Color(0xFFFF006E), // Neon Pink
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00F0FF).withOpacity(0.6),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
              BoxShadow(
                color: const Color(0xFFFF006E).withOpacity(0.4),
                blurRadius: 30,
                offset: const Offset(10, 10),
              ),
            ],
          ),
          child: Center(
            child: Text(
              PickleballConstants.pickleballRacketIcon,
              style: const TextStyle(fontSize: 60),
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Main Title
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              const Color(0xFF00F0FF), // Cyan
              const Color(0xFFFF006E), // Pink
            ],
          ).createShader(bounds),
          child: Text(
            'VỢT THỦ PHỐ NÚI',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 3,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Decorative Line
        Container(
          height: 4,
          width: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00F0FF),
                const Color(0xFFFF006E),
              ],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        // Subtitle
        Text(
          'Pickleball Club Management',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return GlassCard(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      PickleballColors.primary,
                      PickleballColors.secondary,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    _isLogin ? '🏓 ĐĂNG NHẬP' : '📝 ĐĂNG KÝ',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                Divider(
                  color: PickleballColors.primary.withOpacity(0.3),
                  thickness: 2,
                ),
                const SizedBox(height: 24),                if (!_isLogin) ...[
                  CustomTextField(
                    label: 'Họ và tên',
                    hint: 'Nhập họ và tên',
                    controller: _nameController,
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập họ tên';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                CustomTextField(
                  label: 'Email',
                  hint: 'Nhập email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    if (!value.contains('@')) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Mật khẩu',
                  hint: 'Nhập mật khẩu',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu tối thiểu 6 ký tự';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                PrimaryButton(
                  text: _isLogin ? 'Đăng nhập' : 'Đăng ký',
                  isLoading: auth.isLoading,
                  onPressed: _submit,
                  icon: _isLogin ? Icons.login : Icons.person_add,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLogin ? 'Chưa có tài khoản?' : 'Đã có tài khoản?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isLogin = !_isLogin;
            });
          },
          child: Text(
            _isLogin ? 'Đăng ký ngay' : 'Đăng nhập',
            style: TextStyle(
              color: ThemeProvider.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDemoAccounts() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: ThemeProvider.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Tài khoản Demo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAccountTile(
            'Admin',
            'admin@pcm.com',
            'Admin@123',
            Icons.admin_panel_settings,
            Colors.purple,
          ),
          const SizedBox(height: 8),
          _buildAccountTile(
            'Thành viên',
            'member1@pcm.com',
            'Member@123',
            Icons.person,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTile(
    String role,
    String email,
    String password,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          _emailController.text = email;
          _passwordController.text = password;
          _isLogin = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã điền tài khoản $role'),
            backgroundColor: color,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  ),
                  Text(
                    '$email / $password',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.touch_app, color: color.withOpacity(0.5), size: 20),
          ],
        ),
      ),
    );
  }
}
