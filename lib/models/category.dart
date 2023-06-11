import 'package:todo/constants.dart';

class Category {
  Category({
    required this.label,
  }) : id = uuid.v4();

  final String id;
  final String label;
}
