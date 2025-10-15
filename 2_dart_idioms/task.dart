import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:equatable/equatable.dart';

// Const for Boards naming in database

const String boardsDBName = "boards";
const String boardIdName = 'id';
const String boardNameName = 'name';
const String boardTextIdentName = 'textIdent';
const String boardDescriptionName = 'description';

// Const for Message naming in database

const String msgDBName = "messages";
const String msgIdName = 'id';
const String msgBoardIdName = 'boardId';
const String msgParentMessageIdName = 'parentMessageId';
const String msgAuthorNameName = 'authorName';
const String msgCreatedAtName = 'createdAt';
const String msgTextName = 'text';
const String msgImagePathName = 'imagePath';

class InvalidFormatException implements Exception {
  String? message;

  InvalidFormatException([this.message]);

  @override
  String toString() {
    return "Invalid format exception. $message";
  }
}

class EmptyMessageException implements Exception {
  String? message;

  EmptyMessageException([this.message]);

  @override
  String toString() {
    return "Empty message exception. $message";
  }
}

// Board

class BoardId extends Equatable {
  final int value;

  const BoardId(this.value);

  @override
  String toString() {
    return value.toString();
  }

  @override
  List<Object?> get props => [value];
}

class BoardTextIdent extends Equatable {
  final String value;
  BoardTextIdent(this.value) {
    if (value.isEmpty) {
      throw InvalidFormatException("Empty string can't be a value.");
    }
    if (value.length > 15) {
      throw InvalidFormatException(
        "Length of the value must be less than or equal to 15.",
      );
    }
  }

  @override
  String toString() {
    return value;
  }

  @override
  List<Object?> get props => [value];
}

class BoardName extends Equatable {
  final String value;

  BoardName(this.value);

  @override
  List<Object?> get props => [value];
}

class BoardDescription extends Equatable {
  final String value;

  BoardDescription(this.value) {
    if (value.isEmpty) {
      throw InvalidFormatException("Empty string can't be a value.");
    }
    if (value.length > 255) {
      throw InvalidFormatException(
        "Length of the value must be less than or equal to 255.",
      );
    }
  }
  @override
  String toString() {
    return value;
  }

  @override
  List<Object?> get props => [value];
}

class Board {
  final BoardId id;
  final BoardName name;
  final BoardTextIdent textIdent;
  final BoardDescription description;

  Board(this.id, this.name, this.textIdent, this.description);

  factory Board.fromMap(Map<String, Object?> map) {
    return Board(
      BoardId(map[boardIdName] as int),
      BoardName(map[boardNameName] as String),
      BoardTextIdent(map[boardTextIdentName] as String),
      BoardDescription(map[boardDescriptionName] as String),
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      boardIdName: id.value,
      boardNameName: name.value,
      boardTextIdentName: textIdent.value,
      boardDescriptionName: description.value,
    };
  }

  @override
  String toString() {
    return 'Board($boardIdName: $id, $boardNameName: $name, $boardTextIdentName: $textIdent, $boardDescriptionName: $description)';
  }
}

// Message

class MessageId extends Equatable {
  final int? value;

  const MessageId([this.value]);

  @override
  String toString() {
    return value.toString();
  }

  @override
  List<Object?> get props => [value];
}

class MessageText extends Equatable {
  final String? value;

  const MessageText([this.value]);

  @override
  String toString() {
    return value ?? '';
  }

  @override
  List<Object?> get props => [value];
}

class MessageImage extends Equatable {
  final String value;

  MessageImage(this.value) {
    if (value.isEmpty) {
      throw InvalidFormatException("Empty string can't be a value.");
    }
  }

  @override
  String toString() {
    return value;
  }

  @override
  List<Object?> get props => [value];
}

class MessageAuthor extends Equatable {
  final String value;

  MessageAuthor([String? inValue])
    : value = (inValue == null) ? "Anonymous" : inValue {
    if (inValue != null) {
      if (value.isEmpty) {
        throw InvalidFormatException("Empty string can't be a value.");
      }
      if (value.length < 3 || value.length > 16) {
        throw InvalidFormatException(
          "Length of the value must be more than 3 and less than or equal to 16.",
        );
      }
    }
  }

  @override
  String toString() {
    return value;
  }

  @override
  List<Object?> get props => [value];
}

class MessageCreationTime extends Equatable {
  final DateTime value;

  MessageCreationTime([DateTime? inValue])
    : value = (inValue == null) ? DateTime.now() : inValue;

  @override
  String toString() {
    return value.toString();
  }

  @override
  List<Object?> get props => [value];
}

class Message {
  final MessageId id;
  final BoardId boardId;
  final MessageText? text;
  final MessageImage? imagePath;
  final MessageId? parentMessageId;
  final MessageAuthor authorName;
  final MessageCreationTime createdAt;

