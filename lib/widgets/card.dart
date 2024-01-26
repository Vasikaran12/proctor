import 'package:flutter/material.dart';
import 'package:proctor/constants/color.dart';
import 'package:proctor/main.dart';
import 'package:url_launcher/url_launcher.dart';

class IdCard extends StatefulWidget {
  final String name;
  final String regnum;
  final String pname;
  final String pphone;
  final String pemail;
  const IdCard({super.key, required this.name, required this.regnum, required this.pname, required this.pphone, required this.pemail});

  @override
  State<IdCard> createState() => _IdCardState();
}

class _IdCardState extends State<IdCard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.09,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.person, size: 54, color: kPrimaryColor,),
                      )
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.15,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.regnum,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade100,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    
                    const SizedBox(
                      height: 25,
                    ),
                    /**/
                    
                    Divider(
                      thickness: 1.15,
                      indent: MediaQuery.of(context).size.width * 0.1,
                      endIndent: MediaQuery.of(context).size.width * 0.1,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.person_pin_rounded, color: Colors.white, size:27),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          widget.pname,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 19,
                            color: Colors.white,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            if(widget.pphone.isNotEmpty){
                              try{
                                if(await canLaunchUrl(Uri.parse("tel:${widget.pphone}"))){
                                  await  launchUrl(Uri.parse("tel:${widget.pphone}"));
 
                                }else {
                                  throw 'Could not launch';
                                }
                              }catch(e){
                                debugPrint(e.toString());
                                SnackBarGlobal.show("Try Again later");
                              }
                            }else{
                              SnackBarGlobal.show("Phone number not available");
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(2, 1, 1, 3),
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.width * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.shade400,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                        InkWell(
                          onTap: () async {
                            try{
                              if(await canLaunchUrl(Uri.parse("tel:${widget.pphone}"))){
                      launchUrl(Uri.parse("mailto:${widget.pemail}")); 
                                }else {
                                  throw 'Could not launch';
                                }
                            }catch(e){
                              debugPrint(e.toString());
                              SnackBarGlobal.show("Try Again later");
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.width * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.redAccent.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.mail,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        )
                      ],
                    ),const SizedBox(
                      height: 10,
                    ),
                  
                    const SizedBox(
                      height: 30,
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}