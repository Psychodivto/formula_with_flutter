import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:formula/models/predictions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final url = Uri.parse(
      "https://linear-model-service-psychodivto.cloud.okteto.net/v1/models/linear-model:predict");
  final headers = {"Content-Type": "application/json"};
  late Future<Predictions> predictions;
  final value_to_predict = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formula Prediccion'),
        flexibleSpace: Image(
          image: AssetImage('assets/logos/perfil2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ingresa un número'),
            TextField(
              controller: value_to_predict,
              decoration: const InputDecoration(hintText: "ingresar valor"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Calcular'),
              onPressed: () {
                sendPrediction();
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    ); // Scaffold
  }

  void showform() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Ingresa el valor a predecin"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: value_to_predict,
                  decoration: const InputDecoration(hintText: "Valor parecido"),
                ), //TextField
              ],
            ), // Colum
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop;
                  },
                  child: const Text("Cancelar")), //TextButton
              TextButton(
                onPressed: () {
                  sendPrediction();
                  Navigator.of(context).pop();
                },
                child: const Text("Prediccion"),
              ) // TextButton
            ],
          ); // AlertDialog
        });
  }

  void sendPrediction() async {
    var value = double.parse(value_to_predict.text);
    List<double> list_predictions = [];
    list_predictions.add(value);
    final prediction_instace = {
      "instances": [list_predictions]
    };

    final res = await http.post(url,
        headers: headers, body: jsonEncode(prediction_instace));
    print(jsonEncode(prediction_instace));
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      print(json);

      final Predictions predictions = Predictions.fromJson(json);

      print(predictions.predictions);

      var result = predictions.predictions;
      showResult(result);
    }
    // return Future.error('No fue posible enviar La prediccion');
  }

  void showResult(result) {
    print("Resultado alerta $result");
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Result: $result"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Salida"),
              ), // TextButton
            ],
          ); // AlertDialog
        });
  }
}
