import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class SQLModel {
  static Future<void> criaTabelas(sql.Database database) async {
    await database.execute("""CREATE TABLE clientes(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nome TEXT,
      email TEXT, 
      dataNascimento TEXT,
      telefone TEXT,
      criado TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> db() async {
  final dbPath = await sql.getDatabasesPath();
  final path = join(dbPath, 'clientes.db');

  // Exclui o banco de dados existente
  //await sql.deleteDatabase(path);

  return sql.openDatabase(
    path,
    version: 1,
    onCreate: (sql.Database database, int version) async {
      await criaTabelas(database);
    },
  );
}


  static Future<int> criarClientes(
      String nome, String email, String dataNascimento, String telefone) async {
    final db = await SQLModel.db();

    final dados = {
      'nome': nome,
      'email': email,
      'dataNascimento': dataNascimento,
      'telefone': telefone
    };
    final id = await db.insert('clientes', dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getClientes() async {
    final db = await SQLModel.db();
    return db.query('clientes', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getCliente(int id) async {
    final db = await SQLModel.db();
    return db.query('clientes', where: "id =?", whereArgs: [id], limit: 1);
  }

  static Future<int> atualizarCliente(int id, String nome, String email,
      String dataNascimento, String telefone) async {
    final db = await SQLModel.db();

    final dados = {
      'nome': nome,
      'email': email,
      'dataNascimento': dataNascimento,
      'telefone': telefone,
      'criado': DateTime.now().toString()
    };

    final resultado =
        await db.update('clientes', dados, where: "id=?", whereArgs: [id]);
    return resultado;
  }

  static Future<void> deletarCliente(int id) async {
    final db = await SQLModel.db();
    try {
      await db.delete("clientes", where: "id =?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro: $err");
    }
  }
}
