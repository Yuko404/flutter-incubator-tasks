// Для _uuidv4Format и _nameFormat не указываем тип данных,
// потому что он избыточный. У нас чётко используется конструктор класса
// RegExp, что, согласно Effective Dart, позволяет и рекомендует
// не указывать чётко тип данных в таких случаях.

/// Представляет имя пользователя.
///
/// Гарантирует, что имя содержит от 3 до 32 символов и состоит только из
/// букв латинского алфавита.
///
/// Создание экземпляра с некорректным форматом вызовет [FormatException].
class UserName {
  /// Регулярное выражение для проверки формата имении
  ///
  /// Доступны только буквы латинского алфавит.
  static final _nameFormat = RegExp(r'^[a-z]+$', caseSensitive: false);

  final String value;

  UserName(this.value) {
    if (value.length < 4 || value.length > 32) {
      throw FormatException('Name should be always 4 - 32 characters long!');
    }
    if (!_nameFormat.hasMatch(value)) {
      throw FormatException('Name should contain only alphabetical letters.');
    }
  }
}

/// Представляет уникальный идентификатор пользователя, соответствующий
/// формату UUIDv4.
///
/// Создание экземпляра с некорректным форматом вызовет [FormatException].
class UserId {
  /// Регулярное выражение для проверки UUIDv4 формата.
  static final _uuidv4Format = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  );

  final String value;

  UserId(this.value) {
    if (value.length != 36) {
      throw FormatException('ID must be 36 character long!');
    }
    if (!_uuidv4Format.hasMatch(value)) {
      throw FormatException('ID must be in UUIDv4 format!');
    }
  }
}

/// Представляет биографию пользователя.
///
/// Гарантирует, что биография не превышает 255 символов.
///
/// Создание экземпляра с некорректным форматом вызовет [FormatException].
class UserBio {
  final String value;

  UserBio(this.value) {
    if (value.length > 255) {
      throw FormatException('Biography must be no longer than 255 characters');
    }
  }
}

/// Представляет неизменяемый объект пользователя
///
/// Содержит обязательный [id] и опциональные [name] и [bio].
class User {
  /// Создаёт экземпляр пользователя
  ///
  /// [name] и [bio] являются необязательными параметрами.
  const User({required this.id, this.name, this.bio});

  /// Уникальный идентификатор пользователя
  final UserId id;

  /// Имя пользователя, может быть null
  final UserName? name;

  /// Биография пользователя, может быть null
  final UserBio? bio;
}

/// Класс, имитирующий взаимодействие с бэкендом
///
/// Имеет операции get и put для объекта [User].
class Backend {
  /// Асинхронно получает [User] по [id]
  Future<User> getUser(UserId id) async => User(id: id);

  /// Асинхронно обновляет информацию о [User] или создаёт нового [User]
  Future<void> putUser(UserId id, {UserName? name, UserBio? bio}) async {}
}

/// Интерфейс для работы с пользователями, использующий низкоуровневый [Backend]
///
/// Абстрагирует детали взаимодействия с бэкендом и предоставляет
/// методы для получения и обновления информации о пользователях.
class UserService {
  /// Создаёт экземпляр [UserService] с указанным [backend]
  UserService(this.backend);

  /// Низкоуровневый бэкенд для операций с пользователями
  final Backend backend;

  /// Получает [User] по его [id]
  Future<User> get(UserId id) async {
    // Используется, чтобы избежать ошибки при указании типа функции.
    // Указание типа избыточно, так как он выводится
    // из `backend.getUser(id)`.
    return backend.getUser(id);
  }

  /// Обновляет информацию о [user] или создаёт нового пользователя
  Future<void> update(User user) async {}
}

void main() {}
