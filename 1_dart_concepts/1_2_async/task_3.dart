import 'dart:async';
import 'dart:convert';
import 'dart:io';

const String _serverIp = 'localhost';
const int _serverPort = 8080;

// Определяем HTML-код главной страницы
const String mainPageTextInHTML = """
      <h2>This is the main page!</h2>
      <p>You can go to the <strong style="background-color: #98fb98; padding: 0 5px; color: #fff;" data-darkreader-inline-bgcolor="" data-darkreader-inline-color="">/write</strong> to write information from your request to a file on the server.</p>
      <p>Also, you can go to the <strong style="background-color: #ff0000; padding: 0 5px; color: #fff;" data-darkreader-inline-bgcolor="" data-darkreader-inline-color="">/read</strong> to get information from a file on the server.</p>""";
final File dummyFile = File('bin/1_2/dummy.txt');

// Обрабатываем запросы
Future<void> processingResponse(HttpRequest request) async {
  final HttpResponse response = request.response;
  int statusCode = response.statusCode;
  String serverAnswer;
  response.headers.contentType = ContentType.text;
  // Проверяем пусть запроса и вызываем соответствующую функцию
  switch (request.uri.path) {
    case "/write":
      {
        try {
          serverAnswer = await writePage(request);
          statusCode = HttpStatus.ok;
        } on EmptyRequestException {
          serverAnswer = "Fail. Data is empty.";
          statusCode = HttpStatus.badRequest;
        }
        break;
      }
    case '/read':
      {
        try {
          serverAnswer = await readPage();
          statusCode = HttpStatus.ok;
        } on FileNotExistsException {
          serverAnswer =
              "Error, file \"dummy.txt\" doesn't exist.\nSorry about that.";
          statusCode = HttpStatus.internalServerError;
        }
        break;
      }
    default:
      {
        if (request.uri.path != '/') {
          serverAnswer = "Error 404. Page not found.";
          statusCode = HttpStatus.notFound;
        } else {
          // Изменяем [contentType] на HTML
          response.headers.contentType = ContentType.html;
          serverAnswer = mainPageTextInHTML;
          statusCode = HttpStatus.ok;
        }
      }
  }
  response.statusCode = statusCode;
  response.write(serverAnswer);
  response.close();
}

Future<String> readPage() async {
  if (await dummyFile.exists()) {
    final content = await dummyFile.readAsString();
    return content;
  } else {
    throw FileNotExistsException();
  }
}

Future<String> writePage(HttpRequest request) async {
  // Читаем данные из запроса
  final String textOfRequest = await utf8.decodeStream(request);
  if (textOfRequest.isEmpty) {
    throw EmptyRequestException();
  } else {
    await dummyFile.writeAsString(textOfRequest);
    return 'Success! Data is writen';
  }
}

class FileNotExistsException implements Exception {}

class EmptyRequestException implements Exception {}

void main() async {
  final HttpServer server = await HttpServer.bind(_serverIp, _serverPort);
  server.listen(processingResponse);
}
