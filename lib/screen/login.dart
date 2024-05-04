import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tickly/bloc/login/login_cubit.dart';
import 'package:tickly/screen/home_screen.dart';
import '../utils/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailEdc = TextEditingController();
  final passEdc = TextEditingController();
  bool passInvisible = false;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential).then(
        (value) async => await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Loading..')));
          }
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.msg),
                backgroundColor: Colors.red,
              ));
          }
          if (state is LoginSuccess) {
            // context.read<AuthCubit>().loggedIn();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.msg),
                backgroundColor: Colors.green,
              ));
            Navigator.pushNamedAndRemoveUntil(context, rHome, (route) => false);
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: ListView(
            children: [
              const SizedBox(
                height: 60,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Masuk",
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3D3F40)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Silahkan masuk terlebih dahulu",
                    style: TextStyle(fontSize: 16, color: Color(0xff3D3F40)),
                  ),
                ],
              ),
              const SizedBox(
                height: 90,
              ),
              TextFormField(
                  controller: emailEdc,
                  style:
                      const TextStyle(fontSize: 14.0, color: Color(0xff3D3F40)),
                  decoration: InputDecoration(
                      labelText: "Alamat email",
                      labelStyle: const TextStyle(
                        fontSize: 14.0,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      floatingLabelStyle: const TextStyle(fontSize: 16.0),
                      prefixIcon: const Icon(Icons.email))),
              const SizedBox(
                height: 27,
              ),
              TextFormField(
                controller: passEdc,
                style:
                    const TextStyle(fontSize: 14.0, color: Color(0xff3D3F40)),
                decoration: InputDecoration(
                  labelText: "Kata sandi",
                  labelStyle: const TextStyle(
                    fontSize: 14.0,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  floatingLabelStyle: const TextStyle(fontSize: 16.0),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(passInvisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        passInvisible = !passInvisible;
                      });
                    },
                  ),
                ),
                obscureText: !passInvisible,
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    context
                        .read<LoginCubit>()
                        .login(email: emailEdc.text, password: passEdc.text);
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(330, 50),
                      backgroundColor: const Color(0xff5780F6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: const Text(
                    "Masuk",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.white),
                  )),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: Colors.black, // Warna garis
                      thickness: 0.5, // Ketebalan garis
                      height: 20, // Tinggi garis
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Masuk dengan",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff3D3F40)),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black, // Warna garis
                      thickness: 0.5, // Ketebalan garis
                      height: 30, // Tinggi garis
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 17,
                  ),
                  GestureDetector(
                    onTap: () {
                      signInWithGoogle();
                    },
                    child: const CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(
                          'https://cdna.artstation.com/p/assets/images/images/067/985/826/large/kartik-saini-google.jpg?1696706988'),
                    ),
                  ),
                  const SizedBox(
                    width: 30.0,
                  ),
                ],
              ),
              const SizedBox(
                height: 17,
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, //Menengahkan elemen horizontal
                children: [
                  const Text(
                    "Belum punya akun?",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff3D3F40)),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        "Daftar",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff5780F6)),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