  Message(
    this.id,
    this.boardId,
    this.parentMessageId,
    this.authorName,
    this.createdAt, {
    this.text,
    this.imagePath,
  }) {
    if (text == null && imagePath == null) {
      throw EmptyMessageException();
    }
  }

  factory Message.fromMap(Map<String, Object?> map) {
    return Message(
      MessageId(map[msgIdName] as int?),
      BoardId(map[msgBoardIdName] as int),
      map[msgParentMessageIdName] == null
          ? MessageId()
          : MessageId(map[msgParentMessageIdName] as int),
      MessageAuthor(map[msgAuthorNameName] as String),
      MessageCreationTime(DateTime.parse(map[msgCreatedAtName] as String)),
      text: map[msgTextName] == null
          ? null
          : MessageText(map[msgTextName] as String),
      imagePath: map[msgImagePathName] == null
          ? null
          : MessageImage(map[msgImagePathName] as String),
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      msgIdName: id.value,
      msgBoardIdName: boardId.value,
      msgParentMessageIdName: parentMessageId?.value,
      msgAuthorNameName: authorName.value,
      msgCreatedAtName: createdAt.value.toIso8601String(),
      msgTextName: text?.value,
      msgImagePathName: imagePath?.value,
    };
  }

  @override
  String toString() {
    return 'Message($msgIdName: $id, $msgBoardIdName: $boardId, $msgParentMessageIdName: $parentMessageId, $msgAuthorNameName: $authorName, $msgCreatedAtName: $createdAt, $msgTextName: $text, $msgImagePathName: $imagePath)';
  }
}

// Repositories

abstract class BoardRepository {
  Future<Board?> findBoardById(BoardId id);

  Future<Board?> findBoardByTextIdent(BoardTextIdent textIdent);

  Future<Iterable<Board>> findAll();

  Future<void> createBoard(Board board);

  Future<void> deleteBoard(BoardId id);
}

abstract class MessageRepository {
  Future<Message?> findMessageById(MessageId id);

  Future<Iterable<Message>> findAllInBoard(BoardId id);

  Future<Iterable<Message>> findAllByParentMessage(MessageId? parentMessageId);

  Future<void> createMessage(Message message);

  Future<void> deleteMessage(MessageId id);
}

// Boards Repositories

class BoardInMemoryRepository extends BoardRepository {
  Map<BoardId, Board> inMemoryBoards = {};

  @override
  Future<Board?> findBoardById(BoardId id) async {
    return inMemoryBoards[id];
  }

  @override
  Future<Board?> findBoardByTextIdent(BoardTextIdent textIdent) async {
    for (final Board boardValue in inMemoryBoards.values) {
      if (boardValue.textIdent == textIdent) {
        return boardValue;
      }
    }
    return null;
  }

  @override
  Future<Iterable<Board>> findAll() async {
    return inMemoryBoards.values;
  }

  @override
  Future<void> createBoard(Board board) async {
    inMemoryBoards[board.id] = board;
  }

  @override
  Future<void> deleteBoard(BoardId id) async {
    inMemoryBoards.remove(id);
  }
}

class BoardInDBRepository extends BoardRepository {
  late final Future<Database> database;

