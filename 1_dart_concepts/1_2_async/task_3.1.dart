import 'dart:convert';
import 'dart:io';

void main() async {
  var client = HttpClient();
  try {
    // создаем запрос
    // HttpClientRequest request = await client.get("localhost", 8080, "/read");
    HttpClientRequest request = await client.put("localhost", 8080, "/write");
    request.write("""
        123sfdgfdfgfhfghgfjfhfdgdfgfjhhdfgsfad fhfdgds ggf
    fdgfj
    fhfdgdsfgdg
     fhfdgdsd
     dhsh
     fhfdgdsgfh

     hgf
     hdf
     sfdgfdfgfhfghgfjfhfdgdfgfjhhdfgsfa
    ghfhjgfhs dvfghgsdhdfga
              """);
    // получаем ответ
    HttpClientResponse response = await request.close();
    // обрабатываем ответ
    final stringData = await response.transform(utf8.decoder).join();
    print(stringData);
    print(response.statusCode);
  } finally {
    client.close();
  }
}
