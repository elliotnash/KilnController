import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kiln_controller/models/kiln_info.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kiln_controller/providers/firing_family_provider.dart';
import 'package:kiln_controller/providers/firings_provider.dart';
import 'package:kiln_controller/providers/kiln_provider.dart';
import 'package:kiln_controller/widgets/cupertino_seperator.dart';
import 'package:kiln_controller/widgets/refresh_scrollview.dart';

DateFormat _fullFormat = DateFormat('MMMM dd, hh:mm a');

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  KilnInfo? info;

  @override
  Widget build(BuildContext context) {
    final currentInfo = ref.watch(kilnInfoProvider);
    final dispInfo = info ?? currentInfo;
    final firings = ref.watch(firingsProvider);
    List<KilnInfo> firing = [];
    if (firings.isNotEmpty) {
      firing = ref.watch(firingFamilyProvider(firings.first.uuid));
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: currentInfo == null ? Center(
        child: CupertinoActivityIndicator()
      ) : RefreshScrollView(
        onRefresh: () async {
          await Future.wait([
            ref.read(kilnInfoProvider.notifier)
                .refresh(),
            ref.read(firingsProvider.notifier)
                .refresh(),
            ref.read(firingFamilyProvider(firings.first.uuid).notifier)
                .refresh(),
          ]);
        },
        children: [
          if (firing.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 16, left: 12),
              child: FiringGraph(
                firing: firing,
                onSelect: (info) => setState(() => this.info = info),
                onSelectEnd: () => setState(() => info = null),
              ),
            ),
          Separator(),
          InfoItem(title: 'Status', content: dispInfo!.status.mode),
          InfoItem(title: 'Last Update', content: _fullFormat.format(dispInfo.updatedAt.toLocal())),
          InfoItem(title: 'Program', content: dispInfo.program.name),
          InfoItem(title: 'Ramp', content: dispInfo.status.mode == "Firing" ? dispInfo.status.firing.step : "Complete"),
          InfoItem(title: 'Average Temperature', content: '${dispInfo.status.temp.round().toString()} °F'),
          InfoItem(title: 'Zone 1 Temperature', content: '${dispInfo.status.t1.toString()} °F'),
          InfoItem(title: 'Zone 2 Temperature', content: '${dispInfo.status.t2.toString()} °F'),
          InfoItem(title: 'Zone 3 Temperature', content: '${dispInfo.status.t3.toString()} °F'),
          InfoItem(title: 'Total Firings', content: dispInfo.status.numFire.toString()),
          InfoItem(title: 'Firmware', content: dispInfo.firmwareVersion),
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
            Padding(padding: EdgeInsets.only(right: 16)),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 6)),
        Separator(),
      ],
    );
  }
}

final _hourFormat = DateFormat('hh:mm a');

class FiringGraph extends StatelessWidget {
  final List<KilnInfo> firing;
  final ValueSetter<KilnInfo> onSelect;
  final VoidCallback onSelectEnd;
  const FiringGraph({
    required this.firing,
    required this.onSelect,
    required this.onSelectEnd,
  });

  @override
  Widget build(BuildContext context) {
    final firstTime = firing.first.updatedAt.millisecondsSinceEpoch;
    final lastTime = firing.last.updatedAt.millisecondsSinceEpoch;
    final interval = (firstTime-lastTime)/6;

    final Map<double, KilnInfo> infoMap = {};
    double maxTemp = 0;
    final spots = firing.map((e) {
      final time = e.updatedAt.millisecondsSinceEpoch.toDouble();
      infoMap[time] = e;
      if (e.status.temp > maxTemp) {maxTemp = e.status.temp;}
      return FlSpot(time, e.status.temp);
    }).toList();

    final maxY = (maxTemp.round()/500).ceil() * 500.0;

    final mid = maxY/2;
    final scale = mid/10;

    final int sample = 10;
    final List<FlSpot> slopeSpots = [];
    for (int i=1; i<firing.length; i++) {
      final ss = max(0, i-sample);
      final incX = firing[i].updatedAt.difference(firing[ss].updatedAt).inMinutes;
      final incY = firing[i].status.temp - firing[ss].status.temp;
      final slope = (incY/incX);
      if (slope.abs() != double.infinity) {
        slopeSpots.add(FlSpot(
            firing[i].updatedAt.millisecondsSinceEpoch.toDouble(), slope*scale+mid));
      }
    }
    slopeSpots.insert(0, slopeSpots.first.copyWith(x: firing.first.updatedAt.millisecondsSinceEpoch.toDouble()));

    return Padding(
      padding: EdgeInsets.zero,
      child: Container(
        height: 300,
        child: Padding(
          padding: EdgeInsets.zero,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  color: CupertinoColors.systemRed,
                  spots: slopeSpots,
                  dotData: FlDotData(
                      show: false
                  ),
                ),
                LineChartBarData(
                  color: CupertinoTheme.of(context).primaryColor,
                  spots: spots,
                  dotData: FlDotData(
                      show: false
                  ),
                ),
              ],
              maxY: maxY,
              minY: 0,
              lineTouchData: LineTouchData(
                touchCallback: (event, s) {
                  final index = s?.lineBarSpots?.first.spotIndex;
                  if (event is FlLongPressEnd || event is FlTapUpEvent || event is FlPanEndEvent) {
                    onSelectEnd();
                  } else if (index != null) {
                    onSelect(firing[index]);
                  }
                },
                touchTooltipData: LineTouchTooltipData(
                  fitInsideVertically: true,
                  fitInsideHorizontally: true,
                  tooltipBgColor: CupertinoTheme.of(context).barBackgroundColor,
                  getTooltipItems: (s) {
                    final info = firing[s.last.spotIndex];
                    return [
                      LineTooltipItem(
                        '${_hourFormat.format(info.updatedAt.toLocal())}',
                        CupertinoTheme.of(context).textTheme.textStyle,
                      ),
                      LineTooltipItem(
                        '${((slopeSpots[s.last.spotIndex].y-mid)/scale).toStringAsFixed(2)} °F/min',
                        CupertinoTheme.of(context).textTheme.textStyle,
                      ),
                    ];
                  },
                )
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                  topTitles: AxisTitles(),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (yVal, meta) => Text(((yVal-mid)/scale).round().toString()),
                    )
                  ),
                  // leftTitles: AxisTitles(
                  //     sideTitles: SideTitles(
                  //         showTitles: true,
                  //     )
                  // ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (xVal, meta) {
                        return (xVal != firstTime && xVal != lastTime) ? RotationTransition(
                          turns: AlwaysStoppedAnimation(30/360),
                          child: Text(_hourFormat.format(DateTime.fromMillisecondsSinceEpoch(xVal.toInt()))),
                        ) : Container();
                      },
                      interval: interval,
                    )
                  )
                )
            ),
          ),
        ),
      ),
    );
  }

}
