import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MasterSwitch extends ConsumerWidget {
  MasterSwitch(
      {Key? key,
      required this.notificationType,
      required this.switchValue,
      required this.emailNotifications,
      this.allNotifications})
      : super(key: key);
  final String notificationType;
  bool switchValue;
  bool emailNotifications;
  final bool? allNotifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChecked = ref.watch(masterSwitchProvider);

    return ListTile(
      title: allNotifications != null && allNotifications!
          ? Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Text(
                notificationType,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                notificationType,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: !isChecked
            ? const Text(
                "By having this set to off, you may miss potential new connection or something fun.",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xffCF6679),
                ),
              )
            : null,
      ),
      minVerticalPadding: switchValue ? 4 : 14,
      trailing: CupertinoSwitch(
        activeColor: const Color(0xff00B2A2),
        thumbColor: const Color(0xffFFFFFF),
        trackColor: const Color(0xff383838),
        value: isChecked,
        onChanged: (value) {
          ref.read(masterSwitchProvider.notifier).changeValue(value);
        },
      ),
    );
  }
}

class SlaveSwitch extends ConsumerWidget {
  SlaveSwitch(
      {Key? key,
      required this.index,
      required this.notificationType,
      required this.switchValue,
      required this.emailNotifications,
      this.allNotifications})
      : super(key: key);
  final int index;
  final String notificationType;
  bool switchValue;
  final bool emailNotifications;
  final bool? allNotifications;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isChecked =
        ref.watch(masterSwitchProvider.notifier).switchValues[index];
    return ListTile(
      title: allNotifications != null && allNotifications!
          ? Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Text(
                notificationType,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                notificationType,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
      subtitle: switchValue
          ? null
          : allNotifications != null && allNotifications!
              ? const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    "By having this turned off, you may miss potential new connection or something fun.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xffCF6679),
                    ),
                  ),
                )
              : null,
      minVerticalPadding: switchValue ? 4 : 14,
      trailing: CupertinoSwitch(
        activeColor: const Color(0xff00B2A2),
        thumbColor: const Color(0xffFFFFFF),
        trackColor: const Color(0xff383838),
        value: allNotifications == null && !emailNotifications
            ? isChecked
            : switchValue,
        onChanged: (value) {
          ref
              .read(masterSwitchProvider.notifier)
              .changeSwitchValues(index, value);
          switchValue = value;
          log("check value: $value");
          if (allNotifications != null &&
              allNotifications! &&
              !emailNotifications) {
            isChecked = value;
            log("check value: $value");
          }
        },
      ),
    );
  }
}

class PushNotifications extends StatefulWidget {
  const PushNotifications({Key? key}) : super(key: key);

  @override
  State<PushNotifications> createState() => _PushNotificationsState();
}

class _PushNotificationsState extends State<PushNotifications> {
  List<String> pushNotifications = [
    "New messages",
    "New likes",
    "New matches",
    "Community updates",
    "Announcements"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff121212),
        title: const Text(
          'Push Notifications',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: SizedBox(
            child: Container(
              color: const Color(0xff1E1E1E),
              height: 1,
            ),
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 40,
          ),
          MasterSwitch(
            notificationType: "All Notifications",
            switchValue: true,
            emailNotifications: false,
            allNotifications: true,
          ),
          const Divider(
            color: Color(0xff1E1E1E),
            thickness: 1.2,
            indent: 24,
            endIndent: 24,
          ),
          const SizedBox(
            height: 40,
          ),
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xff1E1E1E),
              thickness: 1.2,
              indent: 24,
              endIndent: 24,
            ),
            itemCount: pushNotifications.length + 1,
            itemBuilder: (context, index) {
              if (index == pushNotifications.length) {
                return Container(); // zero height: not visible
              }
              return SlaveSwitch(
                  index: index,
                  emailNotifications: false,
                  notificationType: pushNotifications[index],
                  switchValue: true);
            },
          ),
        ],
      ),
    );
  }
}

final masterSwitchProvider = StateNotifierProvider<MasterSwitchProvider, bool>(
    (ref) => MasterSwitchProvider());

class MasterSwitchProvider extends StateNotifier<bool> {
  MasterSwitchProvider() : super(false);
  List<bool> switchValues = [false, false, false, false, false];
  void changeValue(bool value) {
    state = value;
    switchValues = List.filled(switchValues.length, value);
  }

  void changeSwitchValues(int index, bool value) {
    switchValues[index] = value;
  }
}
