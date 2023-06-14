import 'package:todo/constants.dart';
import 'package:todo/models/custom_color.dart';

class Note {
  Note({
    String? id,
    required this.title,
    required this.note,
    this.color,
    this.category,
    DateTime? date,
    DateTime? editedDate,
  })  : id = id ?? uuid.v4(),
        date = date ?? DateTime.now(),
        editedDate = editedDate ?? DateTime.now();

  final String id;
  final DateTime date;
  DateTime editedDate;
  String title;
  String note;
  String? category;
  CustomColor? color;

  get formattedDate => dateFormatter.format(editedDate);
}
