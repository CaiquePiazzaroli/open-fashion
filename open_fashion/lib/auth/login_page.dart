import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:open_fashion/auth/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 40),
              child: Text(
                "Open Fashion Login",
                style: TextStyle(
                  fontSize: 26
                ), 
              ),
            ),
            LoginForm(), 
            RegisterButton()
          ],
        ),
      ),
    );
  }
}

// Define a custom Form widget.
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  //Serve para validar o formulário
  final _formKey = GlobalKey<FormState>();

  //Controladores para pegar o input do formulário
  final emailAddressController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Input de endereço de email
          TextFormField(
            controller: emailAddressController,
            obscureText: false,
            decoration: const InputDecoration(
              // icon: Icon(Icons.email),
              hintText: 'Insira seu email',
              labelText: 'Email *',
            ),
            validator: (String? value) {
              return (value == null || value == '' || !value.contains('@'))
                  ? 'Por favor, insira um email válido'
                  : null;
            },
          ),

          //Input de senha
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              // icon: Icon(Icons.password),
              hintText: 'Insira sua senha',
              labelText: 'Senha *',
            ),
            validator: (String? value) {
              return (value == null || value == '')
                  ? 'Por favor, insira sua senha'
                  : null;
            },
          ),

          //Botão de confirmação
          Container(
            margin: EdgeInsets.only(top: 20),
            child: ElevatedButton(
              child: const Text('Logar-se', style: TextStyle(fontWeight: FontWeight.w500),),
              onPressed: () async {
                // É uma validação do proprio flutter, definido em cada input text
                //por exemplo: campo de email ->> deve conter @ como: caique@email.com
                if (_formKey.currentState!.validate()) {
                  //Aqui é onde efetivamente os dados preenchidos no form são passados
                  //para o firebase verificar as credenciais
                  //Se sim, um novo evento é disparado indicando que o usuário está logado
                  //Um exemplo de função que capta status: authStateChanges()
                  try {
                    // ignore: unused_local_variable
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                          email: emailAddressController.text,
                          password: passwordController.text,
                        );
            
                    print(credential);
                  } on FirebaseAuthException catch (e) {
                    String message = '';
                    if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code =="invalid-credential") {
                      message = 'Email ou senha incorretos. Por favor, verifique seus dados.';
                    } else if (e.code == 'invalid-email') {
                      message = 'O formato do email é inválido.';
                    } else {
                      message = 'Ocorreu um erro. Tente novamente.';
                    }
            
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterPage()
              )
            );
          },
        child: Text("Não possui uma conta? Cadastre-se", 
        style: TextStyle(
          color: Colors.orange,
          fontSize: 14,
          decoration: TextDecoration.underline,
          decorationColor: Colors.orange,
        ),)
      ),
    );
  }

}