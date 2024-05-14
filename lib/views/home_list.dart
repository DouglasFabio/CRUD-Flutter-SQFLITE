import 'package:flutter/material.dart';
import 'package:flutter_crud_sqlite/models/db.dart';

class HomeListScreen extends StatefulWidget {
  const HomeListScreen({Key? key}) : super(key: key);

  @override
  _HomeListScreenState createState() => _HomeListScreenState();
}

class _HomeListScreenState extends State<HomeListScreen> {
  List<Map<String, dynamic>> _clientes = [];

  bool _isLoading = true;
  void _refreshClientes() async {
    final data = await SQLModel.getClientes();
    setState(() {
      _clientes = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshClientes();
  }

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dataNascController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create
      // id != null -> update
      final clienteExistente =
          _clientes.firstWhere((element) => element['id'] == id);
      _nomeController.text = clienteExistente['nome'];
      _emailController.text = clienteExistente['email'];
      _dataNascController.text = clienteExistente['dataNascimento'];
      _telefoneController.text = clienteExistente['telefone'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _nomeController,
                    decoration: const InputDecoration(hintText: 'Nome'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _dataNascController,
                    decoration:
                        const InputDecoration(hintText: 'Data de Nascimento'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _telefoneController,
                    decoration: const InputDecoration(hintText: 'Telefone'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text(id == null ? 'Cadastrar' : 'Atualizar'),
                    onPressed: () async {
                      // Verifica se os campos estão vazios
                      if (_nomeController.text.isEmpty ||
                          _emailController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Erro"),
                              content: const Text(
                                  "Por favor, preencha pelo menos NOME e EMAIL."),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        if (id == null) {
                          await _addItem();
                        }

                        if (id != null) {
                          await _updateItem(id);
                        }

                        _nomeController.text = '';
                        _emailController.text = '';
                        _dataNascController.text = '';
                        _telefoneController.text = '';

                        // Fecha o modal
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              ),
            ));
  }

  Future<void> _addItem() async {
    await SQLModel.criarClientes(_nomeController.text, _emailController.text,
        _dataNascController.text, _telefoneController.text);
    _refreshClientes();
  }

  Future<void> _updateItem(int id) async {
    await SQLModel.atualizarCliente(
        id,
        _nomeController.text,
        _emailController.text,
        _dataNascController.text,
        _telefoneController.text);
    _refreshClientes();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLModel.deletarCliente(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Cliente deletado com sucesso!'),
    ));
    _refreshClientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD - CLIENTES'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _clientes.length,
              itemBuilder: (context, index) => Card(
                color: Colors.blue[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                    title: Row(
                      children: <Widget>[
                        Text('Nome: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_clientes[index]['nome']),
                      ],
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Text('Email: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_clientes[index]['email']),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Color.fromARGB(255, 247, 248, 248)),
                            onPressed: () => _showForm(_clientes[index]['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirmação"),
                                    content: const Text(
                                        "Tem certeza de que deseja excluir este cliente?"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("Cancelar"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("Excluir"),
                                        onPressed: () {
                                          _deleteItem(_clientes[index]['id']);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
