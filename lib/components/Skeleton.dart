import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:kwh/styles/app_colors.dart';

class Skeleton extends StatelessWidget {
  final int count;

  const Skeleton({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> skeletons =
        List<Widget>.generate(count, (index) => columnSkeleton(context));

    return GFShimmer(
      mainColor: AppColors.skeletonColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: skeletons,
      ),
    );
  }

  Widget columnSkeleton(context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 10),
      Container(
        width: double.infinity,
        height: 8,
        color: Colors.grey.shade200,
        margin: EdgeInsets.only(bottom: 6),
      ),
      Container(
        width: MediaQuery.of(context).size.width * .8,
        height: 8,
        color: Colors.grey.shade50,
        margin: EdgeInsets.only(bottom: 6),
      )
    ]);
  }
}
