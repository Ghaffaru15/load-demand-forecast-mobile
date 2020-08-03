import 'package:flutter/material.dart';


class Developers extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
//      MaterialApp(
//        debugShowCheckedModeBanner: false,
//        title: 'MiCard',
         Scaffold(

           appBar: AppBar(
             title:
              Text('Project Team'),

          ),
//          backgroundColor: Colors.teal,
          body: ListView(
//            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20,),
              Center(
                child:
//                CircleAvatar(
//                  
//                  backgroundImage: AssetImage('images/ghaff-pic.jpeg'),
//                  radius: 40.0,
//                ),
//                Image.asset('images/ghaff-pic.jpeg', height: 100, )
                Container(
                    width: 90.0,
                    height: 90.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new AssetImage(
                                "images/ghaff-pic.jpeg")
                        )
                    )),
              ),

              SizedBox(height: 8,),
              Center(child: Text(
                'Mr. Kwabena Amoako Kyeremeh',
                style: TextStyle(
                    color: Colors.white,
//                    fontFamily: 'Monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0),
              ),),
              SizedBox(
                height: 8.0,
              ),
             Center(child:  Text(
               'Project Supervisor',
               style: TextStyle(
                   color: Colors.teal.shade100,
                   fontSize: 15.0
               ),
             ),),

              SizedBox(height: 5,),
              Center(
                child:
//                CircleAvatar(
//
//                  backgroundImage: AssetImage('images/ghaff-pic.jpeg'),
//                  radius: 40.0,
//                ),
//                Image.asset('images/ghaff-pic.jpeg', height: 100, )
                Container(
                    width: 90.0,
                    height: 90.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new AssetImage(
                                "images/ghaff.png")
                        )
                    )),
              ),

              SizedBox(height: 10,),
              Center(child: Text(
                'Ghaffaru Mudashiru',
                style: TextStyle(
                    color: Colors.white,
//                    fontFamily: 'Monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0),
              ),),
              SizedBox(
                height: 10.0,
              ),
              Center(child:  Text(
                'BSc Computer Engineering, L400',
                style: TextStyle(
                    color: Colors.teal.shade100,
                    fontSize: 15.0
                ),
              ),),
              SizedBox(height: 8,),
              Center(
                child:
//                CircleAvatar(
//
//                  backgroundImage: AssetImage('images/ghaff-pic.jpeg'),
//                  radius: 40.0,
//                ),
//                Image.asset('images/ghaff-pic.jpeg', height: 100, )
                Container(
                    width: 90.0,
                    height: 90.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new AssetImage(
                                "images/malik.jpg")
                        )
                    )),
              ),

              SizedBox(height: 8,),
              Center(child: Text(
                'Musah Abdul Malik',
                style: TextStyle(
                    color: Colors.white,
//                    fontFamily: 'Monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0),
              ),),
              SizedBox(
                height: 8.0,
              ),
              Center(child:  Text(
                'BSc Computer Engineering, L400',
                style: TextStyle(
                    color: Colors.teal.shade100,
                    fontSize: 15.0
                ),
              ),),

              Center(
                child:
//                CircleAvatar(
//
//                  backgroundImage: AssetImage('images/ghaff-pic.jpeg'),
//                  radius: 40.0,
//                ),
//                Image.asset('images/ghaff-pic.jpeg', height: 100, )
                Container(
                    width: 90.0,
                    height: 90.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new AssetImage(
                                "images/ghaff-pic.jpeg")
                        )
                    )),
              ),

              SizedBox(height: 10,),
              Center(child: Text(
                'Ivor Andy Selasie',
                style: TextStyle(
                    color: Colors.white,
//                    fontFamily: 'Monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0),
              ),),
              SizedBox(
                height: 12.0,
              ),
              Center(child:  Text(
                'BSc. Computer Engineering',
                style: TextStyle(
                    color: Colors.teal.shade100,
                    fontSize: 15.0
                ),
              ),),
//              SizedBox(
//                height: 15,
//                child: Divider(color: Colors.teal.shade100,),
//                width: 150.0,
//              ),
//              Card(
//                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                  color: Colors.white,
//                  child: ListTile(
//                    leading: Icon(
//                      Icons.phone,
//                      color: Colors.teal,
//                    ),
//                    title: Text(
//                      '+233 24 199 2669', style: TextStyle(fontSize: 20),),
//                  )),
//              SizedBox(
//                height: 10,
//              ),
//              Card(
//                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                color: Colors.white,
//                child: ListTile(
//                  leading: Icon(
//                    Icons.email,
//                    color: Colors.teal,
//                  ),
//                  title: Text(
//                    'mudashiruagm@gmail.com',
//                    style: TextStyle(fontSize: 20),
//                  ),
//                ),
//              )
            ],
          ),
        );
//    );
  }
}