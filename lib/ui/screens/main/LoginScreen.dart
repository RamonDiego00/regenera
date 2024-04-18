import 'package:flutter/material.dart';

import '../../../core/repository/UserRepository.dart';
import '../../../services/authenticationService.dart';
import '../../../utils/NetworkSnackbar.dart';
import '../../../viewmodel/UserViewModel.dart';
import 'RegisterScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late UserRepository userRepository;
  late UserViewModel userViewModel;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  AuthenticationService authenticationService = AuthenticationService();

  @override
  void initState() {
    super.initState();

    userRepository = UserRepository();
    userViewModel = UserViewModel(userRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    SizedBox(
                      // Limitando a largura da coluna interna
                      width: 200.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // Centralização interna
                        children: [
                          Text(
                            "Bem vindo!",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text(
                            "Faça o login para continuar",
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.0),
                    SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            elevation: 10,
                            shadowColor: Color.fromRGBO(127, 202, 69, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: TextField(
                              cursorColor: Color.fromRGBO(127, 202, 69, 1),
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color: Colors.black
                                      .withOpacity(0.5), // HintText translúcido
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(127, 202, 69, 1),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Material(
                            elevation: 10,
                            shadowColor: Color.fromRGBO(127, 202, 69, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: TextField(
                              cursorColor: Color.fromRGBO(127, 202, 69, 1),
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: 'Senha',
                                hintStyle: TextStyle(
                                  color: Colors.black
                                      .withOpacity(0.5), // HintText translúcido
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(127, 202, 69, 1),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            String email = _emailController.text;
                            String password = _passwordController.text;
                            print('Email: $email');
                            print('Password: $password');
                            // salvar user no banco de dados
                            authenticationService
                                .loginUser(password: password, email: email)
                                .then((String? error) {
                              if (error != null) {
                                showSnackBar(context: context, text: error);
                              } else {
                                // deu certo
                                showSnackBar(
                                    context: context,
                                    text: "Login efetuado com sucesso",
                                    isError: false);
                              }
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(127, 202, 69, 1)),
                            minimumSize: MaterialStateProperty.all(Size(
                                MediaQuery.of(context).size.width * 0.8, 50.0)),
                            textStyle: MaterialStateProperty.all(
                                TextStyle(fontSize: 16.0)),
                            // Cor de fundo personalizada
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                // Borda arredondada
                                side: BorderSide(
                                    color: Color.fromRGBO(
                                        127, 202, 69, 1)), // Cor da borda
                              ),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // Icon(Icons.login),
                              // Ícone ao lado do texto
                              SizedBox(width: 8.0),
                              // Espaçamento entre o ícone e o texto
                              Text(
                                'Logar',
                                selectionColor: Color.fromRGBO(127, 202, 69, 1),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text('Ou'),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Container(
                                height: 1.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40.0),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            minimumSize: MaterialStateProperty.all(Size(
                                MediaQuery.of(context).size.width *
                                    0.8, // 40% da largura da tela
                                45.0)),
                            textStyle: MaterialStateProperty.all(
                                TextStyle(fontSize: 16.0)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            //Login com google
                            AuthenticationService().signInWithGoogle(context);
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.g_mobiledata,
                                size: 40,
                                color: Color.fromRGBO(127, 202, 69, 1),
                              ),
                              // Ícone ao lado do texto
                              SizedBox(width: 8.0),
                              // Espaçamento entre o ícone e o texto
                              Text(
                                'Continuar com google',
                                selectionColor: Color.fromRGBO(127, 202, 69, 1),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(127, 202, 69, 1)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            minimumSize: MaterialStateProperty.all(Size(
                                MediaQuery.of(context).size.width *
                                    0.8, // 40% da largura da tela
                                45.0)),
                            textStyle: MaterialStateProperty.all(
                                TextStyle(fontSize: 16.0)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            //Login com google

                            AuthenticationService().signInWithGoogle(context);
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.window_outlined,
                                color: Color.fromRGBO(127, 202, 69, 1),
                                size: 30,
                              ),
                              // Ícone ao lado do texto
                              SizedBox(width: 8.0),
                              // Espaçamento entre o ícone e o texto
                              Text(
                                'Continuar com microsoft',
                                selectionColor: Color.fromRGBO(127, 202, 69, 1),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(127, 202, 69, 1)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Já tem uma conta?"),
                            GestureDetector(
                              onTap: () {
                                // Navegar para a próxima tela ao clicar no texto
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()),
                                );
                              },
                              child: Text(
                                ' clique aqui!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(127, 202, 69, 1),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

// vamos mudar para um form para ficar mais performatico e validar
}
