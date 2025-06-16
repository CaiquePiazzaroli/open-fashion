import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de usuário")),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                "Registrar uma nova conta", 
                    style: TextStyle(
                    fontSize: 26
                  ),
              ),
            ),
            RegistrationForm()
          ],
        ),
      ),
    );
  }
}

// Define a custom Form widget.
class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  RegistrationFormState createState() {
    return RegistrationFormState();
  }
}

class RegistrationFormState extends State<RegistrationForm> {
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
              hintText: 'Cadastrar um novo email',
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
              hintText: 'Cadastrar uma nova senha',
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
              child: const Text('Criar conta'),
              onPressed: () async {
                // É uma validação do proprio flutter, definido em cada input text
                //por exemplo: campo de email ->> deve conter @ como: caique@email.com
                if (_formKey.currentState!.validate()) {
                  
                  //Cria um usuário
                  try {
                    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailAddressController.text,
                          password: passwordController.text,
                        );
                  } on FirebaseAuthException catch (e) {
            
                    //Trata os erros de input
                    String message = '';
                    if (e.code == 'weak-password') {
                      message = 'O a senha fornecida é muito fraca. Esolha outra senha.';
                    } else if (e.code == 'email-already-in-use') {
                      message = 'Essa conta de email ja possui um cadastro!';
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
