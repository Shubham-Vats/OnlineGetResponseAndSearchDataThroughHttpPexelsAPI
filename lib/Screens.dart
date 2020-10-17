import 'package:flutter/material.dart';
import 'APIKey.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

  
Future<Map> getData(String category) async
{
  String pexelurl = "https://api.pexels.com/v1/search?query=$category&per_page=10";
  http.Response response = await http.get(
    pexelurl,
    headers: {"Authorization" : apiKey}
  );
  print("Data Successfully Fetched from Pexels.com");
    return json.decode(response.body);
}

// ignore: must_be_immutable
class FirstScreen extends StatelessWidget {

  var _categoryNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset("assets/images/logo.jpg")
                  ),
                ),

                SizedBox(height:30.0),
                
                Text("Search for Wallpapers",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontFamily: 'Times New Roman'
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                        controller: _categoryNameController,
                        decoration: InputDecoration(
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          icon: Icon(Icons.search,size: 25,),
                          hintText: 'eg: Cars, Dog, Cat, etc',
                          hintStyle: TextStyle(
                            color: Colors.grey[500]
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height:10.0),
                
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    height: 50,
                    width: 200,
                    child: MaterialButton(
                      elevation: 10,
                      onPressed: (){
                        print(_categoryNameController.text);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ocntext) => SecondScreen(category: _categoryNameController.text,)
                          )
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.redAccent,
                      child: Text("Search",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}


class SecondScreen extends StatefulWidget {

  final String category;
  SecondScreen({this.category});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            Text("Wallpaper",style: TextStyle(color:Colors.black,fontSize: 22,fontWeight: FontWeight.w700),),
            SizedBox(width: 3),
            Text("Hub",style: TextStyle(color:Colors.blue,fontSize: 22,fontWeight: FontWeight.w700),),
          ]
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getData(widget.category),
        // ignore: missing_return
        builder: (context, snapShot){
          Map data = snapShot.data;
          if(snapShot.hasError)
          {
            print(snapShot.error);
            return Text("Failed to get respone from the server",
              style: TextStyle(
                color: Colors.red,
                fontSize: 22.0,
              ),
            );
          }
          else if(snapShot.hasData)
          {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 400,
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: data == null ? 0 : data.length,
                        itemBuilder: (BuildContext context, int index)
                        {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(data["photos"][index]["src"]["original"]),fit: BoxFit.cover,
                                )
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else if(!snapShot.hasData)
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      )
    );
  }
}


