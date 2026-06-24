import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ListaExterna());
}

class ListaExterna extends StatelessWidget {
  const ListaExterna({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Cuerpo(),
    );
  }
}

class Cuerpo extends StatelessWidget {
  const Cuerpo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista externa")),
      body: Column(
        children: [
          Text("Lista de depositos"),
          Container(child: imgPortada()),
          Flexible(child: listaExterna()),
        ],
      ),
    );
  }
}

//leer json externo
Future<List> leer(String url) async {
  final respuesta = await http.get(Uri.parse(url));
  return json.decode(respuesta.body);
}

//lista externa
Widget listaExterna() {
  String url = "https://jritsqmet.github.io/web-api/depositos.json";
  return FutureBuilder(
    future: leer(url),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final data = snapshot.data!;
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return Card(
              color: const Color.fromARGB(255, 26, 141, 70),
              child: ListTile(
                title: Text(item['banco']),
                subtitle: Text(item['monto'].toString()),
                trailing: IconButton(
                  onPressed: () => verMas(context, item),
                  icon: Icon(Icons.more),
                ),
              ),
            );
          },
        );
      } else {
        return CircularProgressIndicator();
      }
    },
  );
}

//modal
void verMas(BuildContext context, Map item) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(item['banco']),
      content: Column(
        children: [
          Image.network(
            item['detalles']['imagen_comprobante'],
            height: 100,
            fit: BoxFit.cover,
          ),
          Text("ID: ${item['id']}"),
          Text("Banco: ${item['banco']}"),
          Text("Monto: ${item['monto']}"),
          Text("Fecha: ${item['fecha']}"),
          Text("Origen: ${item['origen']['nombre']}"),
          Text("Destino: ${item['destino']['nombre']}"),
          Text("Método de pago: ${item['detalles']['método_pago']}"),
          Text("Estado: ${item['detalles']['estado']}"),
        ],
      ),
    ),
  );
}

Widget imgPortada() {
  return Image.asset(
    "assets/image/deposito.png",
    height: 300,
    width: double.infinity,
    fit: BoxFit.cover,
  );
}