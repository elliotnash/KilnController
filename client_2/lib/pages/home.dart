import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiln_controller/providers/auth_provider.dart';
import 'package:kiln_controller/providers/kiln_provider.dart';
import 'package:kiln_controller/widgets/cupertino_seperator.dart';
import 'package:kiln_controller/widgets/refresh_scrollview.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(kilnInfoProvider);
    return CupertinoPageScaffold(
      child: info == null ? Center(
        child: CupertinoActivityIndicator()
      ) : RefreshScrollView(
        onRefresh: () async {
          await ref.read(kilnInfoProvider.notifier)
              .refresh(ref.read(authProvider).serial!);
        },
        children: [
          Separator(),
          InfoItem(title: 'Status', content: info.status.mode),
          InfoItem(title: 'Program', content: info.program.name),
          InfoItem(title: 'Zone 1 Temperature', content: info.status.t1.toString()),
          InfoItem(title: 'Zone 2 Temperature', content: info.status.t2.toString()),
          InfoItem(title: 'Zone 3 Temperature', content: info.status.t3.toString()),
          InfoItem(title: 'Firmware', content: info.firmwareVersion),
          InfoItem(title: 'Total Number of Firings', content: info.status.numFire.toString()),
          InfoItem(title: 'Last Update', content: info.updatedAt.toString()),
        ],
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String title;
  final String content;
  InfoItem({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 6)),
        Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 16)),
            Expanded(child: Text(title)),
            Expanded(child: Text(content)),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 6)),
        Separator(),
      ],
    );
  }
}
