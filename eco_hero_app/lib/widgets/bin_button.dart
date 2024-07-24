import 'package:flutter/material.dart';

class BinButton extends StatelessWidget {
  final String binLabel;
  final Color binColor;
  final String correctBin;
  final Function(String, String) onConfirmBinSelection;

  const BinButton(
    this.binLabel,
    this.binColor,
    this.correctBin,
    this.onConfirmBinSelection, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: binColor),
      onPressed: () {
        onConfirmBinSelection(correctBin, binLabel.toLowerCase());
      },
      child: Text(binLabel),
    );
  }
}
