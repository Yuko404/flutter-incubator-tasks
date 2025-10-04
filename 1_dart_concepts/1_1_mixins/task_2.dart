extension on String {
  List<String> parseLinks() {
    // Задаём структуры ссылки
    final RegExp exp = RegExp(
      r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.#&:]+',
    );
    final Iterable<RegExpMatch> matches = exp.allMatches(this);
    final List<String> result = [];
    int cursor = 0;

    // Определяем функцию для добавления в список с проверкой на пустоту
    void addPart(String type, int startOfPart, int endOfPart) {
      final String part = substring(startOfPart, endOfPart);
      if (part.isEmpty) {
        return;
      }

      // Проверяем правильность ссылки через [Uri.tryParse]
      if (type == 'Link') {
        final Uri? parsingUrl = Uri.tryParse(part);
        if (parsingUrl == null) {
          type = 'Text';
        }
      }
      result.add('$type(\'$part\')');
    }

    // Добавляем части текста последовательно, используя курсор
    // для отслеживания позиции
    for (final RegExpMatch match in matches) {
      addPart('Text', cursor, match.start);
      cursor = match.end;
      if (this[cursor - 1] == '.') {
        cursor--;
      }
      addPart('Link', match.start, cursor);
    }

    // Не забываем добавить оставшуюся часть текста
    addPart('Text', cursor, length);
    return result;
  }
}

void main() {
  final String text =
      """Hello, google.com, yay! Давай встретимся на https://dart.dev или http://flutter.dev.
      А может получится и тут - gapopa.com! А ещё давай глянем https://www.youtube.com/watch?v=dQw4w9WgXcQ.""";
  final List<String> result = text.parseLinks();
  print(result);
}
