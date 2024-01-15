import 'package:flutter/material.dart';
import 'package:appssimaru/model/booking.dart';
import 'package:appssimaru/screens/booking/booking_add.dart';
import 'package:appssimaru/screens/booking/booking_edit.dart';
import 'package:appssimaru/core/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingScreen extends StatefulWidget {
  @override
  BookingsScreenState createState() => BookingsScreenState();
}

class BookingsScreenState extends State<BookingScreen> {
  final ApiClient _apiClient = ApiClient();
  String accesstoken = '';

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  _loadToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var data = localStorage.getString('accessToken');

    if (data != null) {
      setState(() {
        accesstoken = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _apiClient.getBookingData(accesstoken),
          builder: (BuildContext context, AsyncSnapshot<List<Booking>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Something wrong with message: ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<Booking>? bookings = snapshot.data;
              return _buildListView(bookings ?? []);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookingAddScreen())),
      ),
    );
  }

  Widget _buildListView(List<Booking> bookings) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Booking booking = bookings[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'User ID: ${booking.user_id}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text('Ruangan ID: ${booking.ruangan_id}'),
                    Text('Start Book: ${booking.start_book.toLocal()}'),
                    Text('End Book: ${booking.end_book.toLocal()}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Warning"),
                                  content: Text(
                                    "Are you sure want to delete booking data for user ID ${booking.user_id}?"
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Yes"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _apiClient.delBooking(accesstoken, booking.id).then((isSuccess) {
                                          if (isSuccess) {
                                            setState(() {});
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text("Delete booking data success"),
                                            ));
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text("Delete booking data failed"),
                                            ));
                                          }
                                        });
                                      },
                                    ),
                                    TextButton(
                                      child: Text("No"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BookingEditScreen(booking: booking)),
                            );
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: bookings.length,
      ),
    );
  }
}
