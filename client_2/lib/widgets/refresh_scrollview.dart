import 'package:flutter/cupertino.dart';
import 'package:kiln_controller/widgets/safearea_refresh_indicator.dart';

class RefreshScrollView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final List<Widget> children;
  RefreshScrollView({required this.onRefresh, required this.children});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          builder: buildSafeAreaRefreshIndicator,
          onRefresh: onRefresh,
        ),
        SliverSafeArea(
          sliver: SliverList(
              delegate: SliverChildListDelegate(children)
          ),
        ),
      ],
    );
  }
}
