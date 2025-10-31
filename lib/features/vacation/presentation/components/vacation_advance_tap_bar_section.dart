import 'package:flutter/material.dart';
import 'package:hr_app/features/vacation/presentation/components/advance_tap_section.dart';
import 'package:hr_app/features/vacation/presentation/components/vacation_tap_section.dart';
import 'package:hr_app/features/vacation/presentation/widgets/vacation_advance_tap_bar_header.dart';

class VactionAdvanceTapBar extends StatefulWidget {
  const VactionAdvanceTapBar({super.key});

  @override
  State<VactionAdvanceTapBar> createState() => _VactionAdvanceTapBarState();
}

class _VactionAdvanceTapBarState extends State<VactionAdvanceTapBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          VacationAndAdvanceTapBarHeaderWidget(tabController: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [AdvanceTapSection(), VacationTapSection()],
            ),
          ),
        ],
      ),
    );
  }
}
