// 🐦 Flutter imports:
// 📦 Package imports:
import 'dart:convert';
import 'dart:html';

import 'package:acnoo_flutter_admin_panel/app/network/connection_manager.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../dev_utils/dev_utils.dart';
import '../../../generated/l10n.dart' as l;
import '../../core/helpers/fuctions/helper_functions.dart';
import '../../core/static/static.dart';
import '../../models/admin/admin.dart';
import '../../models/admin/login_view_model.dart';
import '../../models/error/_error_code.dart';
import '../../providers/admin/_admin_provider.dart';
import '../../services/admin/admin_service.dart';
import '../../utils/constants/http_method.dart';
import '../../utils/constants/server_uri.dart';
import '../../utils/dialog/error_dialog.dart';
import '../../widgets/widgets.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

//로그인 화면 상태를 관리
class _SigninViewState extends State<SigninView> {
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  final AdminService adminService = AdminService();

  Future<void> login(BuildContext context) async {
    LoginViewModel loginViewModel = LoginViewModel(
        email: emailEditingController.text,
        password: passwordEditingController.text
    );
    dartz.Either<ErrorCode, Admin> result = await adminService.login(loginViewModel);
    result.fold(
        (errorCode) => ErrorDialog.showError(context, errorCode),
        (admin){
          final AdminProvider adminProvider = Provider.of<AdminProvider>(context, listen: false);
          adminProvider.setAdmin(admin);
          GoRouter.of(context).go('/dashboard');
        });
  }
  @override
  void dispose(){
    emailEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool rememberMe = false;
    bool showPassword = false;
    bool isLoading = false;

    final lang = l.S.of(context);
    final _theme = Theme.of(context);

    final _screenWidth = MediaQuery.sizeOf(context).width;

    final _desktopView = _screenWidth >= 1200;

    final _ssoButtonStyle = OutlinedButton.styleFrom(
      side: BorderSide(
        color: _theme.colorScheme.outline,
      ),
      foregroundColor: _theme.colorScheme.onTertiary,
      padding: rf.ResponsiveValue<EdgeInsetsGeometry?>(
        context,
        conditionalValues: [
          const rf.Condition.between(
            start: 0,
            end: 576,
            value: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ],
      ).value,
    );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Row(
          children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  minWidth: _desktopView ? (_screenWidth * 0.45) : _screenWidth,
                ),
                decoration: BoxDecoration(
                  color: _theme.colorScheme.primaryContainer,
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Header With Logo
                      const CompanyHeaderWidget(),

                      // Sign in form
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 375),
                          child: Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    lang.signIn,
                                    //'Sign in',
                                    style: _theme.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Text.rich(
                                    TextSpan(
                                      // text: 'Need an account? ',
                                      text: lang.needAnAccount,
                                      children: [
                                        TextSpan(
                                          // text: 'Sign up',
                                          text: lang.signUp,
                                          style: _theme.textTheme.labelLarge
                                              ?.copyWith(
                                            color: _theme.colorScheme.primary,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              context.push(
                                                '/authentication/signup',
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                    style:
                                        _theme.textTheme.labelLarge?.copyWith(
                                      color: _theme.checkboxTheme.side?.color,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // SSO Login Buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: OutlinedButton.icon(
                                          onPressed: () {},
                                          // label: const Text('Use Google'),
                                          label: Text(lang.useGoogle),
                                          icon: getImageType(
                                            AcnooStaticImage.googleIcon,
                                            height: 14,
                                            width: 14,
                                          ),
                                          style: _ssoButtonStyle,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: OutlinedButton.icon(
                                          onPressed: () {},
                                          //label: const Text('Use Apple'),
                                          label: Text(lang.useApple),
                                          icon: getImageType(
                                            AcnooStaticImage.appleIcon,
                                            height: 14,
                                            width: 14,
                                          ),
                                          style: _ssoButtonStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Divider
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          height: 1,
                                          color: _theme.colorScheme.outline,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        lang.or,
                                        //'or',
                                        style: _theme.textTheme.bodyMedium
                                            ?.copyWith(),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Container(
                                          height: 1,
                                          color: _theme.colorScheme.outline,
                                        ),
                                      )
                                    ],
                                  ),

                                  // Email Field
                                  TextFieldLabelWrapper(
                                    //labelText: 'Email',
                                    labelText: lang.email,
                                    inputField: TextFormField(
                                      controller: emailEditingController,
                                      decoration: InputDecoration(
                                        //hintText: 'Enter your email address',
                                        hintText: lang.enterYourEmailAddress,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Password Field
                                  TextFieldLabelWrapper(
                                    //labelText: 'Password',
                                    labelText: lang.password,
                                    inputField: TextFormField(
                                      controller: passwordEditingController,
                                      obscureText: !showPassword,
                                      decoration: InputDecoration(
                                        //hintText: 'Enter your password',
                                        hintText: lang.enterYourPassword,
                                        suffixIcon: IconButton(
                                          onPressed: () => setState(
                                            () => showPassword = !showPassword,
                                          ),
                                          icon: Icon(
                                            showPassword
                                                ? FeatherIcons.eye
                                                : FeatherIcons.eyeOff,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Remember Me / Forgot Password
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Remember Me
                                      Flexible(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              WidgetSpan(
                                                alignment:
                                                    PlaceholderAlignment.middle,
                                                child: SizedBox.square(
                                                  dimension: 16,
                                                  child: Checkbox(
                                                    value: rememberMe,
                                                    onChanged: (value) =>
                                                        setState(
                                                      () => rememberMe = value!,
                                                    ),
                                                    visualDensity:
                                                        const VisualDensity(
                                                      horizontal: -4,
                                                      vertical: -2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const WidgetSpan(
                                                child: SizedBox(width: 6),
                                              ),
                                              TextSpan(
                                                // text: 'Remember Me',
                                                text: lang.rememberMe,
                                                mouseCursor:
                                                    SystemMouseCursors.click,
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () => setState(
                                                            () => rememberMe =
                                                                !rememberMe,
                                                          ),
                                              ),
                                            ],
                                          ),
                                          style: _theme.textTheme.labelLarge
                                              ?.copyWith(
                                            color: _theme
                                                .checkboxTheme.side?.color,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                      // Forgot Password
                                      Text.rich(
                                        TextSpan(
                                          //text: 'Forgot Password?',
                                          text: lang.forgotPassword,
                                          mouseCursor: SystemMouseCursors.click,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () =>
                                                _handleForgotPassword(context),
                                        ),
                                        style: _theme.textTheme.labelLarge
                                            ?.copyWith(
                                          color: _theme.primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Submit Button
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        login(context);
                                      },
                                      // child: const Text('Sign In'),
                                      child: Text(lang.signIn),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Cover Image
            if (_desktopView)
              Container(
                constraints: BoxConstraints(
                  maxWidth: _screenWidth * 0.55,
                  maxHeight: double.maxFinite,
                ),
                decoration: BoxDecoration(
                  color: _theme.colorScheme.tertiaryContainer,
                ),
                child: getImageType(
                  AcnooStaticImage.signInCover,
                  fit: BoxFit.contain,
                  height: double.maxFinite,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleForgotPassword(BuildContext context) async {
    final _result = await showDialog(
      context: context,
      builder: (context) {
        return const ForgotPasswordDialog();
      },
    );
    devLogger(_result.toString());
  }
}

class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lang.forgotPassword,
                  //'Forgot Password?',
                  style: _theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  lang.enterYourEmailWeWillSendYouALinkToResetYourPassword,
                  //'Enter your email, we will send you a link to Reset your password',
                  style: _theme.textTheme.bodyLarge?.copyWith(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFieldLabelWrapper(
                  // labelText: 'Email',
                  labelText: lang.email,
                  inputField: TextFormField(
                    decoration: InputDecoration(
                      //hintText: 'Enter your email address',
                      hintText: lang.enterYourEmailAddress,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {},
                    //child: const Text('Send'),
                    child: Text(lang.send),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
