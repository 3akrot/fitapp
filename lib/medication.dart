// lib/medication.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Import for TimeOfDay
// Added for CupertinoAlertDialog
// Added for TimePickerMode

class MedicationAlarmScreen extends StatefulWidget {
  const MedicationAlarmScreen({super.key});

  @override
  _MedicationAlarmScreenState createState() => _MedicationAlarmScreenState();
}

class _MedicationAlarmScreenState extends State<MedicationAlarmScreen> {
  final _formKey = GlobalKey<FormState>();
  String _medicationName = '';
  String _frequency = 'Once a day';
  List<dynamic> medicationAlarms = [];
  late List<TimeOfDay> _medicationTimes = [
    TimeOfDay.now()
  ]; // Initialize with current time

  @override
  void initState() {
    super.initState();
    // Retrieve medication alarms from Firestore
    _retrieveMedicationAlarms();
  }

  Future<void> _retrieveMedicationAlarms() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('medicationAlarms')) {
        var medicationAlarmsData = userData['medicationAlarms'];

        if (medicationAlarmsData != null) {
          setState(() {
            medicationAlarms = List.from(medicationAlarmsData);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    title: const Text(
      'Supplement Reminder',
      style: TextStyle(
        color: Colors.white, // Set text color to white
      ),
    ),
    backgroundColor: const Color(0xFF1a2543),
    iconTheme: const IconThemeData(
      color: Colors.white, // Set back arrow color to white
    ),
  ),
    backgroundColor: const Color(0xFF1a2543),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),

       Padding(
         padding: const EdgeInsets.all(10.0),
         child: ClipRRect(
           borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
           child: Image.asset(
             'assets/pills.png',
             height: 200,
             fit: BoxFit.cover,
           ),
         ),
       ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: () {
                  _showAddMedicationModal(context);
                },
                style: ElevatedButton.styleFrom(
                  // backgroundColor:
                  //     Colors.transparent, // Make button background transparent
                  elevation: 0, // Remove button elevation
                  textStyle: const TextStyle(color: Colors.blue), // Text color
                ),
                child:const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add), // Plus icon
                    SizedBox(width: 8), // Add some space between the icon and text
                    Text('Add Medication'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: medicationAlarms.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> medicationAlarm = medicationAlarms[index];
                var medicationTimes = medicationAlarm['medicationTimes'];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                     color: Colors.blue[50],
                    border: Border.all(color: const Color.fromARGB(255, 13, 14, 15)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                              Row(
                                children: [
                                  const Icon(Icons.medication),
                                  const SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      medicationAlarm['medicationName'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteMedication(index);
                            },
                          ),
                        ],
                      ),
                          const SizedBox(width: 8),
                      const Text(
                        'Times',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 8,
                        children: medicationTimes != null
                            ? (medicationTimes as List)
                                .map<Widget>((time) => Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(255, 95, 103, 110), // Replace with your desired color
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        time,
                                        style: const TextStyle(fontSize: 16, color: Colors.white), // Replace with your desired text style
                                      ),
                                    ))
                                .toList()
                            : [],
                      ),
                      
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMedicationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Medication Name',
                    style: TextStyle(fontSize: 18),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a medication name';
                      }
                      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return 'Medication name must be a valid string';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _medicationName = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter medication name',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Frequency',
                    style: TextStyle(fontSize: 18),
                  ),
                  DropdownButton<String>(
                    value: _frequency,
                    onChanged: (value) {
                      setState(() {
                        _frequency = value!;
                        if (_frequency == 'Twice a day') {
                          _medicationTimes = [
                            const TimeOfDay(hour: 8, minute: 0),
                            const TimeOfDay(hour: 20, minute: 0)
                          ]; // Set two times for medication
                        } else {
                          _medicationTimes = [TimeOfDay.now()];
                        }
                      });
                    },
                    items: <String>['Once a day', 'Twice a day']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Medication Times',
                    style: TextStyle(fontSize: 18),
                  ),
                  Column(
                    children: _medicationTimes.map((time) {
                      return Row(
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              child: Text(
                                '${time.hour}:${time.minute}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              onPressed: () async {
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: time,
                                );
                                if (picked != null) {
                                  setState(() {
                                    _medicationTimes[_medicationTimes
                                        .indexOf(time)] = picked;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          String userId =
                              FirebaseAuth.instance.currentUser!.uid;
                          List<String> medicationTimes = _medicationTimes
                              .map((time) => '${time.hour}:${time.minute}')
                              .toList();

                          Map<String, dynamic> medicationAlarmData = {
                            'medicationName': _medicationName,
                            'medicationTimes': medicationTimes,
                            'frequency': _frequency,
                          };

                          try {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(userId)
                                .update({
                              'medicationAlarms':
                                  FieldValue.arrayUnion([medicationAlarmData]),
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Medication alarm set successfully!'),
                              ),
                            );
                            
                            Navigator.pop(context);
                            _retrieveMedicationAlarms();
                          } catch (e) {
                            print('Error setting medication alarm: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Failed to set medication alarm. Please try again later.'),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Add Medication'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

void _deleteMedication(int index) async {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'medicationAlarms': FieldValue.arrayRemove([medicationAlarms[index]]),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medication deleted successfully!'),
      ),
    );
    
    // Update the medication alarms list in the state
    setState(() {
      medicationAlarms.removeAt(index);
    });
  } catch (e) {
    print('Error deleting medication: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to delete medication. Please try again later.'),
      ),
    );
  }
}

}
