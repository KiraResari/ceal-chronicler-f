import 'package:flutter/material.dart';

class TitleView extends StatelessWidget {
  const TitleView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: Color.fromRGBO(0, 255, 191, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCealChroniclerImage(),
          _buildWelcomeText(theme),
          _buildStartButton(theme),
        ],
      ),
    );
  }
  
  _buildCealChroniclerImage() {
    return Image.asset("assets/images/CealChroniclerLogo.png");
  }

  Text _buildWelcomeText(ThemeData theme) {
    TextStyle textStyle = theme.textTheme.displayMedium!;
    return Text(
      "Welcome to the Ceal Chronicler f!",
      style: textStyle,
    );
  }

  ElevatedButton _buildStartButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text("Go to Character Screen"),
    );
  }
}

