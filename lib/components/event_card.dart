import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/event.dart';

class EventCard extends StatefulWidget {
  const EventCard({
    Key? key,
    required this.events,
  }) : super(key: key);

  final Event events;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isEnabled = true;
  bool _isLikePressed = false;

  void likePressed () {setState(() {
    if (_isLikePressed = false) {_isLikePressed = true;} else {_isLikePressed = false;}
  });}


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(widget.events.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        subtitle: Column(
          children: [
            Text("${widget.events.location} , ${widget.events.startDateTime}", style: const TextStyle(fontSize: 18),),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  GestureDetector(child: Container(child: Icon(Icons.favorite, color: _isLikePressed ? Colors.red : Colors.greenAccent)), onTap: likePressed),
                  Container(child: const Icon(Icons.reply, size:25), margin: const EdgeInsets.only(left: 20),)
                ],
              ),
            ),],
        ), //ДОБАВИТЬ ФОТКИ
        leading: const Icon(Icons.local_activity, size: 30, color: Colors.black,),
        //trailing: IconButton(icon: _isEnabled ? const Icon(Icons.lock_outline, size: 30) : const Icon(Icons.lock_open, size: 30,), onPressed: () { setState(() {_isEnabled = !_isEnabled;});},),
        onTap: () => print(widget.events.name),
        selected: false,
      ),
    );
  }
}