import 'package:http/http.dart' as http;

const String postUrl = "http://186.154.241.203:84/api/POSTvalidarIngreso";
const String fileUrl = "http://186.154.241.203:84/api/POSTsubirArchivo";

Future<String> postLogin(String jsonDataUser) async {
  final client = http.Client();
  try {
    var response = await client
        .post(Uri.parse(postUrl),
            headers: {"Content-Type": "application/json"}, body: jsonDataUser)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // throw Exception('Failed to load user');
      return response.statusCode.toString();
    }
  } catch (e) {
    // throw Exception(e);
    client.close();
  } finally {
    client.close();
  }

  return "";
}

Future<void> postFile(String fileString) async {
  try {
    final response = await http.post(
      Uri.parse(fileUrl),
      headers: <String, String>{
        'Content-Type': 'text/plain', // Configura el tipo de contenido
      },
      body: fileString,
    );

    if (response.statusCode == 200) {
      // La solicitud se realizó con éxito
      print('Respuesta: ${response.body}');
    } else {
      // Hubo un error en la solicitud
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
