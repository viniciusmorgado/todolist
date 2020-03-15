// Importa bibliotecas do projeto.
// Biblioteca que contém o Material design do Google para desenvolvimento de interfaces Android.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Importar método item do nossso diretório de modelos.
import 'models/item.dart';

// Função principal main que invoca a função runApp para iniciar o widget casca de nossa aplicação.
// Arrow Function =>
void main() => runApp(App());

// Widget Stateless que server como casca principal de nossa aplicação onde os demais componentes serão renderizados.
class App extends StatelessWidget {
  @override // Define que a classe acima é derivado de uma superclasse (nesse caso a Stateless), é opcional porém ajuda na legibilidade do código.
  Widget build(BuildContext context) {
    return MaterialApp(
        title:
            'To-do List', // Titulo da aplicação, não é visivel para o usuário.
        theme: ThemeData(
            // Define caracteristicas básicas dos temas da nossa aplicação, como a paleta de cores.
            primaryColor: Colors.redAccent[400],
            primarySwatch: Colors.red,
            toggleableActiveColor: Colors.redAccent[400]),
        debugShowCheckedModeBanner: false,
        home:
            HomePage()); // Invoca o widget HomePage para renderização de nossa página principal sobre o widget casca.
  }
}

// Widget principal da homepage que contém o valor dos items.
class HomePage extends StatefulWidget {
  var items = new List<Item>();

  HomePage() {
    items = [];
  }

  @override
  _HomePageState createState() => _HomePageState();
}

// Responsável pelas interações e alterações de estado dos nossos widgets na tela principal.
class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();

// Método para adicionar novas itens
  void add() {
    if (newTaskCtrl.text.isEmpty) return;
    setState(() {
      widget.items.add(
        Item(title: newTaskCtrl.text, done: false),
      );
      // newTaskCtrl.text = "";
      newTaskCtrl.clear();
      save();
    });
  }

// Método para remover itens
  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');
    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white),
          // Limita o número de carasteres possíveis para cada novo item na lista. (porém deforma texto?)
          maxLength: 35,
          decoration: InputDecoration(
            labelText: "Nova Tarefa:",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
      backgroundColor: Colors.white, // Background color
      body: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (BuildContext ctxt, int index) {
            final item = widget.items[index];
            return Dismissible(
              child: CheckboxListTile(
                title: Text(item.title),
                value: item.done,
                onChanged: (value) {
                  setState(() {
                    item.done = value;
                    save();
                  });
                },
              ),
              key: Key(item.title),
              background: Container(
                color: Colors.red.withOpacity(0.2),
              ),
              onDismissed: (direction) {
                remove(index);
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add_box),
        backgroundColor: Colors.redAccent[400],
      ),
    );
  }
}
