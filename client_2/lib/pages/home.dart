import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiln_controller/providers/kiln_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(kilnInfoProvider);
    return const CupertinoPageScaffold(
      child: Center(
        child: Text("This is all the kiln info")
      ),
    );
  }
}
