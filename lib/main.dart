import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switcher_controller/push_notifications.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> emailNotifications = ["Community updates", "Announcements"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff121212),
        title: const Text(
          'Email',
          style: TextStyle(fontSize: 16, color: Colors.white),
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
            emailNotifications: true,
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
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xff1E1E1E),
              thickness: 1.2,
              indent: 24,
              endIndent: 24,
            ),
            shrinkWrap: true,
            itemCount: emailNotifications.length + 1,
            itemBuilder: (context, index) {
              if (index == emailNotifications.length) {
                return Container(); // zero height: not visible
              }
              return SlaveSwitch(
                index: index,
                emailNotifications: true,
                notificationType: emailNotifications[index],
                switchValue: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
