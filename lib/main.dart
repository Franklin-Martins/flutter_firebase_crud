import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './all_data.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => MyApp(),
      '/alldata': (context) => AllData(),
    },
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      accentColor: Colors.cyan
    ),
    //home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController name = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController pID = TextEditingController();
  TextEditingController gpa = TextEditingController();
  String studentName, studentID, studyProgramID;
  double studentGPA;
  
  void updateLocalData(){
    this.studentName = name.text;
    this.studentID = id.text;
    this.studyProgramID = pID.text;
    this.studentGPA = double.parse(gpa.text);
  }

  void createData(){
    print("create pressed");
    updateLocalData();
   DocumentReference documentReference = Firestore.instance.collection("MyStudents")
    .document(studentName);

    Map<String, dynamic> students={
      "studentName": studentName,
      "studentID": studentID,
      "studentProgramID": studyProgramID,
      "studentGPA": studentGPA
    };

    try {
      documentReference.setData(students).whenComplete((){
      print("$studentName created");
    }); 
    } catch (e) {
      print(e);
    }
  }
  void readData(){
    print("read pressed");
    this.studentName = name.text;
    DocumentReference documentReference = Firestore.instance.collection("MyStudents")
    .document(studentName);

    documentReference.get().then((datasnapshot){
      if (!datasnapshot.exists){
        print('No such doc');
      }
      else{
        print("Doc data: "+ datasnapshot.data["studentName"] );
      }
    });
  }
  void updateData(){
    print("update pressed");
    updateLocalData();
    DocumentReference documentReference = Firestore.instance.collection("MyStudents")
    .document(studentName);

    Map<String, dynamic> students={
      "studentName": studentName,
      "studentID": studentID,
      "studentProgramID": studyProgramID,
      "studentGPA": studentGPA
    };

    try {
      documentReference.setData(students).whenComplete((){
      print("$studentName updated");
    }); 
    } catch (e) {
      print(e);
    }
  }
  void deleteData(){
    this.studentName = name.text;
    DocumentReference documentReference = Firestore.instance.collection("MyStudents")
    .document(studentName);

    documentReference.delete().whenComplete((){
      print("$studentName deleted");
    });
  }


  Widget _customTextField(String label, TextEditingController c){
    return(
      Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: label,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue,
                  width: 2.0)
                )
              ),
              controller: c,
            ),
          )
    );
  }

  Widget _customRaisedButton(Color customColor, String buttonName, Function myEspecificFunc){
    return(
      RaisedButton(
        color: customColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
          ),
          child: Text(buttonName),
          textColor: Colors.white,
          onPressed: myEspecificFunc,
      )
    );
  }

 

  @override
  Widget build(BuildContext context) {  

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: 20.0),
          children: <Widget>[
              ListTile(
                title: Text('Todos os registros'),
                onTap: (){
                  Navigator.pushNamed(context,'/alldata');
                },
              ),
              ListTile(
                title: Text('Painel de controle'),
                onTap: (){
                  Navigator.pushNamed(context, '/');
                },
              ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("My flutter collect"),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
        children: <Widget>[
          _customTextField("name", name),
          _customTextField("Student ID", id ),
          _customTextField("Study program ID", pID ),
          _customTextField("GPA", gpa),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _customRaisedButton(Colors.green, "Create", createData),
              _customRaisedButton(Colors.blue, "Read", readData),
              _customRaisedButton(Colors.orange, "Update", updateData),
              _customRaisedButton(Colors.red, "Delete", deleteData)
            ],
          ),
        ],
      ),
      ),
    );
  }
}

