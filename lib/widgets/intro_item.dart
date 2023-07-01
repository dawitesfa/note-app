import 'package:flutter/material.dart';

class IntroItem extends StatelessWidget {
  const IntroItem({
    super.key,
    required this.icons,
    required this.title,
    required this.description,
    required this.color,
  });
  final List<IconData> icons;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.width - size.width / 5,
        height: size.height - size.height / 2,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.5), color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...icons.map(
                  (icon) => Icon(icon,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6)),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(title),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
