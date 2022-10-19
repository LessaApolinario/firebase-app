import 'package:flutter/material.dart';

class Product extends StatefulWidget {
  const Product({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.edit,
    required this.delete,
  });

  final String title;
  final String price;
  final String description;
  final void Function()? edit;
  final void Function()? delete;

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004346),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "R\$ ${widget.price.replaceAll('.', ',')}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF004346),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: widget.edit,
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xFF004346),
                        size: 22,
                      ),
                    ),
                    IconButton(
                      onPressed: widget.delete,
                      icon: const Icon(
                        Icons.delete,
                        color: Color(0xFF004346),
                        size: 22,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Color(0xFF004346),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
