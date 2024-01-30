import 'package:flutter/material.dart';
import 'package:proctor/models/student.dart';
import 'package:proctor/pages/individual_chat_page.dart';

class CustomCard extends StatelessWidget {
  final Student student;
  const CustomCard({super.key, required this.student});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IndividualPage(student: student, 
                    )));},
          child: ListTile(
            leading: CircleAvatar(
              radius: 27,
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.09,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(
                          Icons.person,
                          size: 44,
                          color: Colors.white,
                        ),
                      ),
            ),
            title: Text(
              student.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Row(
              children: [
                Icon(Icons.done),
                SizedBox(
                  width: 3,
                ),
                 Text(
                  "Hello world",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: Text(student.regnum),
          ),
        ),
        
      ],
    );
  }
}
