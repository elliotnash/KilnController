import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiln_controller/providers/auth_provider.dart';
import 'package:kiln_controller/providers/kiln_provider.dart';
import 'package:kiln_controller/util/safe_area_refresh_indicator.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(kilnInfoProvider);
    return CupertinoPageScaffold(
      child: info == null ? Center(
        child: CupertinoActivityIndicator()
      ) : KilnInfoScrollView(
        children: [
          Text("First"),
          Text("Second")
        ],
      ),
    );
  }
}

class KilnInfoScrollView extends ConsumerWidget {
  final List<Widget> children;
  KilnInfoScrollView({required this.children});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          builder: buildSafeAreaRefreshIndicator,
          onRefresh: () async {
            await ref.read(kilnInfoProvider.notifier)
                .refresh(ref.read(authProvider).serial!);
          },
        ),
        SliverSafeArea(
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed(children)
          ),
        ),
      ],
    );
  }
}

class InfoItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
