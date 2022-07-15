import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  Separator({
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: CupertinoDynamicColor.resolve(CupertinoColors.separator, context),
    );
  }
}
