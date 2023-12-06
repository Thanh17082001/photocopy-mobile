import 'package:flutter/material.dart';
import 'package:photocopy/ui/auth/auth_manager.dart';
import 'package:provider/provider.dart';

import '../cart/cart_manager.dart';
import '../shared/dialog_utils.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  late String mes;
  final ValueNotifier<bool> isLogin = ValueNotifier<bool>(true);
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
    'phoneNumber': '',
    'fullName': ''
  };
  final _isSubmitting = ValueNotifier<bool>(false);
  final _passwordController = TextEditingController();

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _isSubmitting.value = true;
    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await context
            .read<AuthManager>()
            .login(_authData['email']!, _authData['password']!);
        // ignore: use_build_context_synchronously
        if (context.read<AuthManager>().isLogin) {
          setState(() {
            isLogin.value = true;
          });
        } else {
          setState(() {
            isLogin.value = false;
            mes = 'tài khoản hoặc mật khẩu không chính xác';
            _passwordController.text = '';
          });
        }
      } else {
        final sigup = await context.read<AuthManager>().register(
            _authData['email']!,
            _authData['password']!,
            _authData['fullName']!,
            _authData['phoneNumber']!);
        if (sigup) {
          setState(() {
            _authMode = AuthMode.login;
            _passwordController.text = '';
            isLogin.value = true;
          });
        } else {
          setState(() {
            _authMode = AuthMode.signup;
            mes = 'Đăng ký không thành công';
          });
        }
        print(sigup);
        print(_authMode);
      }
    } catch (error) {
      print(error);
    }

    _isSubmitting.value = false;
  }

  // như là để lấy value thẻ input
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: ValueListenableBuilder<bool>(
            valueListenable: isLogin,
            builder: (context, islogin, child) {
              return Column(children: [
                if (!isLogin.value)
                  Text(
                    mes,
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  ),
                const SizedBox(
                  height: 15,
                ),
                if (_authMode == AuthMode.signup) _fullNameField(),
                const SizedBox(
                  height: 15,
                ),
                if (_authMode == AuthMode.signup) _phoneField(),
                const SizedBox(
                  height: 15,
                ),
                _emailField(),
                const SizedBox(
                  height: 15,
                ),
                _passwordField(),
                const SizedBox(
                  height: 15,
                ),
                if (_authMode == AuthMode.signup) _passwordConfirmField(),
                const SizedBox(
                  height: 15,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _isSubmitting,
                  builder: (context, isSubmitting, child) {
                    if (isSubmitting) {
                      return const CircularProgressIndicator();
                    }
                    return _buttonSubmit();
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                _switchButton()
              ]);
            }),
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.circular(12)),
          hintText: 'Nhập email của bạn',
          fillColor: const Color.fromARGB(255, 239, 226, 226),
          filled: true),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Email không hợp lệ';
        }
        return null;
      },
      onSaved: (value) {
        _authData['email'] = value!;
      },
    );
  }

  Widget _passwordConfirmField() {
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.circular(12)),
          hintText: 'Nhập lại mật khẩu',
          fillColor: const Color.fromARGB(255, 239, 226, 226),
          filled: true),
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value != _passwordController.text) {
          return 'Mật khẩu không trùng khớp';
        }
        return null;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.circular(12)),
          hintText: 'Nhập mật khẩu của bạn',
          fillColor: const Color.fromARGB(255, 239, 226, 226),
          filled: true),
      obscureText: true,
      keyboardType: TextInputType.text,
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.length < 5) {
          return 'Mật khẩu quá ngắn';
        }
        return null;
      },
      onSaved: (value) {
        _authData['password'] = value!;
      },
    );
  }

  Widget _phoneField() {
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.circular(12)),
          hintText: 'Nhập số điện thoại của bạn',
          fillColor: const Color.fromARGB(255, 239, 226, 226),
          filled: true),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
          return 'SĐT không hợp lệ';
        }
        return null;
      },
      onSaved: (value) {
        _authData['phoneNumber'] = value!;
      },
    );
  }

  Widget _fullNameField() {
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.circular(12)),
          hintText: 'Nhập tên của bạn',
          fillColor: const Color.fromARGB(255, 239, 226, 226),
          filled: true),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Tên không được bỏ trống';
        }
        return null;
      },
      onSaved: (value) {
        _authData['fullName'] = value!;
      },
    );
  }

  Widget _switchButton() {
    return TextButton(
      onPressed: _switchAuthMode, // viết hàm này ngoài hàm build

      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: const TextStyle(color: Colors.black, fontSize: 18)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_authMode == AuthMode.login
              ? 'Chưa có tài khoản bấm'
              : 'Có tài khoản bấm'),
          const SizedBox(
            width: 10,
          ),
          Text(_authMode == AuthMode.login ? 'Đăng ký' : 'Đăng Nhập'),
        ],
      ),
    );
  }

  Widget _buttonSubmit() {
    return GestureDetector(
      onTap: _submit,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        decoration: BoxDecoration(
            color: Colors.black45, borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        child: Center(
          child: Text(
            _authMode == AuthMode.login ? 'Đăng nhập' : 'Đăng ký',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