  BoardInDBRepository() {
    database = openDatabase(
      '$boardsDBName.db',
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS  $boardsDBName($boardIdName INTEGER PRIMARY KEY, $boardNameName TEXT NOT NULL, $boardTextIdentName TEXT NOT NULL, $boardDescriptionName TEXT NOT NULL);',
        );
      },
      version: 1,
    );
  }

  @override
  Future<Board?> findBoardById(BoardId id) async {
    final Database databaseInner = await database;
    final List<Map<String, Object?>> resultOfQuery = await databaseInner.query(
      boardsDBName,
      columns: [
        boardIdName,
        boardNameName,
        boardTextIdentName,
        boardDescriptionName,
      ],
      where: '$boardIdName = ?',
      whereArgs: [id.value],
    );
    if (resultOfQuery.isEmpty) {
      return null;
    } else {
      return Board.fromMap(resultOfQuery.first);
    }
  }

  @override
  Future<Board?> findBoardByTextIdent(BoardTextIdent textIdent) async {
    final Database databaseInner = await database;
    final List<Map<String, Object?>> resultOfQuery = await databaseInner.query(
      boardsDBName,
      columns: [
        boardIdName,
        boardNameName,
        boardTextIdentName,
        boardDescriptionName,
      ],
      where: '$boardTextIdentName = ?',
      whereArgs: [textIdent.value],
    );
    if (resultOfQuery.isEmpty) {
      return null;
    } else {
      return Board.fromMap(resultOfQuery.first);
    }
  }

  @override
  Future<Iterable<Board>> findAll() async {
    final Database databaseInner = await database;
    final Iterable<Map<String, Object?>> boardsMap = await databaseInner.query(
      boardsDBName,
    );
    return boardsMap.map((boardData) => Board.fromMap(boardData));
  }

  @override
  Future<void> createBoard(Board board) async {
    final Database databaseInner = await database;
    await databaseInner.insert(
      boardsDBName,
      board.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  @override
  Future<void> deleteBoard(BoardId id) async {
    final Database databaseInner = await database;
    await databaseInner.delete(
      boardsDBName,
      where: '$boardIdName = ?',
      whereArgs: [id.value],
    );
  }
}

class BoardMockRepository extends BoardRepository {
  Map<BoardId, Board> boardsForMock = {
    BoardId(1): Board(
      BoardId(1),
      BoardName('testBoard'),
      BoardTextIdent('tB'),
      BoardDescription('empty'),
    ),
    BoardId(0): Board(
      BoardId(0),
      BoardName(''),
      BoardTextIdent('null'),
      BoardDescription(''),
    ),
    BoardId(2): Board(
      BoardId(2),
      BoardName('123'),
      BoardTextIdent('gnfgfd'),
      BoardDescription('346'),
    ),
  };

  @override
  Future<Board?> findBoardById(BoardId id) async {
    return boardsForMock[id];
  }

  @override
  Future<Board?> findBoardByTextIdent(BoardTextIdent textIdent) async {
    for (final Board boardValue in boardsForMock.values) {
      if (boardValue.textIdent == textIdent) {
        return boardValue;
      }
    }
    return null;
  }

  @override
  Future<Iterable<Board>> findAll() async {
    return boardsForMock.values;
  }

  @override
  Future<void> createBoard(Board board) async {
    boardsForMock[board.id] = board;
  }

  @override
  Future<void> deleteBoard(BoardId id) async {
    boardsForMock.remove(id);
  }
}

// Messages Repositories

class MessageInMemoryRepository extends MessageRepository {
  Map<MessageId, Message> inMemoryMessages = {};

  @override
  Future<Message?> findMessageById(MessageId id) async {
    return inMemoryMessages[id];
  }

  @override
  Future<Iterable<Message>> findAllInBoard(BoardId id) async {
    List<Message> result = [];
    for (final message in inMemoryMessages.values) {
      if (message.boardId == id) {
        result.add(message);
      }
    }
    return result;
  }

  @override
  Future<Iterable<Message>> findAllByParentMessage(
    MessageId? parentMessageId,
  ) async {
    List<Message> result = [];
    for (final message in inMemoryMessages.values) {
      if (message.parentMessageId == parentMessageId) {
        result.add(message);
      }
    }
    return result;
  }

  @override
  Future<void> createMessage(Message message) async {
    inMemoryMessages[message.id] = message;
  }

  @override
  Future<void> deleteMessage(MessageId id) async {
    inMemoryMessages.remove(id);
  }
}

class MessageInDBRepository extends MessageRepository {
  late final Future<Database> database;

  MessageInDBRepository() {
    database = openDatabase(
      '$msgDBName.db',
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS $msgDBName($msgIdName INTEGER PRIMARY KEY, $msgBoardIdName INTEGER NOT NULL, $msgParentMessageIdName INTEGER NULL, $msgAuthorNameName TEXT NOT NULL, $msgCreatedAtName TEXT NOT NULL, $msgTextName TEXT NULL, $msgImagePathName TEXT NULL, FOREIGN KEY ($msgBoardIdName) REFERENCES $boardsDBName ($boardIdName));',
        );
      },
      version: 1,
    );
  }
  @override
  Future<Message?> findMessageById(MessageId id) async {
    final Database databaseInner = await database;
    final List<Map<String, Object?>> resultOfQuery = await databaseInner.query(
      msgDBName,
      columns: [
        msgIdName,
        msgBoardIdName,
        msgParentMessageIdName,
        msgAuthorNameName,
        msgCreatedAtName,
        msgTextName,
        msgImagePathName,
      ],
      where: "$msgIdName = ?",
      whereArgs: [id.value],
    );
    if (resultOfQuery.isEmpty) {
      return null;
    } else {
      return Message.fromMap(resultOfQuery.first);
    }
  }

  @override
  Future<Iterable<Message>> findAllInBoard(BoardId id) async {
    final Database databaseInner = await database;
    final List<Map<String, Object?>> resultOfQuery = await databaseInner.query(
      msgDBName,
      columns: [
        msgIdName,
        msgBoardIdName,
        msgParentMessageIdName,
        msgAuthorNameName,
        msgCreatedAtName,
        msgTextName,
        msgImagePathName,
      ],
      where: "$msgBoardIdName = ?",
      whereArgs: [id.value],
    );
    return resultOfQuery.map((messageData) => Message.fromMap(messageData));
  }

  @override
  Future<Iterable<Message>> findAllByParentMessage(
    MessageId? parentMessageId,
  ) async {
    final Database databaseInner = await database;
    final List<Map<String, Object?>> resultOfQuery = await databaseInner.query(
      msgDBName,
      columns: [
        msgIdName,
        msgBoardIdName,
        msgParentMessageIdName,
        msgAuthorNameName,
        msgCreatedAtName,
        msgTextName,
        msgImagePathName,
      ],
      where: "$msgParentMessageIdName = ?",
      whereArgs: [parentMessageId?.value],
    );
    return resultOfQuery.map((messageData) => Message.fromMap(messageData));
  }

  @override
  Future<void> createMessage(Message message) async {
    final Database databaseInner = await database;
    await databaseInner.insert(
      msgDBName,
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  @override
  Future<void> deleteMessage(MessageId id) async {
    final Database databaseInner = await database;
    await databaseInner.delete(
      msgDBName,
      where: '$msgIdName = ?',
      whereArgs: [id.value],
    );
  }
}

class MessageMockRepository extends MessageRepository {
  Map<MessageId, Message> mockMessages = {};

  @override
  Future<Message?> findMessageById(MessageId id) async {
    return mockMessages[id];
  }

  @override
  Future<Iterable<Message>> findAllInBoard(BoardId id) async {
    List<Message> result = [];
    for (final message in mockMessages.values) {
      if (message.boardId == id) {
        result.add(message);
      }
    }
    return result;
  }

  @override
  Future<Iterable<Message>> findAllByParentMessage(
    MessageId? parentMessageId,
  ) async {
    return mockMessages.values.where(
      (msg) => msg.parentMessageId?.value == parentMessageId?.value,
    );
  }

  @override
  Future<void> createMessage(Message message) async {
    mockMessages[message.id] = message;
  }

  @override
  Future<void> deleteMessage(MessageId id) async {
    mockMessages.remove(id);
  }
}

Future<void> sendMessages(
  Message msg1,
  Message msg2,
  MessageRepository msgRep,
) async {
  await msgRep.createMessage(msg1);
  await msgRep.createMessage(msg2);
  print(await msgRep.findMessageById(msg2.id));
  print((await msgRep.findAllInBoard(msg1.boardId)).toList());
  print((await msgRep.findAllByParentMessage(msg1.id)).toList());
}

Future<void> main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final board0 = Board(
    BoardId(0),
    BoardName("initial"),
    BoardTextIdent("i"),
    BoardDescription("This is the first board"),
  );

  final board1 = Board(
    BoardId(1),
    BoardName("cats"),
    BoardTextIdent("ca"),
    BoardDescription("This board is created for cats!"),
  );

  final Message msg1 = Message(
    MessageId(0),
    board1.id,
    MessageId(),
    MessageAuthor(),
    MessageCreationTime(),
    text: MessageText('dfa'),
  );

  final Message msg2 = Message(
    MessageId(1),
    board1.id,
    msg1.id,
    MessageAuthor("Vova"),
    MessageCreationTime(),
    text: MessageText('Pryvitanne'),
  );

  final Message msg3 = Message(
    MessageId(2),
    board1.id,
    msg1.id,
    MessageAuthor("123"),
    MessageCreationTime(),
    imagePath: MessageImage('images'),
  );

  final Message msg4 = Message(
    MessageId(3),
    board1.id,
    msg1.id,
    MessageAuthor("Anon"),
    MessageCreationTime(),
    text: MessageText('How are you today?'),
  );

  final Message msg5 = Message(
    MessageId(4),
    board0.id,
    MessageId(),
    MessageAuthor(),
    MessageCreationTime(),
    text: MessageText('It\'s my first message!'),
  );

  final Message msg6 = Message(
    MessageId(12),
    board0.id,
    msg5.id,
    MessageAuthor(),
    MessageCreationTime(),
    imagePath: MessageImage('images'),
  );

  final MessageRepository msgRep1 = MessageInMemoryRepository();
  final MessageRepository msgRep2 = MessageInDBRepository();

  final BoardRepository boardRep = BoardInDBRepository();
  await boardRep.createBoard(board0);
  await boardRep.createBoard(board1);

  print((await boardRep.findAll()).toList());
  await boardRep.deleteBoard(board0.id);
  print((await boardRep.findAll()).toList());
  sendMessages(msg1, msg2, msgRep1);
  sendMessages(msg3, msg4, msgRep1);
  sendMessages(msg5, msg6, msgRep2);
  print('123');
}
