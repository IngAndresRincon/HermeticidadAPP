import 'package:flutter/material.dart';
import 'package:hermeticidadapp/Tools/complements.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CustomerTimeLine extends StatelessWidget {
  final bool isPast;
  final bool isLast;
  final bool isFirts;
  final String formulario;
  final Function() onTap;

  const CustomerTimeLine(
      {super.key,
      required this.isPast,
      required this.isLast,
      required this.isFirts,
      required this.onTap,
      required this.formulario});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: getScreenSize(context).height * 0.15,
      child: TimelineTile(
        alignment: TimelineAlign.start,
        isFirst: isFirts,
        isLast: isLast,
        beforeLineStyle:
            LineStyle(color: isPast ? Colors.indigo : Colors.indigo.shade200),
        indicatorStyle: IndicatorStyle(
            width: getScreenSize(context).width * 0.08,
            color: isPast ? Colors.indigo : Colors.indigo.shade200,
            iconStyle: IconStyle(
                iconData: isPast ? Icons.done : Icons.circle_outlined,
                color: isPast ? Colors.white : Colors.deepPurple.shade100)),
        endChild: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                color: isPast ? Colors.indigo : Colors.indigo.shade200,
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 4,
                      blurStyle: BlurStyle.inner,
                      color: Colors.indigo,
                      spreadRadius: 2)
                ],
                borderRadius: BorderRadius.circular(5)),
            margin: EdgeInsets.all(
              getScreenSize(context).width * 0.02,
            ),
            padding: EdgeInsets.all(
              getScreenSize(context).width * 0.01,
            ),
            width: getScreenSize(context).width * 0.3,
            height: getScreenSize(context).height * 0.1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  formulario,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'MontSerrat',
                      fontWeight: FontWeight.w600,
                      color:
                          isPast ? Colors.blue.shade300 : Colors.blue.shade100,
                      fontSize: getScreenSize(context).width * 0.045),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: getScreenSize(context).width * 0.05,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
