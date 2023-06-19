import 'dart:convert';
import 'dart:io';

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
          'CREATE TABLE user_notes(id TEXT PRIMARY KEY, title TEXT, note TEXT, category TEXT, color TEXT, date TEXT, editedDate TEXT, images TEXT)',
        );
        db.execute(
          'CREATE TABLE note_categories(title TEXT)',
        );
        db.execute(
          'CREATE TABLE prefs(grid INTEGER, activeCategory TEXT)',
        );
        db.execute(
          'CREATE TABLE pins(id TEXT PRIMARY KEY)',
        );
      },
      version: 1,
    );
  }

  Future<List<Note>> fetchNotes() async {
    final db = await database();
    final data = await db.query('user_notes');
    final notes = data.map(
      (row) {
        final List<String> images =
            (jsonDecode(row['images'] as String) as List<dynamic>)
                .cast<String>();

        return Note(
          id: row['id'] as String,
          title: row['title'] as String,
          note: row['note'] as String,
          date: DateTime.tryParse(row['date'] as String),
          category: row['category'] as String?,
          color: row['color'] != null
              ? getColorById(row['color'] as String)
              : null,
          editedDate: DateTime.tryParse(row['editedDate'] as String),
          imageUrls: images.map((img) => File(img)).toList(),
        );
      },
    ).toList();
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
    List<String> images = note.imageUrls.map((img) => img.path).toList();
    print(images);
    return {
      'id': note.id,
      'title': note.title,
      'note': note.note,
      'category': note.category,
      'color': note.color?.id,
      'date': note.date.toIso8601String(),
      'editedDate': note.editedDate.toIso8601String(),
      'images': jsonEncode(images),
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

  Future<Map<String, Object?>> fetchPrefs() async {
    final db = await database();
    final data = await db.query('prefs');
    return {
      'isGrid': data[0]['grid'] == 1 ? true : false,
      'activeCategory': (data[0]['activeCategory'] as String).isNotEmpty
          ? data[0]['activeCategory'] as String
          : null
    };
  }

  void addPrefs(isGrid, activeCategory) async {
    final db = await database();
    db.insert(
        'prefs', {'grid': isGrid ? 1 : 0, 'activeCategory': activeCategory});
  }

  void savePrefs(isGrid, activeCategory) async {
    final db = await database();
    db.update(
      'prefs',
      {'grid': isGrid ? 1 : 0, 'activeCategory': activeCategory},
    );
  }

  Future<List<String>> fetchPins() async {
    final db = await database();
    final data = await db.query('pins');
    final ids = data.map((e) => e['id'] as String).toList();
    return ids;
  }

  void addPin(String id) async {
    final db = await database();
    db.insert('pins', {'id': id});
  }

  void removePin(String id) async {
    final db = await database();
    db.delete('pins', where: 'id = ?', whereArgs: [id]);
  }
}
