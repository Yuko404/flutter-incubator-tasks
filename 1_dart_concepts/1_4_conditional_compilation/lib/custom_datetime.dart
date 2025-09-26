export 'src/native_datetime.dart' // dart:io implementation
    if (dart.library.html) 'src/web_datetime.dart'; // dart:html implementation
