import 'package:flutter/material.dart';

import '../Components/logo.dart';

class PageShell extends StatelessWidget {
  final Widget child;
  final bool showBack;
  final Widget? fab;

  const PageShell({super.key, required this.child, this.showBack = false, this.fab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: fab,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (showBack)
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                      ),
                    ),
                  const Logo(),
                ],
              ),
              const SizedBox(height: 28),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
