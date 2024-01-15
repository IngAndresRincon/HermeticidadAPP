import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HomeTimeLinePage extends StatefulWidget {
  const HomeTimeLinePage({super.key});

  @override
  State<HomeTimeLinePage> createState() => _HomeTimeLinePageState();
}

class _HomeTimeLinePageState extends State<HomeTimeLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: getScreenSize(context).width * 0.1),
        child: ListView(
          children: [
            GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container();
                    },
                  );
                },
                child:
                    ItemLineTime(isFirts: true, isLast: false, isPast: true)),
            ItemLineTime(isFirts: false, isLast: false, isPast: false),
            ItemLineTime(isFirts: false, isLast: true, isPast: false),
          ],
        ),
      ),
    );
  }
}
