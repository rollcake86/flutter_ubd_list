import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'UDB list'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var date = "20180101";

  var data;

  TextEditingController controller = TextEditingController();

  Future<String> getJSONData() async {
    var url = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=430156241533f1d058c603178cc3ca0e&targetDt="+ date;
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      var dataConvertedToJSON = json.decode(response.body);
      data = dataConvertedToJSON['boxOfficeResult']['dailyBoxOfficeList'];
    });
    return "Successfull";
  }

  @override
  void initState() {
    this.getJSONData();
    super.initState();
  }

  void _searchMovieList() {
    date = controller.text;
    print(date);
    this.getJSONData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Container(
       child: new Column(
         children: <Widget>[
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: TextField(
               onChanged: (value) {
               },
               controller: controller,
               keyboardType:TextInputType.number,
               decoration: InputDecoration(
                   labelText: "날짜",
                   hintText: "YYYYMMDD 로 입력하세요 20180101",
                   prefixIcon: Icon(Icons.search),
                   border: OutlineInputBorder(
                       borderRadius: BorderRadius.all(Radius.circular(25.0)))),
             ),
           ),
           Expanded(
             child:  new ListView.builder(
                 itemCount: data == null ? 0 : data.length,
                 itemBuilder: (BuildContext context, int index) {
                   return new Container(
                     child: new Center(
                       child: new Column(
                         crossAxisAlignment: CrossAxisAlignment.stretch,
                         children: <Widget>[
                           new Card(
                             child: new Container(
                               decoration: BoxDecoration(
                                   border: Border.all(style: BorderStyle.solid),
                                   borderRadius:
                                   BorderRadius.all(Radius.circular(25.0))),
                               child: new Row(
                                 children: <Widget>[
                                   new Padding(padding: EdgeInsets.only(right: 20.0) , child:
                                   new Icon(Icons.movie , color: Colors.blueAccent, size:  75,),),
                                   new Column(
                                     children: <Widget>[
                                       new Text(
                                         getMovieName(data[index]['movieNm']),
                                         textAlign: TextAlign.center,
                                         style: new TextStyle(
                                             fontSize: 20.0, color: Colors.black),
                                       ),
                                       new Text(
                                         '관객수 : ' + data[index]['audiAcc'] + '명',
                                         style: new TextStyle(
                                             fontSize: 20.0,
                                             color: Colors.lightBlueAccent),
                                       ),
                                       new Text(
                                         getUBD(data[index]['audiAcc']),
                                         style: new TextStyle(
                                             fontSize: 20.0,
                                             color: Colors.lightBlueAccent),
                                       )
                                     ],
                                   )

                                 ],
                               ),
                               padding: EdgeInsets.all(15.0),
                             ),
                           )
                         ],
                       ),
                     ),
                   );
                 }),
           )
         ],
       ),
      ) ,
      floatingActionButton: FloatingActionButton(
        onPressed: _searchMovieList,
        tooltip: 'Increment',
        child: Icon(Icons.search),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String getMovieName(String name){
    if(name.length > 11){
      return name.substring(0,10) + "...";
    }else{
      return name;
    }
  }

  String getUBD(String acount) {
    double result = (int.parse(acount) / 170000);
    return 'UBD : ' + result.toString();
  }
}
