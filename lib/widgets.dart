import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_task/main.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/img/empty_state.svg',
          width: 120,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text('Your Task List is Empty'),
      ],
    );
  }
}


class MyCheckBox extends StatelessWidget {
  const MyCheckBox({Key? key, required this.onTap, required this.value})
      : super(key: key);
  final bool value;
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              !value ? Border.all(color: secondryTextColor, width: 2) : null,
          color: value ? primaryColor : null,
        ),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                size: 16,
                color: themeData.colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }

}
