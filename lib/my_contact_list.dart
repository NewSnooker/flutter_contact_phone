// ignore_for_file: avoid_types_as_parameter_names, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_application_1/contact.dart';
import 'package:flutter_application_1/contact_list_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MyContactList extends StatefulWidget {
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  const MyContactList(
      {Key? key, required this.onToggleTheme, required this.isDarkMode});

  @override
  State<MyContactList> createState() => _MyContactListState();
}

class _MyContactListState extends State<MyContactList> {
  late List<contact> contactData;
  TextEditingController searchController = TextEditingController();
  late List<contact> filteredContacts;

  void _filterFx(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredContacts = List.from(contactData);
      } else {
        filteredContacts = contactData
            .where((contact) =>
                contact.name.toLowerCase().contains(query.toLowerCase()) ||
                contact.phoneNumber.contains(query))
            .toList();
      }
    });
  }

  void _onSearchChanged() {
    _filterFx(searchController.text);
  }

  @override
  void initState() {
    super.initState();
    contactData = [
      contact('รัชานนท์', '0985252885', '0.jpg'),
      contact('สแตมป์', '0985252885', '1.jpg'),
      contact('อาร์ม', '0985252885', '2.jpg'),
      contact('อ้น', '0985252885', '3.jpg'),
    ];
    filteredContacts = List.from(contactData);
    searchController.addListener(_onSearchChanged);
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  Future<void> _openWhatApp(String phoneNumber,
      {bool isVideoCall = false}) async {
    if (phoneNumber.isEmpty) {
      print("เบอร์โทรไม่ถูกต้อง");
      return;
    }

    String formattedNumber = phoneNumber;
    if (!formattedNumber.startsWith("+66")) {
      formattedNumber = "+66$formattedNumber"; //เพิ่มเครื่องหมาย + หากไม่มี
    }
    // สร้าง URI สำหรับ WhatsApp
    final Uri whatsAppUri = isVideoCall
        ? Uri.parse("whatsapp://call?phone=$formattedNumber&video=1")
        : Uri.parse("whatsapp://send?phone=$formattedNumber");
    try {
      if (await canLaunchUrl(whatsAppUri)) {
        await launchUrl(whatsAppUri);
      } else {
        // ถ้าไม่สามารถเปิด WhatsApp ได้ ลองเปิดเว็บเวอร์ชั่น
        final Uri webWhatsAppUri = Uri.parse("https://wa.me/$formattedNumber");
        if (await canLaunchUrl(webWhatsAppUri)) {
          await launchUrl(webWhatsAppUri);
        } else {
          throw "ไม่สามารถเปิด WhatApp หรือเว็บ WhatApp ได้";
        }
      }
    } catch (error) {
      print("เกิดข้อผิดพลาดในการเปิด WhatsApp: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('รายชื่อผู้ติดต่อ'),
        ),
        actions: [
          Switch(value: widget.isDarkMode, onChanged: widget.onToggleTheme),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                  labelText: 'ค้นหารายชื่อหรือเบอร์โทรศัพท์',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
          Expanded(
              child: ContactListWidget(
            contacts: filteredContacts,
            onCall: _makePhoneCall,
            onChat: _openWhatApp,
          )),
        ],
      ),
    );
  }
}
