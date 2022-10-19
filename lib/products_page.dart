import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/widgets/product.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text('Create'),
                onPressed: () async {
                  final String title = _titleController.text;
                  final double? price = double.tryParse(_priceController.text);
                  final String description = _descriptionController.text;
                  if (price != null) {
                    await _products.add({
                      "title": title,
                      "price": price,
                      "description": description,
                    });

                    _titleController.text = '';
                    _priceController.text = '';
                    _descriptionController.text = '';
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _titleController.text = documentSnapshot['title'];
      _priceController.text = documentSnapshot['price'].toString();
      _descriptionController.text = documentSnapshot['description'];
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text('Update'),
                onPressed: () async {
                  final String title = _titleController.text;
                  final double? price = double.tryParse(_priceController.text);
                  final String description = _descriptionController.text;
                  if (price != null) {
                    await _products.doc(documentSnapshot!.id).update({
                      "title": title,
                      "price": price,
                      "description": description,
                    });
                    _titleController.text = '';
                    _priceController.text = '';
                    _descriptionController.text = '';
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _delete(String productId) async {
    await _products.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have successfully deleted a product'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004346),
      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];

                return Product(
                  title: documentSnapshot['title'],
                  price: documentSnapshot['price'].toString(),
                  description: documentSnapshot['description'],
                  edit: () => _update(documentSnapshot),
                  delete: () => _delete(documentSnapshot.id),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Color(0xFF004346),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
