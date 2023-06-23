import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GridViewWithTitle extends StatelessWidget {
  const GridViewWithTitle({
    super.key,
    required this.count,
    required this.itemBuild,
    required this.title,
    required this.colNum,
  });
  final int count;
  final Widget Function(BuildContext context, int i) itemBuild;
  final String title;
  final int colNum;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        MasonryGridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 36),
          itemCount: count,
          crossAxisCount: colNum,
          crossAxisSpacing: 8,
          itemBuilder: itemBuild,
        )
      ],
    );
  }
}
