import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AddFutsalScreen extends StatefulWidget {
  @override
  _AddFutsalScreenState createState() => _AddFutsalScreenState();
}

class _AddFutsalScreenState extends State<AddFutsalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _slotsController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;
  List<File> _imageFiles = [];
  String? _location;
  String? _adminUid;

  @override
  void initState() {
    super.initState();
    _getAdminLocation();
  }

  // Fetch admin location from Firestore
  Future<void> _getAdminLocation() async {
    try {
      final user = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid);
      final userDoc = await user.get();
      setState(() {
        _location = userDoc['location'];
        _adminUid = FirebaseAuth.instance.currentUser?.uid;
      });
    } catch (e) {
      print('Error fetching admin location: $e');
    }
  }

  // Image picker to select multiple images
  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _imageFiles = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  // Upload multiple images to imgBB
  Future<List<String>> _uploadImages(List<File> images) async {
    List<String> imageUrls = [];
    try {
      for (var image in images) {
        final uri = Uri.parse("https://api.imgbb.com/1/upload?key=431e010fb1591bffe80f792f64ce75b6");
        var request = http.MultipartRequest('POST', uri);
        request.files.add(await http.MultipartFile.fromPath('image', image.path));

        final response = await request.send();
        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final jsonResponse = json.decode(responseData);
          imageUrls.add(jsonResponse['data']['url']);
        } else {
          print('Error uploading image: ${response.reasonPhrase}');
        }
      }
    } catch (e) {
      print('Error uploading images: $e');
    }
    return imageUrls;
  }

  // Add futsal to Firestore with location and multiple images
  Future<void> _addFutsal() async {
    if (!_formKey.currentState!.validate() || _imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields and select images')),
      );
      return;
    }

    if (_adminUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Admin is not authenticated')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Check if the admin already has a futsal added
      final futsalSnapshot = await FirebaseFirestore.instance
          .collection('futsals')
          .where('adminUid', isEqualTo: _adminUid)
          .get();

      if (futsalSnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You can only add one futsal')),
        );
        return;
      }

      // Upload images
      final imageUrls = await _uploadImages(_imageFiles);

      // Add futsal to Firestore
      await FirebaseFirestore.instance.collection('futsals').add({
        'name': _nameController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'slots': int.parse(_slotsController.text.trim()),
        'location': _location,
        'adminUid': _adminUid,
        'images': imageUrls,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Futsal added successfully')),
      );

      // Reset the form
      _formKey.currentState!.reset();
      setState(() {
        _imageFiles.clear();
      });
    } catch (e) {
      print('Error adding futsal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding futsal')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Futsal'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Futsal Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter futsal name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _slotsController,
                  decoration: InputDecoration(labelText: 'Slots'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter slots';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _imageFiles.isNotEmpty
                    ? GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _imageFiles.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      _imageFiles[index],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    );
                  },
                )
                    : Text('No images selected'),
                ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: Icon(Icons.image),
                  label: Text('Select Images'),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _addFutsal,
                  child: Text('Add Futsal'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
