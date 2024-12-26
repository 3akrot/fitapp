// lib/day-view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthapp/food_track_task.dart';
import 'calorie-stats.dart';
import 'package:provider/provider.dart';
import 'package:healthapp/database.dart';
import 'dart:math';
import 'package:healthapp/theme_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DayViewScreen extends StatefulWidget {
  const DayViewScreen({super.key});@override
  State<StatefulWidget> createState() {
    return _DayViewState();
  }
}class _DayViewState extends State<DayViewScreen> {
  String title = 'Add Food';
  double servingSize = 0;
  String dropdownValue = 'grams';
  DateTime _value = DateTime.now();
  DateTime today = DateTime.now();
  Color _rightArrowColor = const Color(0xffC1C1C1);
  final Color _leftArrowColor = const Color(0xffC1C1C1);
  final _addFoodKey = GlobalKey<FormState>();DatabaseService databaseService = DatabaseService(
      uid: FirebaseAuth.instance.currentUser!.uid, currentDate: DateTime.now());late FoodTrackTask addFoodTrack;@override
  void initState() {
    super.initState();
    addFoodTrack = FoodTrackTask(
        food_name: "",
        calories: 0,
        carbs: 0,
        protein: 0,
        fat: 0,
        mealTime: "",
        createdOn: _value,
        grams: 0);
    databaseService.getFoodTrackData(FirebaseAuth.instance.currentUser!.uid);
  }
  void resetFoodTrack() {
    addFoodTrack = FoodTrackTask(
        food_name: "",
        calories: 0,
        carbs: 0,
        protein: 0,
        fat: 0,
        mealTime: "",
        createdOn: _value,
        grams: 0);
  }Widget _calorieCounter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 1.5,
            ))),
        height: 220,
        child: Row(
          children: <Widget>[
            CalorieStats(datePicked: _value),
          ],
        ),
      ),
    );
  }Widget _addFoodButton() {
    return IconButton(
      icon: const Icon(Icons.add_box),
      iconSize: 25,
      color: const Color.fromARGB(255, 32, 87, 206),
      onPressed: () async {
        setState(() {});
        _showFoodToAdd(context);
      },
    );
  }Future _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _value,
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xff5FA55A), //Head background
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _value = picked);
    _stateSetter();
  }void _stateSetter() {
    if (today.difference(_value).compareTo(const Duration(days: 1)) == -1) {
      setState(() => _rightArrowColor = const Color(0xffEDEDED));
    } else {
      setState(() => _rightArrowColor = Colors.white);
    }
  }checkFormValid() {
    print(addFoodTrack.calories);
print(addFoodTrack.carbs);
print(addFoodTrack.protein);
print(addFoodTrack.fat);
print(addFoodTrack.grams);

if (addFoodTrack.food_name.isNotEmpty &&
    RegExp(r'^[a-zA-Z\s]+$').hasMatch(addFoodTrack.food_name) &&
    addFoodTrack.calories != 0 &&
    addFoodTrack.carbs != 0 &&
    addFoodTrack.protein != 0 &&
    addFoodTrack.fat != 0 &&
    addFoodTrack.grams != 0) {
  return true;
}
return false;

  }_showFoodToAdd(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: _showAmountHad(),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context), // passing false
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (checkFormValid()) {
                    Navigator.pop(context);
                    var random = Random();
                    int randomMilliSecond = random.nextInt(1000);
                    addFoodTrack.createdOn = _value;
                    addFoodTrack.createdOn = addFoodTrack.createdOn
                        .add(Duration(milliseconds: randomMilliSecond));
                    databaseService.addFoodTrackEntry(addFoodTrack);
                    resetFoodTrack();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "Invalid form data!"),
                      backgroundColor: Color.fromARGB(255, 33, 82, 218),
                    ));
                  }
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }Widget _showAmountHad() {
    return Scaffold(
      body: Column(children: <Widget>[
        _showAddFoodForm(),
        showUserAmount(),
      ]),
    );
  }Widget _showAddFoodForm() {
    return Form(
      key: _addFoodKey,
      child: Column(children: [
        TextFormField(
          decoration: const InputDecoration(
              labelText: "Name *", hintText: "Please enter food name"),
          validator: (value) {
            if (value == null || value.isEmpty ) {
              return "Please enter the food name";
            }
            return null;
          },
          onChanged: (value) {
            addFoodTrack.food_name = value;// addFood.calories = value;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
              labelText: "Calories *",
              hintText: "Please enter a calorie amount"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a calorie amount";
            }
            return null;
          },
          keyboardType: TextInputType.number,
          onChanged: (value) {
            try {
              addFoodTrack.calories = int.parse(value);
            } catch (e) {
              // return "Please enter numeric values"
              addFoodTrack.calories = 0;
            }// addFood.calories = value;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
              labelText: "Carbs *", hintText: "Please enter a carbs amount"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a carbs amount";
            }
            return null;
          },
          keyboardType: TextInputType.number,
          onChanged: (value) {
            try {
              addFoodTrack.carbs = int.parse(value);
            } catch (e) {
              addFoodTrack.carbs = 0;
            }
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
              labelText: "Protein *",
              hintText: "Please enter a protein amount"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a calorie amount";
            }
            return null;
          },
          onChanged: (value) {
            try {
              addFoodTrack.protein = int.parse(value);
            } catch (e) {
              addFoodTrack.protein = 0;
            }
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
              labelText: "Fat *", hintText: "Please enter a fat amount"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a fat amount";
            }
            return null;
          },
          onChanged: (value) {
            try {
              addFoodTrack.fat = int.parse(value);
            } catch (e) {
              addFoodTrack.fat = 0;
            }
          },
        ),
        
      ]),
    );
  }
  Widget showUserAmount() {
    return Expanded(
      child: TextField(
          maxLines: 1,
          autofocus: true,
          decoration: const InputDecoration(
              labelText: 'Grams *',
              hintText: 'eg. 100',
              contentPadding: EdgeInsets.all(0.0)),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          onChanged: (value) {
            try {
              addFoodTrack.grams = int.parse(value);
            } catch (e) {
              addFoodTrack.grams = 0;
            }
            setState(() {
              servingSize = double.tryParse(value) ?? 0;
            });
          }),
    );
  }Widget _showDatePicker() {
    return SizedBox(
      width: 250,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_left, size: 25.0),
            color: _leftArrowColor,
            onPressed: () {
              setState(() {
                _value = _value.subtract(const Duration(days: 1));
                _rightArrowColor = Colors.white;
              });
            },
          ),
          TextButton(
            // textColor: Colors.white,
            onPressed: () => _selectDate(),
            // },
            child: Text(_dateFormatter(_value),
                style: const TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                )),
          ),
          IconButton(
              icon: const Icon(Icons.arrow_right, size: 25.0),
              color: _rightArrowColor,
              onPressed: () {
                if (today.difference(_value).compareTo(const Duration(days: 1)) ==
                    -1) {
                  setState(() {
                    _rightArrowColor = const Color(0xffC1C1C1);
                  });
                } else {
                  setState(() {
                    _value = _value.add(const Duration(days: 1));
                  });
                  if (today.difference(_value).compareTo(const Duration(days: 1)) ==
                      -1) {
                    setState(() {
                      _rightArrowColor = const Color(0xffC1C1C1);
                    });
                  }
                }
              }),
        ],
      ),
    );
  }
  String _dateFormatter(DateTime tm) {
    DateTime today = DateTime.now();
    Duration oneDay = const Duration(days: 1);
    Duration twoDay = const Duration(days: 2);
    String month;switch (tm.month) {
      case 1:
        month = "Jan";
        break;
      case 2:
        month = "Feb";
        break;
      case 3:
        month = "Mar";
        break;
      case 4:
        month = "Apr";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "Jun";
        break;
      case 7:
        month = "Jul";
        break;
      case 8:
        month = "Aug";
        break;
      case 9:
        month = "Sep";
        break;
      case 10:
        month = "Oct";
        break;
      case 11:
        month = "Nov";
        break;
      case 12:
        month = "Dec";
        break;
      default:
        month = "Undefined";
        break;
    }Duration difference = today.difference(tm);if (difference.compareTo(oneDay) < 1) {
      return "Today";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Yesterday";
    } else {
      return "${tm.day} $month ${tm.year}";
    }
  }@override
  Widget build(BuildContext context) {
    print(DatabaseService(
                  uid: FirebaseAuth.instance.currentUser!.uid, currentDate: DateTime.now())
              .foodTracks);
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _showDatePicker(),
                  _addFoodButton(),
                ],
              ),
            )),
        body: StreamProvider<List<FoodTrackTask>>.value(
          initialData: const [],
          value: DatabaseService(
                  uid: FirebaseAuth.instance.currentUser!.uid, currentDate: DateTime.now())
              .foodTracks,
          child: Column(children: <Widget>[
            _calorieCounter(),
            Expanded(
                child: ListView(
              children: <Widget>[FoodTrackList(datePicked: _value)],
            ))
          ]),
        ));
  }
}
class FoodTrackList extends StatelessWidget {
  final DateTime datePicked;
  const FoodTrackList({super.key, required this.datePicked});@override
  Widget build(BuildContext context) {
    final DateTime curDate =
        DateTime(datePicked.year, datePicked.month, datePicked.day);final foodTracks = Provider.of<List<FoodTrackTask>>(context);List findCurScans(List foodTrackFeed) {
      List curScans = [];
      for (var foodTrack in foodTrackFeed) {
        DateTime scanDate = DateTime(foodTrack.createdOn.year,
            foodTrack.createdOn.month, foodTrack.createdOn.day);
        if (scanDate.compareTo(curDate) == 0) {
          curScans.add(foodTrack);
        }
      }
      return curScans;
    }List curScans = findCurScans(foodTracks);
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: curScans.length + 1,
      itemBuilder: (context, index) {
        if (index < curScans.length) {
          return FoodTrackTile(foodTrackEntry: curScans[index]);
        } else {
          return const SizedBox(height: 5);
        }
      },
    );
  }
}
class FoodTrackTile extends StatelessWidget {
  final FoodTrackTask foodTrackEntry;
  DatabaseService databaseService = DatabaseService(
      uid: FirebaseAuth.instance.currentUser!.uid ,currentDate: DateTime.now());FoodTrackTile({super.key, required this.foodTrackEntry});List macros = CalorieStats.macroData;@override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser!.uid);
    return ExpansionTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: const Color(0xff5FA55A),
        child: itemCalories(),
      ),
      title: Text(foodTrackEntry.food_name,
          style: const TextStyle(
            fontSize: 16.0,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w500,
          )),
      subtitle: macroData(),
      children: <Widget>[
        expandedView(context),
      ],
    );
  }
  Widget itemCalories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(foodTrackEntry.calories.toStringAsFixed(0),
            style: const TextStyle(
              fontSize: 16.0,
              color: Color.fromARGB(255, 0, 0, 0),
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w500,
            )),
        const Text('kcal',
            style: TextStyle(
              fontSize: 10.0,
              color: Color.fromARGB(255, 0, 0, 0),
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }
  Widget macroData() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: Color(CARBS_COLOR),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(' ${foodTrackEntry.carbs.toStringAsFixed(1)}g    ',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      )),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: Color(PROTEIN_COLOR),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                      ' ${foodTrackEntry.protein.toStringAsFixed(1)}g    ',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      )),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: Color(FAT_COLOR),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(' ${foodTrackEntry.fat.toStringAsFixed(1)}g',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Color.fromARGB(255, 5, 5, 5),
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      )),
                ],
              ),
              Text('${foodTrackEntry.grams}g',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w300,
                  )),
            ],
          ),
        )
      ],
    );
  }Widget expandedView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 15.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          expandedHeader(context),
          _expandedCalories(),
          _expandedCarbs(),
          _expandedProtein(),
          _expandedFat(),
        ],
      ),
    );
  }Widget expandedHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('% of total',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
            )),
        IconButton(
            icon: const Icon(Icons.delete),
            iconSize: 16,
            onPressed: () async {
              print("Delete button pressed");
              databaseService.deleteFoodTrackEntry(foodTrackEntry);
            }),
      ],
    );
  }Widget _expandedCalories() {
    double caloriesValue = 0;
    if (!(foodTrackEntry.calories / macros[0]).isNaN) {
      caloriesValue = foodTrackEntry.calories / macros[0];
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: caloriesValue,
              backgroundColor: const Color(0xffEDEDED),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff5FA55A)),
            ),
          ),
          Text('      ${((caloriesValue) * 100).toStringAsFixed(0)}%'),
        ],
      ),
    );
  }Widget _expandedCarbs() {
    double carbsValue = 0;
    if (!(foodTrackEntry.carbs / macros[2]).isNaN) {
      carbsValue = foodTrackEntry.carbs / macros[2];
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: carbsValue,
              backgroundColor: const Color(0xffEDEDED),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffFA5457)),
            ),
          ),
          Text('      ${((carbsValue) * 100).toStringAsFixed(0)}%'),
        ],
      ),
    );
  }Widget _expandedProtein() {
    double proteinValue = 0;
    if (!(foodTrackEntry.protein / macros[1]).isNaN) {
      proteinValue = foodTrackEntry.protein / macros[1];
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: proteinValue,
              backgroundColor: const Color(0xffEDEDED),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffFA8925)),
            ),
          ),
          Text('      ${((proteinValue) * 100).toStringAsFixed(0)}%'),
        ],
      ),
    );
  }Widget _expandedFat() {
    double fatValue = 0;
    if (!(foodTrackEntry.fat / macros[3]).isNaN) {
      fatValue = foodTrackEntry.fat / macros[3];
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: (foodTrackEntry.fat / macros[3]),
              backgroundColor: const Color(0xffEDEDED),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff01B4BC)),
            ),
          ),
          Text('      ${((fatValue) * 100).toStringAsFixed(0)}%'),
        ],
      ),
    );
  }
}