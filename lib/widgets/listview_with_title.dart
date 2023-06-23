import 'package:flutter/material.dart';

class ListViewWithTitle extends StatelessWidget {
  const ListViewWithTitle({
    super.key,
    required this.count,
    required this.itemBuild,
    required this.title,
  });
  final int count;
  final Widget? Function(BuildContext context, int i) itemBuild;
  final String title;

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
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 36),
          itemCount: count,
          itemBuilder: itemBuild,
        )
      ],
    );
  }
}
