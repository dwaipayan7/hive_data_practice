import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_data_practice/main.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';

class HiveDatabaseFlutter extends StatefulWidget {
  const HiveDatabaseFlutter({super.key});

  @override
  State<HiveDatabaseFlutter> createState() => _HiveDatabaseFlutterState();
}

class _HiveDatabaseFlutterState extends State<HiveDatabaseFlutter> {
  var peopleBox = Hive.box("MyBox");
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _ageController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestStoragePermission();
  }


  //permission state


  Future<void> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      // Permission is granted
    } else {
      // Permission is denied, handle accordingly
    }
  }


  //Function for update
  void addOrUpdate({String? key}){
    if(key != null){
      final person = peopleBox.get(key);
      if(person != null){
        _nameController.text = person['name'] ?? '';
        _ageController.text = person['age'].toString() ?? '';
      }
    }else{
      _nameController.clear();
      _ageController.clear();
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context){
      return Padding(padding: EdgeInsets.only(
        left: 15,
        right: 15,
        top: 15,
        bottom: MediaQuery.of(context).viewInsets.bottom
      ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Enter Name"
              ),
            ),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Enter Name"
              ),
            ),
          SizedBox(height: 15,),
            ElevatedButton(
                onPressed: (){
                  final name = _nameController.text;
                  final age = int.tryParse(_ageController.text);
                  //validate the text field
                  if(name.isEmpty || age == null){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please Enter Valid name and age"))
                    );
                  }
                  if(key == null){
                    final newKey = DateTime.now().microsecondsSinceEpoch.toString();
                    peopleBox.put(newKey, {"name":name, "age":age});
                  }else{
                    peopleBox.put(key,
                    {"name":name, "age":age});
                  }
                  Navigator.pop(context);
                },
                child: Text(key == null ? "Add" : "Update",)
            ),
            SizedBox(height: 25,),
          ],
        ),

      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.blue[50],
        appBar: AppBar(
            title: const Text("Flutter Hive Database", style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),),
          elevation: 4,
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          onPressed: (){

          },
        child: Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
          valueListenable: peopleBox.listenable(),
          builder: (context, box, widget){
            if(box.isEmpty){
              return Center(child: Text("No Items Added"),);
            }
            return ListView.builder(
              itemCount: box.length,
                itemBuilder: (context, index){
                final key = box.keyAt(index).toString();
                final items = box.get(key);
                return Padding(padding: EdgeInsets.all(10),
                child: ListTile(
                    title: Text(items ? ["name"]?? ""),
                ),
                );
                }
            );
          }
      ),
    );
  }
}
