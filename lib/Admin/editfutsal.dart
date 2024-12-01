import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class EditFutsalScreen extends StatefulWidget {
  @override
  _EditFutsalScreenState createState() => _EditFutsalScreenState();
}

class _EditFutsalScreenState extends State<EditFutsalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _slotsController = TextEditingController();

  List<File> _newImageFiles = [];
  List<String> _existingImageUrls = [];
  bool _isLoading = false;
  String? _futsalId;

  @override
  void initState() {
    super.initState();
    _fetchFutsalDetails();
  }

  Future<void> _fetchFutsalDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userUid = FirebaseAuth.instance.currentUser?.uid;
      if (userUid == null) throw Exception("Admin not authenticated");

      // Fetch the admin's futsal document
      final futsalSnapshot = await FirebaseFirestore.instance
          .collection('futsals')
          .where('adminUid', isEqualTo: userUid)
          .get();

      if (futsalSnapshot.docs.isEmpty) {
        throw Exception("No futsal found for this admin");
      }

      final futsalDoc = futsalSnapshot.docs.first;
      _futsalId = futsalDoc.id;

      // Populate fields with futsal data
      final data = futsalDoc.data();
      _nameController.text = data['name'] ?? '';
      _priceController.text = (data['price'] ?? '').toString();
      _slotsController.text = (data['slots'] ?? '').toString();
      _existingImageUrls = List<String>.from(data['images'] ?? []);
    } catch (e) {
      print('Error fetching futsal details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _newImageFiles = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<List<String>> _uploadImages(List<File> images) async {
    List<String> imageUrls = [];
    try {
      for (var image in images) {
        final uri = Uri.parse(
            "https://api.imgbb.com/1/upload?key=431e010fb1591bffe80f792f64ce75b6");
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

  Future<void> _updateFutsal() async {
    if (!_formKey.currentState!.validate() || _futsalId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload new images if any
      final newImageUrls = await _uploadImages(_newImageFiles);

      // Combine existing and new image URLs
      final updatedImageUrls = [..._existingImageUrls, ...newImageUrls];

      // Update futsal in Firestore
      await FirebaseFirestore.instance.collection('futsals').doc(_futsalId!).update({
        'name': _nameController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'slots': int.parse(_slotsController.text.trim()),
        'images': updatedImageUrls,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Futsal updated successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error updating futsal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating futsal')),
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
        backgroundColor: Colors.redAccent,
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
                _existingImageUrls.isNotEmpty
                    ? Wrap(
                  spacing: 8.0,
                  children: _existingImageUrls
                      .map((url) => Image.network(
                    url,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ))
                      .toList(),
                )
                    : const Text('No existing images'),
                const SizedBox(height: 16),
                _newImageFiles.isNotEmpty
                    ? GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _newImageFiles.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      _newImageFiles[index],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    );
                  },
                )
                    : const Text('No new images selected'),
                ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.image),
                  label: const Text('Select Images'),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _updateFutsal,
                  child: const Text('Update Futsal'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
