import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String titleTab;
  final PageController controller;
  final int page;

  DrawerTile(this.titleTab, this.icon, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
          height: 60,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: controller.page?.round() == page ? Theme.of(context).primaryColor : Color.fromARGB(255, 197, 221, 231),
              ),
              const SizedBox(
                width: 32,
              ),
              Text(
                titleTab,
                style: TextStyle(
                  fontSize: 18,
                  color: controller.page?.round() == page ? Theme.of(context).primaryColor : Color.fromARGB(255, 197, 221, 231),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
