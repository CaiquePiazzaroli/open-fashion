import 'package:flutter/material.dart';
import 'package:open_fashion/pages/home_template.dart';
import 'package:open_fashion/widgets/footer_widget.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({super.key});

  @override
  State<StatefulWidget> createState() => _BannerPage();
}

class _BannerPage extends State<BannerPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Banner(screenWidth: screenWidth, screenHeight: screenHeight),
            const SizedBox(height: 40), // espaçamento entre banner e footer
            const Footer(),
          ],
        ),
      ),
    );
  }
}

class Banner extends StatelessWidget {
  const Banner({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final dynamic screenHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/Banner.png',
          width: screenWidth,
          fit: BoxFit.fitWidth,
        ),
        Positioned(
          bottom: 43,
          left: 0,
          right: 0,
          child: Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeTemplate(categoryGrid: 0),
                  ),
                );
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(200, 30),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 18,
                ),
                backgroundColor: const Color.fromARGB(40, 0, 0, 0),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'TenorSans',
                ),
              ),
              child: const Text("EXPLORE COLLECTION"),
            ),
          ),
        ),
      ],
    );
  }
}
