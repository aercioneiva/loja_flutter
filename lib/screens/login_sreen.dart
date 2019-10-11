import 'package:flutter/material.dart';
import 'package:loja_app/models/user_model.dart';
import 'package:loja_app/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScrenn extends StatefulWidget {
  @override
  _LoginScrennState createState() => _LoginScrennState();
}

class _LoginScrennState extends State<LoginScrenn> {
  final _formKey = GlobalKey<FormState>();
  final _scaffold = GlobalKey<ScaffoldState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            child: Text(
              "CRIAR CONTA",
              style: TextStyle(fontSize: 15),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignUpScrenn()));
            },
          ),
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: "E-mail"),
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@")) {
                        return "E-mail inválido!";
                      }
                    }),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Senha"),
                    validator: (text) {
                      if (text.isEmpty || text.length < 6) {
                        return "Senha inválida!";
                      }
                    }),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      "Esqueci minha senha",
                      textAlign: TextAlign.right,
                    ),
                    onPressed: () {
                      if (_email.text.isEmpty) {
                        _scaffold.currentState.showSnackBar(SnackBar(
                          content: Text("Insira seu e-mail pra recuperação!"),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.redAccent,
                        ));
                        return;
                      }
                      model.recoverPass(_email.text);
                      _scaffold.currentState.showSnackBar(SnackBar(
                          content: Text("confira seu email!"),
                          duration: Duration(seconds: 3),
                          backgroundColor: Theme.of(context).primaryColor,
                        ));
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(fontSize: 18),
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        model.signIn(
                            email: _email.text,
                            password: _password.text,
                            onSuccess: _onSuccess,
                            onFaile: _onFaile);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFaile() {
    _scaffold.currentState.showSnackBar(SnackBar(
      content: Text("Erro ao efetuar login!"),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.redAccent,
    ));
  }
}
