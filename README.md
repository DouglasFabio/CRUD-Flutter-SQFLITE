# CRUD - Flutter c/ SQFlite

## Tela inicial

* Logo após iniciar o aplicativo, você deve realizar uma autenticação local (local_auth)
* Em caso de sucesso, você é redirecionado para a página de listagem de clientes
* Caso você erre a senha, você será informado e terá que repetir novamente.
* Caso cancele a autenticação, você volta para a tela inicial com um alerta de que a autenticação falhou (elegant_notification)

## Tela principal

* Possui uma lista em formato de cards com as informações de Nome e Email destacadas.
* Realiza a manutenção (edição e exclusão do cliente) utilizando serviços criados em models/db.dart (sqflite)
* FloatingActionButton (botão flutuante) que insere um novo registro e abre um Modal solicitando Nome, Email, Data Nascimento e Telefone.
* Ao cadastrar um novo cliente, a lista é automaticamente atualizada.
* Ao deletar um cliente, abre um alerta de confirmação para confirmar a exclusão, após a exclusão você é informado através de um SnackBar (notificação nativa)