// ignore_for_file: file_names

import 'dart:convert';

// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}




List<List<dynamic>> data = [];

// ignore: non_constant_identifier_names
List<List<dynamic>> search_result = [];


// ignore: prefer_typing_uninitialized_variables
var message;

var search = "";


bool edit = false;

// ignore: non_constant_identifier_names
int edit_message_number = 0;

DateTime now = DateTime.now();
String formattedDate = DateFormat('dd MMM yyyy hh:mm:ss a').format(now);
DateTime parsedDate = DateFormat('dd MMM yyyy hh:mm:ss a').parse(formattedDate);

TextEditingController messageController = TextEditingController();

class _TodoState extends State<Todo> with TickerProviderStateMixin {
  late List<SlidableController> slidableControllers = [];
  

  test() {
    
    slidableControllers.clear();
    for (int i = 0; i < data.length; i++) {
      slidableControllers.add(SlidableController(this));
    }
  }

  @override
  void initState() {
    super.initState();


    Future<int> abc() async {
      final prefs = await SharedPreferences.getInstance();
      String? jsonString = prefs.getString('data');
    
      List<dynamic> decodedList = jsonDecode(jsonString!);

      data = decodedList.map((item) => List<dynamic>.from(item)).toList();

      
      data.sort((a, b) => b[3].compareTo(a[3]));

      for (int i = 0; i < data.length; i++) {
        data[i][2] = false;       
      }
      await test();
      setState(() {});
      
      return 0;
    }

    abc();
  }

  Future<void> _deleteItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    slidableControllers.removeLast();
    if (search_result.isNotEmpty) {
            
      data.removeWhere((item) => item[1] == index);
      search_result.removeWhere((item) => item[1] == index);
      
    } else {    
      data.removeWhere((item) => item[1] == index);      
    }

    
    String jsonString = jsonEncode(data);
   
    prefs.setString("data", jsonString);
 
