import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class EditFutsalScreen extends StatefulWidget {
  const EditFutsalScreen({Key? key}) : super(key: key);

  @override
  _EditFutsalScreenState createState() => _EditFutsalScreenState();
}

class _EditFutsalScreenState extends State<EditFutsalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _slotsController = TextEditingController();

  List<String> _currentImageUrls = [];
  List<File> _newImages = [];
  bool _isLoading = false;
  String? _futsalId;

  @override
  void initState() {
    super.initState();
    _loadFutsalData();
  }

  // Fetch futsalId from Firestore for the currently logged-in user
  Future<void> _loadFutsalData() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Query Firestore to get futsalId related to the current user
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          // Assuming each user has a futsalId field
          setState(() {
            _futsalId = userDoc.data()?['futsalId'];  // Adjust this according to your DB structure
          });

          if (_futsalId != null) {
            // Load futsal details after fetching futsalId
            _loadFutsalDetails(_futsalId!);
          }
        }
      }
    } catch (e) {
      print('Error fetching futsal data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching futsal data')),
      );
    }
  }

  // Load futsal details from Firestore using the futsalId
  Future<void> _loadFutsalDetails(String futsalId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('futsals')
          .doc(futsalId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _nameController.text = data['name'];
          _priceController.text = data['price'].toString();
          _slotsController.text = data['slots'].toString();
          _currentImageUrls = List<String>.from(data['images'] ?? []);
        });
      }
    } catch (e) {
      print('Error loading futsal data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading futsal data')),
      );
    }
  }

  // Pick new images to update
  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _newImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  // Upload new images to imgBB and return URLs
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

  // Save changes to Firestore
  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<String> updatedImageUrls = _currentImageUrls;

      // If there are new images, upload them
      if (_newImages.isNotEmpty) {
        final newImageUrls = await _uploadImages(_newImages);
        updatedImageUrls.addAll(newImageUrls);
      }

      // Update the futsal in Firestore
      await FirebaseFirestore.instance.collection('futsals').doc(_futsalId).update({
        'name': _nameController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'slots': int.parse(_slotsController.text.trim()),
        'images': updatedImageUrls,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Futsal updated successfully')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      print('Error saving futsal changes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving futsal changes')),
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
        title: const Text('Edit Futsal'),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Futsal Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter futsal name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
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
                  decoration: const InputDecoration(labelText: 'Slots'),
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
                const SizedBox(height: 16),
                Text('Current Images', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _currentImageUrls.isNotEmpty
                    ? GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _currentImageUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      _currentImageUrls[index],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    );
                  },
                )
                    : const Text('No images available'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.image),
                  label: const Text('Add New Images'),
                ),
                const SizedBox(height: 20),
                _newImages.isNotEmpty
                    ? GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _newImages.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      _newImages[index],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    );
                  },
                )
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
