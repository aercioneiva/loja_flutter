import 'package:flutter/material.dart';
import 'package:loja_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScrenn extends StatefulWidget {
  @override
  _SignUpScrennState createState() => _SignUpScrennState();
}

class _SignUpScrennState extends State<SignUpScrenn> {
  final _form = GlobalKey<FormState>();
  final _scaffold =  GlobalKey<ScaffoldState>();

  TextEditingController _password = TextEditingController();
  Map<String,dynamic> user = Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _form,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nome Completo",
                  ),
                  validator: (text) {
                    if (text.isEmpty) {
                      return "Nome inválido!";
                    }
                  },
                  onChanged: (value){
                    user['name'] = value;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: "E-mail"),
                  validator: (text) {
                    if (text.isEmpty || !text.contains("@")) {
                      return "E-mail inválido!";
                    }
                  },
                  onChanged: (value){
                    user['email'] = value;
                  },
                ),
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
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: "Endereço"),
                  validator: (text) {
                    if (text.isEmpty) {
                      return "Endereço inválido!";
                    }
                  },
                  onChanged: (value){
                    user['address'] = value;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    child: Text(
                      "Crirar Conta",
                      style: TextStyle(fontSize: 18),
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_form.currentState.validate()) {
                        model.signUp(
                          password: _password.text,
                          userData: user,
                          onSuccess: _onSuccess,
                          onFaile: _onFaile
                        );
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

  void _onSuccess(){
    _scaffold.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      duration: Duration(seconds: 2),
      backgroundColor: Theme.of(context).primaryColor,
    ));

    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }

  void _onFaile(){
    _scaffold.currentState.showSnackBar(SnackBar(
      content: Text("Erro ao criar usuário!"),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.redAccent,
    ));
  }
}