    setState(() {});
  }

  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    var mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        
        backgroundColor: Colors.grey[400],
        body: GestureDetector(
          onTap: () {
            if (data.isNotEmpty) {
              for (int i = 0; i < slidableControllers.length; i++) {
                slidableControllers[i].close();
              }
            }
           
          }, // Detect taps
          onPanDown: (details) {
            if (data.isNotEmpty) {              
              
              for (int i = 0; i < slidableControllers.length; i++) {
                slidableControllers[i].close();
              }
              
            }
            
          },
          child: SingleChildScrollView(
            // ignore: sized_box_for_whitespace
            child: Container(
              width: mediaQuery.width,
              height: mediaQuery.height - statusBarHeight,
              child: Stack(
                children: [
                  Column(children: [
                    // search
                    Container(
                      
                      width: mediaQuery.width * 9 / 10,
                      height: (landscape)
                          ? mediaQuery.height * 1.5 / 10
                          : mediaQuery.height * 0.6 / 10,
                      margin: (landscape)
                          ? EdgeInsets.only(
                              top: mediaQuery.height * 0.3 / 10,
                              bottom: mediaQuery.height * 0.3 / 10)
                          : EdgeInsets.only(
                              top: mediaQuery.height * 0.3 / 10,
                              bottom: mediaQuery.height * 0.3 / 10),
                      child: TextFormField(
                        onChanged: (value) {
                          
                          
                          search = value;
                          search_result.clear();
                          for (var item in data) {
                            if (item[0]
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                              search_result.add(item);
                              
                            }
                          }
                          setState(() {});
                          if (search == '') {
                            search_result.clear();
                          }
                        },
                        textAlign: TextAlign.left,
                      

                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0.0),
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Search",
                        ),
                        
                      ),
                    ),
                    // list
                    SingleChildScrollView(
                      child: Container(                        
                        width: mediaQuery.width,
                    
                        height: (landscape)
                            ? mediaQuery.height -
                                (2 * (mediaQuery.height * 0.3 / 10)) -
                                (statusBarHeight) -
                                (mediaQuery.height * 2 / 10) -
                                (mediaQuery.height * 1.5 / 10)
                            : mediaQuery.height -
                                (2 * (mediaQuery.height * 0.3 / 10)) -
                                (statusBarHeight) -
                                (mediaQuery.height * 1 / 10) -
                                (mediaQuery.height * 0.6 / 10),
                        
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "All ToDos",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Visibility(
                            
                                    visible:
                                        (data.any((element) => element[2]) ==
                                                true)
                                            ? true
                                            : false,
                                    child: InkWell(
                                      onTap: () async {
                                        for (int i = 0; i < data.length; i++) {
                                          if (data[i][2] == true) {
                                            
                                            _deleteItem(data[i][1]);
                                            
                                          }
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        width: 40,
                                        height: 40,
                                        child: const Center(
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              
                              Expanded(
                                child: ListView.builder(
                                  itemCount: search == ''
                                      ? data.length
                                      : search_result.length,
                                  itemBuilder: (context, index) {
                                    return Slidable(
                                      
                                      controller: (data.isEmpty)
                                          ? null
                                          : slidableControllers[index],
                                      
                                      key: ValueKey(
                                          index), // Unique key for each item
                                      
                                      endActionPane: ActionPane(
                                        motion:
                                            const ScrollMotion(), // The swipe motion
                                        extentRatio: (landscape) ? 0.2 : 0.35,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                if (search_result.isNotEmpty) {
                                                  messageController.text =
                                                      search_result[index][0];
                                                  
                                                  edit = true;
                                                  edit_message_number =
                                                      search_result[index][1];
                                                  setState(() {});
                                                  
                                                } else {
                                                  messageController.text =
                                                      data[index][0];
                                                  message = data[index][0];
                                                  
                                                  edit = true;
                                                  edit_message_number =
                                                      data[index][1];
                                                  setState(() {});
                                                
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.yellow,
                                                shape: const CircleBorder(),
                                                padding:
                                                    const EdgeInsets.all(10),
                                              ),
                                              child: const Icon(Icons.edit,
                                                  color: Colors.blue)),
                                          ElevatedButton(
                                              onPressed: () {
                                                if (search_result.isNotEmpty) {
                                                  
                                                  _deleteItem(
                                                      search_result[index][1]);
                                                } else {
                                                  
                                                  _deleteItem(data[index][1]);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                shape: const CircleBorder(),
                                                padding:
                                                    const EdgeInsets.all(10),
                                              ),
                                              child: const Icon(Icons.delete,
                                                  color: Colors.white)),
                                          
                                        ],
                                      ),
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 5, right: 20),
                                        margin: const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          children: [
                                            Opacity(
                                              opacity: 0.0,
                                              child: (parsedDate.year !=
                                                      now.year)
                                                  ? Text(data[index][3])
                                                  : (parsedDate.month !=
                                                          now.month)
                                                      ? Text(DateFormat('dd MMM hh:mm a').format(
                                                          DateFormat('dd MMM yyyy hh:mm:ss a').parse(
                                                              data[index][3])))
                                                      : (parsedDate.day !=
                                                              now.day)
                                                          ? Text(DateFormat(
                                                                  'dd hh:mm a')
                                                              .format(DateFormat(
                                                                      'dd MMM yyyy hh:mm:ss a')
                                                                  .parse(data[index][3])))
                                                          : Text(DateFormat('hh:mm a').format(DateFormat('dd MMM yyyy hh:mm:ss a').parse(data[index][3]))),
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: (search_result
                                                          .isNotEmpty)
                                                      ? search_result[index][2]
                                                      : data[index][2],
                                                  onChanged: (value) {
                                                    if (search_result
                                                        .isNotEmpty) {
                                                      
                                                      int dataIndex =
                                                          data.indexWhere(
                                                              (element) =>
                                                                  element[1] ==
                                                                  search_result[
                                                                          index]
                                                                      [1]);
                                                      
                                                      if (data[dataIndex][2] ==
                                                          true) {
                                                        data[dataIndex][2] =
                                                            false;
                                                      } else {
                                                        data[dataIndex][2] =
                                                            true;
                                                      }
                                                    } else {
                                                      
                                                      int dataIndex = data
                                                          .indexWhere(
                                                              (element) =>
                                                                  element[1] ==
                                                                  data[index]
                                                                      [1]);
                                                      
                                                      if (data[dataIndex][2] ==
                                                          true) {
                                                        data[dataIndex][2] =
                                                            false;
                                                      } else {
                                                        data[dataIndex][2] =
                                                            true;
                                                      }
                                                    }
                                                    setState(() {});
                                                  },
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    search_result.isNotEmpty
                                                        ? search_result[index]
                                                            [0]
                                                        : data[index][0],
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: (parsedDate.year !=
                                                        now.year)
                                                    ? Text(data[index][3])
                                                    : (parsedDate.month !=
                                                            now.month)
                                                        ? Text(DateFormat('dd MMM hh:mm a')
                                                            .format(DateFormat(
                                                                    'dd MMM yyyy hh:mm:ss a')
                                                                .parse(
                                                                    data[index]
                                                                        [3])))
                                                        : (parsedDate.day !=
                                                                now.day)
                                                            ? Text(DateFormat(
                                                                    'dd hh:mm a')
                                                                .format(DateFormat('dd MMM yyyy hh:mm:ss a').parse(data[index][3])))
                                                            : Text(DateFormat('hh:mm a').format(DateFormat('dd MMM yyyy hh:mm:ss a').parse(data[index][3]))))
                                          ],
                                        ),
                                      ),
                                    );

                                    
                                  },
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ]),
                  // creating list
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: (landscape)
                              ? mediaQuery.height * 1.5 / 10
                              : mediaQuery.height * 1 / 10,
                          minWidth: mediaQuery.width * 0.9,
                          maxHeight: (landscape)
                              ? mediaQuery.height * 2 / 10
                              : mediaQuery.height * 1.5 / 10,
                          maxWidth: mediaQuery.width * 0.9),
                      
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              
                              child: TextFormField(
                                
                                controller: messageController,
                                onChanged: (text) {
                                  message = text;
                                  
                                },
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Add a new task...",
                                ),
                                maxLines: null,
                              ),
                            ),
                            SizedBox(
                              width: mediaQuery.width * 0.02,
                            ),
                            InkWell(
                              onTap: () async {
                                
                                String formattedDate =
                                    DateFormat('dd MMM yyyy hh:mm:ss a')
                                        .format(DateTime.now());
                                if (messageController.text != '') {
                                  if (edit == false) {
                                    if (data.isEmpty) {
                                      
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      
                                      data.add(
                                          [message, 1, false, formattedDate]);
                                      slidableControllers
                                          .add(SlidableController(this));
                                      
                                      
                                      String jsonString = jsonEncode(data);
                                      
                                      prefs.setString("data", jsonString);
                                      
                                     
                                    } else {
                                      
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      data.sort((a, b) => a[1].compareTo(b[1]));
                                      data.add([
                                        message,
                                        data[data.length - 1][1] + 1,
                                        false,
                                        formattedDate
                                      ]);
                                      
                                      data.sort((a, b) => b[3].compareTo(a[3]));
                                      
                                      slidableControllers
                                          .add(SlidableController(this));                                      
                                      String jsonString = jsonEncode(data);                                      
                                      prefs.setString("data", jsonString);                                    
                                    }

                                    setState(() {
                                      messageController.clear();
                                      message = "";
                                    });
                                  } else {
                                    if (messageController.text !=
                                        (data[(data.indexWhere((element) =>
                                            element[1] ==
                                            edit_message_number))][0])) {
                                      
                                      edit = false;

                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      data[(data.indexWhere((element) =>
                                              element[1] ==
                                              edit_message_number))][0] =
                                          messageController.text;
                                      data[(data.indexWhere((element) =>
                                              element[1] ==
                                              edit_message_number))][3] =
                                          formattedDate;
                                      data.sort((a, b) => b[3].compareTo(a[3]));
                                      messageController.clear();
                                      
                                      
                                      String jsonString = jsonEncode(data);
                                      
                                      prefs.setString("data", jsonString);
                                      setState(() {
                                        messageController.clear();
                                        message = "";
                                        
                                      });
                                    } else {
                                      messageController.clear();
                                    }
                                  }
                                  
                                }
                                
                                data.sort((a, b) => b[3].compareTo(a[3]));
                                
                                setState(() {});
                              },
                              child: Container(
                                width: mediaQuery.width * 1.5 / 10,
                                height: (landscape)
                                    ? mediaQuery.height * 1.5 / 10
                                    : mediaQuery.height * 0.7 / 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue[700]),
                                child: Icon(
                                  (edit) ? Icons.check : Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
