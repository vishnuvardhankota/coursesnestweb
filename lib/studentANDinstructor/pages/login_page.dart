import 'package:coursesnest/utils/paths.dart';

enum PageState { signin, signup, resetPWD }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool obscureText = true;
  PageState pageState = PageState.signin;
  String? errorMessage;
  String loadingMessage = "Signing";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  Widget logoWidget() {
    return Image.asset(dotenv.env['ORGANIZATION_LOGO']!, height: 80);
  }

  Widget title(String text) {
    return Text(
      text,
      style: context.titleMedium.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget userNameWidget() {
    return TextFormField(
      controller: _userNameController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: "User Name",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter your Name";
        } else if (value.trim().isNotEmpty && value.trim().length > 20) {
          return "Max character length is 20";
        }
        return null;
      },
    );
  }

  Widget emailTextField() {
    return TextFormField(
      controller: _emailController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.email),
        labelText: "Email",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter your email";
        }
        if (!RegExp(r"^[a-zA-Z0-9._%+-]+@gmail\.com$").hasMatch(value.trim())) {
          return "Enter a valid email ending with @gmail.com";
        }
        return null;
      },
      onChanged: (value) {
        _emailController.value = TextEditingValue(
          text: value.toLowerCase(),
          selection: _emailController.selection,
        );
      },
    );
  }

  Widget pwdWidget() {
    return TextFormField(
      controller: _passwordController,
      obscureText: obscureText,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.password),
        suffixIcon: IconButton(
          tooltip: obscureText ? "Show" : "Hide",
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
          ),
        ),
        labelText: "Password",
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter your password";
        }
        if (value.length < 8 || value.length > 16) {
          return "Password must be 8-16 characters long";
        }
        if (!RegExp(r"^[a-zA-Z0-9@#$]+$").hasMatch(value)) {
          return "Only @, #, and \$ are allowed as symbols";
        }
        return null;
      },
    );
  }

  Widget pwdResetWidget() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // GitHub icon (optional)
          logoWidget(),
          // Title
          title("Reset Password with registered email"),
          const SizedBox(height: 20),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          // Email input
          emailTextField(),
          const SizedBox(height: 15),
          // Sign in button
          ElevatedButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                  loadingMessage = "Sending mail.\nPlease wait...";
                });
                await Provider.of<AuthServiceProvider>(context, listen: false)
                    .sendPasswordResetLink(_emailController.text.trim())
                    .then((status) {
                  if (status == RequestStatus.success) {
                    setState(() {
                      isLoading = false;
                      errorMessage = null;
                      pageState = PageState.signin;
                      _emailController.clear();
                    });
                  } else if (status == RequestStatus.invalidCredential) {
                    setState(() {
                      isLoading = false;
                      errorMessage = "Email is incorrect.";
                    });
                  } else if (status == RequestStatus.networkError) {
                    setState(() {
                      isLoading = false;
                      errorMessage = "Please check internet connection.";
                    });
                  } else if (status == RequestStatus.userExists) {
                    setState(() {
                      isLoading = false;
                      errorMessage = "Something went wrong. Try again later.";
                    });
                  }
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              "Request Password reset Link",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          RichText(
              text: TextSpan(children: [
            const TextSpan(
                text: "I remember password. ",
                style: TextStyle(color: Colors.black)),
            TextSpan(
                text: "Back to Sign-In",
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      errorMessage = null;
                      pageState = PageState.signin;
                    });
                  }),
          ])),
        ],
      ),
    );
  }

  Widget loginWidget() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // GitHub icon (optional)
          logoWidget(),
          // Title
          title("Sign-in to CoursesNest"),
          const SizedBox(height: 20),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          // Email input
          emailTextField(),
          const SizedBox(height: 15),
          // Password input
          pwdWidget(),
          const SizedBox(height: 10),
          // Forgot password link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  errorMessage = null;
                  pageState = PageState.resetPWD;
                  _emailController.clear();
                  _passwordController.clear();
                });
              },
              child: const Text("Forgot password?"),
            ),
          ),
          const SizedBox(height: 20),
          // Sign in button
          ElevatedButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                  loadingMessage = "Signing. Please wait...";
                });
                await Provider.of<AuthServiceProvider>(context, listen: false)
                    .signIn(_emailController.text.trim(),
                        _passwordController.text.trim())
                    .then((status) async {
                  if (status == RequestStatus.success) {
                    await initializeStreams();
                  } else if (status == RequestStatus.invalidCredential) {
                    setState(() {
                      isLoading = false;
                      errorMessage = "Email or Password is incorrect.";
                    });
                  } else if (status == RequestStatus.networkError) {
                    setState(() {
                      isLoading = false;
                      errorMessage = "Please check internet connection.";
                    });
                  } else if (status == RequestStatus.userExists) {
                    setState(() {
                      isLoading = false;
                      errorMessage = "Something went wrong. Try again later.";
                    });
                  }
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              "Sign in",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          RichText(
              text: TextSpan(children: [
            const TextSpan(
                text: "New to CoursesNest? ",
                style: TextStyle(color: Colors.black)),
            TextSpan(
                text: "Create an account",
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      errorMessage = null;
                      pageState = PageState.signup;
                      _emailController.clear();
                      _passwordController.clear();
                    });
                  }),
          ])),
        ],
      ),
    );
  }

  Widget signupWidget() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // GitHub icon (optional)
          logoWidget(),
          // Title
          title("Be a member in CoursesNest"),
          const SizedBox(height: 20),
          // UserName input
          userNameWidget(),
          const SizedBox(height: 15),
          // Password input
          emailTextField(),
          const SizedBox(height: 15),
          // Password input
          pwdWidget(),
          const SizedBox(height: 20),
          // Sign up button
          ElevatedButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                  loadingMessage = "Creating account.\nPlease wait...";
                });
                await Provider.of<AuthServiceProvider>(context, listen: false)
                    .createAccount(
                        _userNameController.text.trim(),
                        _emailController.text.trim(),
                        _passwordController.text.trim())
                    .then((status) async {
                  if (status == RequestStatus.success) {
                    context.go(homePath);
                    await initializeStreams();
                  } else if (status == RequestStatus.userExists) {
                    setState(() {
                      isLoading = false;
                      errorMessage = "Account already exists. Please Sign-in";
                    });
                  } else if (status == RequestStatus.networkError) {
                    setState(() {
                      isLoading = false;
                      errorMessage = "Please check internet connection.";
                    });
                  } else if (status == RequestStatus.userExists) {
                    setState(() {
                      isLoading = false;
                      errorMessage = "Something went wrong. Try again later.";
                    });
                  }
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              "Create an account",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          RichText(
              text: TextSpan(children: [
            const TextSpan(
                text: "Already have an account? ",
                style: TextStyle(color: Colors.black)),
            TextSpan(
                text: "Let's Sign-in",
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      errorMessage = null;
                      pageState = PageState.signin;
                      _emailController.clear();
                      _passwordController.clear();
                      _userNameController.clear();
                    });
                  }),
          ])),
        ],
      ),
    );
  }

  Widget centreWidget() {
    if (pageState == PageState.signin) {
      return loginWidget();
    } else if (pageState == PageState.signup) {
      return signupWidget();
    } else {
      return pwdResetWidget();
    }
  }

  Future<void> initializeStreams() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    var courseProvider =
        Provider.of<InstructorCourseProvider>(context, listen: false);
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var userType =
        FirebaseAuth.instance.currentUser!.displayName!.split(",")[1];
    if (userType == dotenv.env['STUDENT_TYPE']!) {
      context.replace(homePath);
      await userProvider.initialize(userId);
    } else if (userType == dotenv.env['INSTRUCTOR_TYPE']!) {
      context.replace(dashboardPath);
      await userProvider.initialize(userId);
      await courseProvider.initialize(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          var isMobile = constraints.maxWidth <= 600;
          return Stack(
            children: [
              Center(
                child: SizedBox(
                  width: 500,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 10 : 30,
                                vertical: isMobile ? 20 : 40),
                            child: centreWidget()),
                      ),
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: const Color.fromARGB(106, 0, 0, 0),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        width: 260,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 10),
                            Text(loadingMessage,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  ),
                )
            ],
          );
        }),
      ),
    );
  }
}
