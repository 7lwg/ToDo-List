
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todo extends StatefulWidget {
  Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

bool? visited;

// int count = 0;

var deleted_index = null;

// List<String> data = [];

List<List<dynamic>> data = [];

List<List<dynamic>> search_result = [];

// List<bool> selected = [];

var number = 0;

var message;

var search = "";

bool _isVisible = false;

bool edit = false;

int edit_message_number = 0;

DateTime now = DateTime.now();
String formattedDate = DateFormat('dd MMM yyyy hh:mm:ss a').format(now);
DateTime parsedDate = DateFormat('dd MMM yyyy hh:mm:ss a').parse(formattedDate);

TextEditingController messageController = TextEditingController();

class _TodoState extends State<Todo> with TickerProviderStateMixin {
  // // late final controller = SlidableController(this);
  //  late List<SlidableController> _slidableControllers = [SlidableController];
  late List<SlidableController> slidableControllers = [];
  // late SlidableController controller;

  test() {
    // slidableControllers =
    //     List.generate(data.length, (_) => SlidableController(this));
    slidableControllers.clear();
    for (int i = 0; i < data.length; i++) {
      slidableControllers.add(SlidableController(this));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // controller = SlidableController(this);

    Future<int> abc() async {
      final prefs = await SharedPreferences.getInstance();

      // data = prefs.getStringList("data") as List<List<dynamic>>;
      // String jsonString = prefs.getString('data') ?? '';
      // data = jsonDecode(jsonString);
      // print('data: ' + data.toString());
      String? jsonString = prefs.getString('data');
      // if (jsonString != null) {
      // Convert the JSON string back to a List
      List<dynamic> decodedList = jsonDecode(jsonString!);

      // You can cast it to List<List<dynamic>> if needed
      data = decodedList.map((item) => List<dynamic>.from(item)).toList();

      // Print the retrieved list
      print('data: ' + data.toString());
      data.sort((a, b) => b[3].compareTo(a[3]));

      // } else {
      //   print('No data found!');
      // }

      // You can cast it to List<List<dynamic>> if needed
      // List<List<dynamic>> myList = decodedList.map((item) => List<dynamic>.from(item)).toList();

      // count = data.length;
      for (int i = 0; i < data.length; i++) {
        data[i][2] = false;
        //  data[['sting',1,true],['sting',2,false],['sting',3,true]]
        // data[0][]
      }
      await test();
      setState(() {});
      // return count;
      return 0;
    }

    abc();
  }

  Future<void> _deleteItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    // print('1_slidableControllers: ' +
    //     data.indexWhere((element) => element[1] == index).toString());
    // _slidableControllers.removeAt(data.indexWhere((item) => item[1] == index));
    slidableControllers.removeLast();
    if (search_result.isNotEmpty) {
      // print(search_result[index].toString() + '/*/**/*//**/*/*/*/*/');

      // print('*//**/*//*/**//*/**//*/*/*/*');
      // for (int i = 0; i < data.length; i++) {
      //   // data.remove(search_result[index][1]);
      //   if (data[i][1] == index) {
      //     data.removeAt(i);
      //   }
      // }
      print('index: ' + index.toString());
      data.removeWhere((item) => item[1] == index);
      search_result.removeWhere((item) => item[1] == index);
      // search_result.removeAt(index);
      // selected.removeAt(data.indexOf(search_result[index]));
    } else {
      // for (int i = 0; i < data.length; i++) {
      //   if (data[i][1] == index) {
      //     data.removeAt(i);
      //   }
      // }
      // print('index: ' + index.toString());
      data.removeWhere((item) => item[1] == index);
      // data.remove(data[index]);
      // selected.removeAt(index);
    }

    // await prefs.setStringList("data", data.cast<String>());
    String jsonString = jsonEncode(data);
    // prefs.setStringList(
    //     "data", data.cast<String>());
    prefs.setString("data", jsonString);
    // count = data.length;
    // await prefs.setInt("count", count);
    setState(() {});
  }

  Widget build(BuildContext context) {
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    var mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[400],
        body: GestureDetector(
          onTap: () {
            if (data.length != 0) {
              for (int i = 0; i < slidableControllers.length; i++) {
                slidableControllers[i].close();
              }
            }
            // else {
            //   controller.close();
            // }
          }, // Detect taps
          onPanDown: (details) {
            if (data.length != 0) {
              print('_slidableControllers: ' +
                  slidableControllers.length.toString());
              // Detect any pan gesture (like swipe)
              // _onScreenTouched();
              for (int i = 0; i < slidableControllers.length; i++) {
                slidableControllers[i].close();
              }
              // print('closed');
            }
            // else {
            //   controller.close();
            // }
          },
          child: SingleChildScrollView(
            child: Container(
              width: mediaQuery.width,
              height: mediaQuery.height - statusBarHeight,
              child: Stack(
                children: [
                  Column(children: [
                    // search
                    Container(
                      // color: Colors.red,
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
                          // print('//** selected: ' + selected.toString());
                          print('//** data: ' + data.toString());
                          search = value;
                          search_result.clear();
                          for (var item in data) {
                            if (item[0]
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                              search_result.add(item);
                              // if (search == "") {
                              //   count = data.length;
                              // } else {
                              //   count = search_result.length;
                              // }
                            }
                          }
                          setState(() {});
                          if (search == '') {
                            search_result.clear();
                          }
                        },
                        textAlign: TextAlign.left,
                        // textAlignVertical: TextAlignVertical.bottom,

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
                        // decoration: InputDecoration(
                        //   errorStyle: TextStyle(color: Colors.red[400], height: 0.2),
                        //   contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                        //   prefixIcon: const Icon(Icons.business,
                        //       color: Color.fromARGB(255, 145, 142, 142), size: 30),
                        //   filled: true,
                        //   fillColor: Colors.white,
                        //   border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(100),
                        //   ),
                        //   hintText: 'Company Name',
                        //   // hintStyle: getTextGrey(context)
                        // ),
                      ),
                    ),
                    // list
                    SingleChildScrollView(
                      child: Container(
                        // color: Colors.red,
                        width: mediaQuery.width,
                        // 2 * (mediaQuery.height * 1.5 / 10) + (mediaQuery.height * 1.5 / 10)
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
                        // margin: EdgeInsets.only(
                        //     left: 10, right: 10, top: mediaQuery.height * 0.5 / 10),
                        margin: EdgeInsets.only(
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
                                    // data.any(
                                    //                     (element) => element[2]) ==
                                    //                 true)
                                    visible:
                                        (data.any((element) => element[2]) ==
                                                true)
                                            ? true
                                            : false,
                                    child: InkWell(
                                      onTap: () async {
                                        for (int i = 0; i < data.length; i++) {
                                          if (data[i][2] == true) {
                                            print('123 data: ' + i.toString());
                                            print('123 data: ' +
                                                data[i][1].toString() +
                                                '4');
                                            _deleteItem(data[i][1]);
                                            print(
                                                '123 data: ' + data.toString());
                                            // await _deleteItem(data[index][1]);
                                          }
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            // color: Colors.red,
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

                              // if (search_result.length == 0)
                              Expanded(
                                child: ListView.builder(
                                  itemCount: search == ''
                                      ? data.length
                                      : search_result.length,
                                  itemBuilder: (context, index) {
                                    return Slidable(
                                      // controller: (data.length == 0)
                                      //     ? null
                                      //     : (data.length == 1)
                                      //         ? controller
                                      //         : slidableControllers[index],
                                      controller: (data.length == 0)
                                          ? null
                                          : slidableControllers[index],
                                      // controller: controller,
                                      key: ValueKey(
                                          index), // Unique key for each item
                                      // Specify the action when swiping to the right
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
                                                  print('data editted: ' +
                                                      search_result[index][0]
                                                          .toString());
                                                  edit = true;
                                                  edit_message_number =
                                                      search_result[index][1];
                                                  setState(() {});
                                                  // _slidableControllers[index].close();
                                                  // setState(() {});
                                                } else {
                                                  messageController.text =
                                                      data[index][0];
                                                  message = data[index][0];
                                                  print('data editted: ' +
                                                      data[index][0]
                                                          .toString());
                                                  edit = true;
                                                  edit_message_number =
                                                      data[index][1];
                                                  setState(() {});
                                                  // _slidableControllers[index].close();
                                                  // setState(() {});
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
                                                  print('data delete1');
                                                  print('index at delete1: ' +
                                                      search_result[index][1]
                                                          .toString());
                                                  print('index at delete1: ' +
                                                      search_result[index][0]
                                                          .toString());
                                                  _deleteItem(
                                                      search_result[index][1]);
                                                } else {
                                                  print('data delete');
                                                  print('index at delete: ' +
                                                      data[index][1]
                                                          .toString());
                                                  print('index at delete: ' +
                                                      data[index][0]
                                                          .toString());
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
                                          // SlidableAction(
                                          //   onPressed: (context) {
                                          //     // Handle edit action
                                          //     // _editItem(
                                          //     //     index); // Your function to edit the item
                                          //   },
                                          //   backgroundColor: Colors.blue,
                                          //   foregroundColor: Colors.white,
                                          //   icon: Icons.edit,
                                          //   label: 'Edit',
                                          // ),
                                          // SlidableAction(
                                          //   onPressed: (context) {
                                          //     // Handle delete action
                                          //     _deleteItem(data[index][
                                          //         1]); // Your function to delete the item
                                          //   },
                                          //   backgroundColor: Colors.red,
                                          //   foregroundColor: Colors.white,
                                          //   icon: Icons.delete,
                                          //   label: 'Delete',
                                          // ),
                                        ],
                                      ),
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 20),
                                        margin: EdgeInsets.only(bottom: 10),
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
                                                      print('index 1');
                                                      int dataIndex =
                                                          data.indexWhere(
                                                              (element) =>
                                                                  element[1] ==
                                                                  search_result[
                                                                          index]
                                                                      [1]);
                                                      print('index2');
                                                      print('dataIndex: ' +
                                                          dataIndex.toString());
                                                      if (data[dataIndex][2] ==
                                                          true) {
                                                        data[dataIndex][2] =
                                                            false;
                                                      } else {
                                                        data[dataIndex][2] =
                                                            true;
                                                      }
                                                    } else {
                                                      print('index3');
                                                      int dataIndex = data
                                                          .indexWhere(
                                                              (element) =>
                                                                  element[1] ==
                                                                  data[index]
                                                                      [1]);
                                                      print('index4: ' +
                                                          dataIndex.toString());
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
                                                SizedBox(width: 10),
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

                                    // Dismissible(
                                    //   key: Key(data[index][1]
                                    //       .toString()), // Unique key for each item
                                    //   direction: DismissDirection
                                    //       .endToStart, // Swiping left to right
                                    //   background: Container(
                                    //       color: Colors.transparent), // Optional
                                    //   secondaryBackground: Container(
                                    //     color: Colors.grey[400],
                                    //     padding: EdgeInsets.symmetric(horizontal: 20),
                                    //     child: Row(
                                    //       mainAxisAlignment: MainAxisAlignment.end,
                                    //       children: [
                                    // ElevatedButton(
                                    //     onPressed: () {},
                                    //     style: ElevatedButton.styleFrom(
                                    //       backgroundColor: Colors.yellow,
                                    //       shape: const CircleBorder(),
                                    //       padding: const EdgeInsets.all(10),
                                    //     ),
                                    //     child: const Icon(Icons.edit,
                                    //         color: Colors.blue)),
                                    // ElevatedButton(
                                    //     onPressed: () {
                                    //       _deleteItem(data[index][1]);
                                    //     },
                                    //     style: ElevatedButton.styleFrom(
                                    //       backgroundColor: Colors.red,
                                    //       shape: const CircleBorder(),
                                    //       padding: const EdgeInsets.all(10),
                                    //     ),
                                    //     child: const Icon(Icons.delete,
                                    //         color: Colors.white)),
                                    //       ],
                                    //     ),
                                    //   ),
                                    //   confirmDismiss: (direction) async {
                                    //     if (direction ==
                                    //         DismissDirection.endToStart) {
                                    //       // return await _confirmDelete(
                                    //       //     index); // Confirmation before deleting
                                    //     }
                                    //     return false;
                                    //   },
                                    //   child: Container(
                                    //     padding: EdgeInsets.only(left: 5, right: 20),
                                    //     margin: EdgeInsets.only(bottom: 10),
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.white,
                                    //       borderRadius: BorderRadius.circular(20),
                                    //     ),
                                    //     child: Row(
                                    //       children: [
                                    //         Checkbox(
                                    //           value: (search_result.isNotEmpty)
                                    //               ? search_result[index][2]
                                    //               : data[index][2],
                                    //           onChanged: (value) {
                                    //             if (search_result.isNotEmpty) {
                                    //               data[data.indexWhere((element) =>
                                    //                   element[1] ==
                                    //                   search_result[index]
                                    //                       [1])][2] = !data[
                                    //                   data.indexWhere((element) =>
                                    //                       element[1] ==
                                    //                       search_result[index]
                                    //                           [1])][2];
                                    //             } else {
                                    //               data[index][2] = !data[index][2];
                                    //             }
                                    //             setState(() {});
                                    //           },
                                    //         ),
                                    //         SizedBox(width: 10),
                                    //         if (search_result.isEmpty)
                                    //           Expanded(
                                    //             child: SingleChildScrollView(
                                    //               child: Column(
                                    //                 crossAxisAlignment:
                                    //                     CrossAxisAlignment.start,
                                    //                 children: [
                                    //                   Text(
                                    //                     data[index][0],
                                    //                     softWrap: true,
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         if (search_result.isNotEmpty)
                                    //           Expanded(
                                    //             child: Text(
                                    //               search_result[index][0],
                                    //               softWrap: true,
                                    //             ),
                                    //           ),
                                    //         SizedBox(width: 10),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // );

                                    // Container(
                                    //   padding: EdgeInsets.only(left: 5, right: 20),
                                    //   // height: mediaQuery.height * 0.8 / 10,
                                    //   margin: EdgeInsets.only(bottom: 10),
                                    //   decoration: BoxDecoration(
                                    //       color: Colors.white,
                                    //       borderRadius: BorderRadius.circular(20)),
                                    //   child: Row(
                                    //     children: [
                                    //       Checkbox(
                                    //           value: (search_result.isNotEmpty)
                                    //               ? search_result[index][2]
                                    //               : data[index][2],
                                    //           // value: data.whereindex((element) => element[1] == 1),
                                    //           onChanged: (value) {
                                    //             // print('ahmed data: ' +
                                    //             //     data[index].toString());
                                    //             // print('index: ' +
                                    //             //     data[index][1].toString());
                                    //             // print('123 data: ' +
                                    //             //     data
                                    //             //         .where((element) =>
                                    //             //             element[1] ==
                                    //             //             data[index][1])
                                    //             //         .toString());
                                    //             if (search_result.isNotEmpty) {
                                    //               if (data[data.indexWhere(
                                    //                       (element) =>
                                    //                           element[1] ==
                                    //                           search_result[index]
                                    //                               [1])][2] ==
                                    //                   true) {
                                    //                 data[data.indexWhere((element) =>
                                    //                         element[1] ==
                                    //                         search_result[index][1])]
                                    //                     [2] = false;
                                    //               } else {
                                    //                 data[data.indexWhere((element) =>
                                    //                         element[1] ==
                                    //                         search_result[index][1])]
                                    //                     [2] = true;
                                    //               }
                                    //             } else {
                                    //               if (data[index][2] == true) {
                                    //                 data[index][2] = false;
                                    //               } else {
                                    //                 data[index][2] = true;
                                    //               }
                                    //             }
                                    //             print('123 data: ' + data.toString());
                                    //             // if (data[index][2] == false) {
                                    //             //   _isVisible = false;
                                    //             // } else {
                                    //             //   _isVisible = true;
                                    //             // }
                                    //             // data.removeWhere((item) => item[1] == index);
                                    //             // if (data.any(
                                    //             //         (element) => element[2]) ==
                                    //             //     true) {
                                    //             //   _isVisible = true;
                                    //             // } else {
                                    //             //   _isVisible = false;
                                    //             // }
                                    //             setState(() {});
                                    //           }),
                                    //       SizedBox(
                                    //         width: 10,
                                    //       ),
                                    //       if (search_result.isEmpty)
                                    //         Expanded(
                                    //           // width: 100,
                                    //           // height: 30,
                                    //           // padding:
                                    //           //     EdgeInsets.only(left: 5, right: 20),
                                    //           // height: mediaQuery.height * 0.8 / 10,
                                    //           // width: mediaQuery.width - 200,
                                    //           child: SingleChildScrollView(
                                    //             child: Column(
                                    //               crossAxisAlignment:
                                    //                   CrossAxisAlignment.start,
                                    //               children: [
                                    //                 Text(
                                    //                   data[index][0],
                                    //                   // search_result[index],
                                    //                   softWrap: true,
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       if (search_result.isNotEmpty)
                                    //         Expanded(
                                    //           child: Text(
                                    //             // (count = search_result.length);
                                    //             // data[index],
                                    //             search_result[index][0],
                                    //             softWrap: true,
                                    //           ),
                                    //         ),
                                    //       SizedBox(
                                    //         width: 10,
                                    //       ),
                                    //       InkWell(
                                    //         onTap: () async {
                                    //           _deleteItem(data[index][1]);
                                    //         },
                                    //         child: Container(
                                    //           decoration: BoxDecoration(
                                    //               // color: Colors.red,
                                    //               borderRadius:
                                    //                   BorderRadius.circular(5)),
                                    //           width: 40,
                                    //           height: 40,
                                    //           child: Center(
                                    //             child: Icon(
                                    //               Icons.delete,
                                    //               color: Colors.red,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       )
                                    //     ],
                                    //   ),
                                    // );
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
                      // width: double.infinity,
                      // height: mediaQuery.height * 1 / 10,
                      // color: Colors.red,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              // width: mediaQuery.width * 7 / 10,
                              // height: mediaQuery.height * 0.7 / 10,
                              child: TextFormField(
                                // textAlignVertical: TextAlignVertical.bottom,
                                controller: messageController,
                                onChanged: (text) {
                                  message = text;
                                  print('object');
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
                                print(search_result.length.toString() +
                                    '*/*/**/*/*/*/*/*/*');
                                String formattedDate =
                                    DateFormat('dd MMM yyyy hh:mm:ss a')
                                        .format(DateTime.now());
                                if (messageController.text != '') {
                                  if (edit == false) {
                                    if (data.length == 0) {
                                      print('data.length = 0');
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      print('ahmed 1');
                                      data.add(
                                          [message, 1, false, formattedDate]);
                                      slidableControllers
                                          .add(SlidableController(this));
                                      // data[0][0] = message;
                                      // data[0][1] = 1;
                                      // data[0][2] = false;
                                      // selected.add(false);
                                      print('ahmed 2');
                                      String jsonString = jsonEncode(data);
                                      // prefs.setStringList(
                                      //     "data", data.cast<String>());
                                      prefs.setString("data", jsonString);
                                      print('ahmed 3');
                                      print('data: ' + data.toString());
                                      // count++;
                                      // prefs.setInt("count", count);
                                    } else {
                                      print('data.length not = 0');
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      data.sort((a, b) => a[1].compareTo(b[1]));
                                      data.add([
                                        message,
                                        data[data.length - 1][1] + 1,
                                        false,
                                        formattedDate
                                      ]);
                                      print('data1: ' + data.toString());
                                      data.sort((a, b) => b[3].compareTo(a[3]));
                                      print('data2: ' + data.toString());
                                      slidableControllers
                                          .add(SlidableController(this));
                                      // slidableControllers
                                      //     .add(SlidableController(this));
                                      // data[[message, 1 , false],[message, 2 , false],[message, 3 , false]]
                                      //                0                    1                    2
                                      // data[data.length][0].add(message);
                                      // data[data.length][1]
                                      //     .add(data[data.length - 1][1] + 1);
                                      // data[data.length][2].add(false);
                                      // data.add(message);
                                      // selected.add(false);
                                      String jsonString = jsonEncode(data);
                                      // prefs.setStringList(
                                      //     "data", data.cast<String>());
                                      prefs.setString("data", jsonString);
                                      // prefs.setStringList(
                                      //     "data", data.cast<String>());
                                      // count++;
                                      // prefs.setInt("count", count);
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
                                      print('data editted: ' +
                                          data[(data.indexWhere((element) =>
                                              element[1] ==
                                              edit_message_number))][0]);
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
                                      print('formattedDate: ' + formattedDate);
                                      // data.add([
                                      //   message,
                                      //   data[data.length - 1][1] + 1,
                                      //   false
                                      // ]);
                                      // slidableControllers
                                      //     .add(SlidableController(this));
                                      // data[[message, 1 , false],[message, 2 , false],[message, 3 , false]]
                                      //                0                    1                    2
                                      // data[data.length][0].add(message);
                                      // data[data.length][1]
                                      //     .add(data[data.length - 1][1] + 1);
                                      // data[data.length][2].add(false);
                                      // data.add(message);
                                      // selected.add(false);
                                      String jsonString = jsonEncode(data);
                                      // prefs.setStringList(
                                      //     "data", data.cast<String>());
                                      prefs.setString("data", jsonString);
                                      setState(() {
                                        messageController.clear();
                                        message = "";
                                        print('data editted');
                                      });
                                    } else {
                                      messageController.clear();
                                    }
                                  }
                                  //  test();
                                }
                                print('data 10 befor sort: ' + data.toString());
                                data.sort((a, b) => b[3].compareTo(a[3]));
                                print('data 10 after sort: ' + data.toString());
                                print('index number: ' + data.last[0]);
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
