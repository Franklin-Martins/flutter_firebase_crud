import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './main.dart';


class AllData extends StatefulWidget {
  @override
  _AllDataState createState() => _AllDataState();
}

class _AllDataState extends State<AllData> {

 Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot){
    return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    
    return Padding(
     key: ValueKey(record.name),
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey),
         borderRadius: BorderRadius.circular(5.0),
       ),
       child: ListTile(
         leading: Icon(Icons.person, size: 72.0),
         title: Text(record.name),
         subtitle: Text(record.programID),
         trailing: Text(record.gpa.toString()),
         onTap: () => print(record),
       ),
     ),
   );
 }


  Widget _allItemsFromDataBase(BuildContext context){
    return StreamBuilder <QuerySnapshot> (
      stream: Firestore.instance.collection('MyStudents').snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
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
                  Navigator.pushNamed(context, '/alldata');
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
        title: Text('All files'),
      ),
      body: Center(
        child: _allItemsFromDataBase(context),
      ),
    );
  }
}

class Record {
 final String name, id, programID;
 final double gpa;
 final DocumentReference reference;

 Record.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['studentGPA'] != null),
       assert(map['studentID'] != null),
       assert(map['studentName'] != null),
       assert(map['studentProgramID'] != null),
       gpa = map['studentGPA'],
       id = map['studentID'],
       name = map['studentName'],
       programID = map['studentProgramID'];

 Record.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$name:$gpa>";
}