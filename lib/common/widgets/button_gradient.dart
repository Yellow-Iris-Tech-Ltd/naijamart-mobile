import 'package:flutter/material.dart';

import '../../util/constants/naijamart_app_colors.dart';


class GradientCircularButton extends StatelessWidget{
  final VoidCallback onPressed;
  final IconData icon;

  const GradientCircularButton({
    required this.icon,
    required this.onPressed,
    super.key
  }) ;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35.0),
        gradient: LinearGradient(
          colors:  [
            NaijaMartAppColors.YelloGrad1,
            NaijaMartAppColors.YellowGrad2,
            ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 40,),
        onPressed: onPressed,
      ),
    );
  }
}

class BlackSquareButton extends StatelessWidget{
  final VoidCallback onPressed;
  final IconData icon;
  final double borderWidth;
  final Color? borderColor;


  const BlackSquareButton({
    required this.icon,
    required this.onPressed,
    this.borderWidth = 1.5,
    this.borderColor,
    super.key
  }) ;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.0,
      height: 30.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
        border: Border.all(
          color: borderColor ?? Colors.white,
          width: borderWidth,
        )
      ),
      child: Center(
        child: IconButton(
          icon: Icon(icon, color: borderColor ?? Colors.white, size: 20,),
          onPressed: onPressed,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}