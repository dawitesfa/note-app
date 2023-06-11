import 'package:todo/constants.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/custom_color.dart';

class Note {
  Note({
    required this.title,
    required this.note,
    this.category,
    this.color,
    this.editedDate,
  })  : id = uuid.v4(),
        date = DateTime.now();

  final String id;
  final DateTime date;
  DateTime? editedDate;
  String title;
  String note;
  Category? category;
  CustomColor? color;

  get formattedDate => dateFormatter.format(editedDate!);
}
