import 'package:flutter/material.dart';
import 'package:flutter_application_1/contact.dart';

class ContactListWidget extends StatelessWidget {
  final List<contact> contacts;
  final Function(String) onCall;
  final Function(String, {bool isVideoCall}) onChat;

  const ContactListWidget({
    Key? key,
    required this.contacts,
    required this.onCall,
    required this.onChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, index) {
          contact data = contacts[index];
          return Card(
            child: ListTile(
                leading: Image.asset("assets/imagesProfile/${data.pic}"),
                title: Text(data.name),
                subtitle: Text(data.phoneNumber),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.phone),
                      color: Colors.green[700],
                      iconSize: 30,
                      onPressed: () {
                        onCall(data.phoneNumber);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat),
                      color: Colors.blue[700],
                      iconSize: 30,
                      onPressed: () {
                        onChat(data.phoneNumber);
                        ;
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.videocam),
                      color: Colors.red[500],
                      iconSize: 30,
                      onPressed: () {
                        onChat(data.phoneNumber, isVideoCall: true);
                      },
                    ),
                  ],
                )),
          );
        }));
  }
}
