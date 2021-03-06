import 'package:flutter/material.dart';
import 'package:flutterapp/bookReservation.dart';
import 'package:flutterapp/placeOrder.dart';
import 'package:flutterapp/booking.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterapp/room.dart';
import 'package:intl/intl.dart';
import 'package:flutterapp/reservation.dart';

class ReviewDetails extends StatefulWidget {
  ReviewDetails({Key key, this.userId}) : super(key: key);

  final String userId;

  @override
  _ReviewDetails createState() => _ReviewDetails();
}

//This screen will layout all the information about the
//user's booking. The info from dates selected, check in/out
//times, and contact info will all be shown in a scrollable
//screen to be able for the user to verify the data and
//place the final order
//Widgets follow a row format
//For example each row looks like "Name: Joe Smith"
class _ReviewDetails extends State<ReviewDetails> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    List<DateTime> selectedDates = dates();
    List<int> chosenRooms = chosen();
    // print("Chosen Rooms: ${chosenRooms.length}");

//    void roomsPerDay(var dayOfYear) async {
//      DataSnapshot roomsInDatabase;
//      roomsInDatabase = await _database
//          .reference()
//          .child("calendar")
//          .child("Days")
//          .child(dayOfYear)
//          .child("Room Numbers")
//          .once();
//
//      List<dynamic> rooms = roomsInDatabase.value;
//
//      print("Rooms from database in review details on $dayOfYear: $rooms");
//    }

    void createReservation() {
      Reservation reservation = Reservation(DateFormat.yMMMd().format(selectedDates.first), 
                                            DateFormat.yMMMd().format(selectedDates.last));

      String range = DateFormat.yMMMd().format(selectedDates.first) +
                      " - " + DateFormat.yMMMd().format(selectedDates.last);

      for (int i = 0; i < chosenRooms.length; ++i) {
        _database
            .reference()
            .child("account")
            .child(widget.userId)
            .child("reservations")
            .child(range)
            .child("roomNums")
            .child(chosenRooms[i].toString())
            .update(reservation.toJson());
      }
    }

    void bookRoom() {
      for (int i = 0; i < selectedDates.length; ++i) {
        var dayOfYear = new DateFormat.yMMMd().format(selectedDates[i]);
        for (int j = 0; j < chosenRooms.length; ++j) {
          Room temp =
              Room(false, getCheckInTime(), getCheckOutTime(), chosenRooms[j]);
          _database
              .reference()
              .child("calendar")
              .child("Days")
              .child(dayOfYear)
              .child("Room Numbers")
              .child(chosenRooms[j].toString())
              .update(temp.toJson());
        }
//        roomsPerDay(dayOfYear);
      }
      createReservation();
      clearChosenRooms();
      chosenRooms.clear();
    }

    double spacing = 56;
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context, false),
                ),
                title: Text('Confirmation')),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.05),
                    child: Center(
                        child: Text('Review Details',
                            style: TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold)))),
                Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Name: ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(getFirstName() + ' ' + getLastName(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ))
                            ]),
                        Text(
                          '',
                          style: TextStyle(fontSize: spacing),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Phone Number: ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(getPhoneNumber(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ))
                            ]),
                        Text(
                          '',
                          style: TextStyle(fontSize: spacing),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Email Address: ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(getEmailAddress(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ))
                            ]),
                        Text(
                          '',
                          style: TextStyle(fontSize: spacing),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Credit Card Info: ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(getCreditCard(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ))
                            ]),
                        Text(
                          '',
                          style: TextStyle(fontSize: spacing),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Selected Dates: \n\n',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(getDateRange(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ))
                            ]),
                        Text(
                          '',
                          style: TextStyle(fontSize: spacing),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Check In Time: ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(getCheckInTime(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ))
                            ]),
                        Text(
                          '',
                          style: TextStyle(fontSize: spacing),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Check Out Time: ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(getCheckOutTime(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ))
                            ]),
                        Text(
                          '',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.15),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.075,
                            child: RaisedButton(
                                color: Colors.lightBlue,
                                elevation: 10.0,
                                child: Text("Confirm Order",
                                    style: TextStyle(fontSize: 24)),
                                onPressed: () {
                                  bookRoom();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlaceOrder()),
                                  );
                                })),
                      ],
                    ))
              ],
            ))));
  }
}
