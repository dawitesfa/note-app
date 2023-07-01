import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/prefs_provider.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/widgets/intro_item.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  int currentPage = 0;
  final List<Widget> _pages = [
    const IntroItem(
      icons: [Icons.add],
      title: 'Add a note.',
      description:
          "Organize your thoughts by adding to your note app before it is too late!",
      color: Color(0xFFDF4375),
    ),
    const IntroItem(
      icons: [Icons.color_lens],
      title: 'Choose color.',
      description: "Colorize your note whole background to your favourite one.",
      color: Color(0xFF104176),
    ),
    const IntroItem(
      icons: [Icons.camera, Icons.image],
      title: 'pick or take photo.',
      description:
          "Organize your notes with more detailed informations by including images.",
      color: Color(0xFF74e0d5),
    ),
    const IntroItem(
      icons: [Icons.push_pin],
      title: 'Pin note.',
      description:
          "Bring your important notes to the top position of your list.",
      color: Color(0xFFdcf3c4),
    ),
    const IntroItem(
      icons: [Icons.label],
      title: 'label note.',
      description: "Label your note for better organization and faster browse.",
      color: Color(0xFFfbd8af),
    ),
  ];
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.1),
              Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) => _pages[index],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<int>.generate(_pages.length, (i) => i + 1)
                        .map(
                          (pageIndex) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _pageController.animateToPage(
                                    pageIndex - 1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutCirc,
                                  );
                                });
                              },
                              child: CircleAvatar(
                                radius: 6,
                                backgroundColor: pageIndex - 1 == currentPage
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            ref
                                .read(prefsProvider.notifier)
                                .savePref(firstTime: false);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                          child: Text(
                            currentPage == _pages.length - 1 ? 'Ok' : 'Skip',
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
