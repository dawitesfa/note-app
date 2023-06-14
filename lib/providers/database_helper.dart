import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;
import 'package:todo/data/data.dart';
import 'package:todo/models/note.dart';

class DatabaseHelper {
  const DatabaseHelper();

  Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'notes.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE user_notes(id TEXT PRIMARY KEY, title TEXT, note TEXT, category TEXT, color TEXT, date TEXT, editedDate TEXT)',
        );
        db.execute(
          'CREATE TABLE note_categories(title TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<List<Note>> fetchNotes() async {
    final db = await database();
    final data = await db.query('user_notes');
    final notes = data
        .map(
          (row) => Note(
            id: row['id'] as String,
            title: row['title'] as String,
            note: row['note'] as String,
            date: DateTime.tryParse(row['date'] as String),
            category: row['category'] as String?,
            color: row['color'] != null
                ? getColorById(row['color'] as String)
                : null,
            editedDate: DateTime.tryParse(row['editedDate'] as String),
          ),
        )
        .toList();
    return notes;
  }

  void addNoteToDb(Note note) async {
    final db = await database();
    db.insert('user_notes', dataToMap(note));
  }

  void updateNoteOnDb(Note note) async {
    final db = await database();
    db.update('user_notes', dataToMap(note),
        where: 'id = ?', whereArgs: [note.id]);
  }

  void removeNoteFromDb(String id) async {
    final db = await database();
    db.delete('user_notes', where: 'id = ?', whereArgs: [id]);
  }

  Map<String, Object?> dataToMap(Note note) {
    return {
      'id': note.id,
      'title': note.title,
      'note': note.note,
      'category': note.category,
      'color': note.color?.id,
      'date': note.date.toIso8601String(),
      'editedDate': note.editedDate.toIso8601String(),
    };
  }

  Future<List<String>> fetchCategories() async {
    final db = await database();
    final data = await db.query('note_categories');
    return data.map((row) => row['title'] as String).toList();
  }

  void addCategoryToDb(String cat) async {
    final db = await database();
    db.insert('note_categories', {'title': cat});
  }

  void updateCategoryOnDb(String cat) async {
    final db = await database();
    db.update('note_categories', {'title': cat},
        where: 'title = ?', whereArgs: [cat]);
  }

  void removeCategoryFromDb(String title) async {
    final db = await database();
    db.delete('note_categories', where: 'title = ?', whereArgs: [title]);
  }
}
