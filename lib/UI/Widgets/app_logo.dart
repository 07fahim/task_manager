import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../Utills/assets_path.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(AssetsPath.logoPath,width: 120,);
  }
}