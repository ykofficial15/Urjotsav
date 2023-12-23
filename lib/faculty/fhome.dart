import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../color.dart';

class Fhome extends StatefulWidget {
  @override
  _FhomeState createState() => _FhomeState();
}

class _FhomeState extends State<Fhome> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? _image;
  String? _selectedEvent;
  late String ename, eorganizers, edescription, etype, edate;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  void _submitForm() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        //------------------------------------------------------------ Event Launched

        // Upload image to Firebase Storage
        final Reference ref =
            _storage.ref().child('event_images/${DateTime.now().toString()}');
        await ref.putFile(_image!);
        final String imageUrl = await ref.getDownloadURL();
        // Save form data to Firestore
        firestore.collection('Events').add({
          'eventName': ename,
          'eventDescription': edescription,
          'eventType': etype,
          'eventDate': edate,
          'uid': uid,
          'eventOrganizers': eorganizers,
          'image_url': imageUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event Launched Successfully!')),
        );

        Fluttertoast.showToast(
          msg: 'Event Launched',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        // Clear form fields after successful submission
        _formKey.currentState!.reset();
        setState(() {
          _image = null;
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Failed To Launch!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Error saving data: $e');
      Fluttertoast.showToast(
        msg: 'Error saving data',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

//-----------------------------------------------------------------------------------Image Picker
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Please add image',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //-------------------------------------------------------------------------------------------------------- Header
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //-------------------------------------------------------------------------------------- Add Event Heading

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(13, 0, 0, 255),
                ),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                alignment: Alignment.center,
                width: (MediaQuery.of(context).size.width),
                child: Text('ADD EVENT',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              //----------------------------------------------------------------------------------------------- Event Name
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Event Name',
                  hintText: 'Enter Your Event Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the event name';
                  }
                  return null;
                },
                onSaved: (value) => ename = value!,
              ),
              //------------------------------------------------------------------------------------ Event Type
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                borderRadius: BorderRadius.circular(15),
                icon: Icon(Icons.arrow_drop_down_circle_rounded,
                    color: AppColors.blueYogx),
                dropdownColor: AppColors.whiteYogx,
                value: _selectedEvent,
                items: [
                  DropdownMenuItem(
                    child: Text('Cultural'),
                    value: 'Cultural',
                  ),
                  DropdownMenuItem(
                    child: Text('Technical'),
                    value: 'Technical',
                  ),
                  DropdownMenuItem(
                    child: Text('Sports'),
                    value: 'Sports',
                  ),
                  DropdownMenuItem(
                    child: Text('General'),
                    value: 'General',
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedEvent = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select event type';
                  }
                  return null;
                },
                onSaved: (value) => etype = value!,
                decoration: InputDecoration(
                  labelText: 'Event Type',
                  hintText: 'Select Event Type',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
//---------------------------------------------------------------------------------------------------- Event Organizers
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Organizers',
                  hintText: 'Enter Event Organizers Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter event organizers name';
                  }
                  return null;
                },
                onSaved: (value) => eorganizers = value!,
              ),
              //------------------------------------------------------------------------------ Event Date
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'DD/MM/YYYY',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter event date';
                  }
                  return null;
                },
                onSaved: (value) => edate = value!,
              ),
              //----------------------------------------------------------------------------------------------- Event Description
              SizedBox(
                height: 20,
              ),
              TextFormField(
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Explain About Event',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter event description';
                  }
                  return null;
                },
                onSaved: (value) => edescription = value!,
              ),
              SizedBox(
                height: 15,
              ),
              //--------------------------------------------------------------------------------------------- Event Poster
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: _pickImage,
                child: _image != null
                    ? Image.file(_image!)
                    : Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            color: Color.fromARGB(108, 79, 176, 255),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Icon(
                          Icons.add_photo_alternate_rounded,
                          size: 50,
                        )),
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: Text('Launch Event'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
