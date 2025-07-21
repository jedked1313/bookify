import 'package:bookify/models/book_model.dart';
import 'package:bookify/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageBookScreen extends StatefulWidget {
  const ManageBookScreen({super.key, this.book});
  final Book? book;

  @override
  State<ManageBookScreen> createState() => _ManageBookScreenState();
}

class _ManageBookScreenState extends State<ManageBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();

  @override
  void initState() {
    if (widget.book != null) {
      _titleCtrl.text = widget.book!.title;
      _authorCtrl.text = widget.book!.author;
      _descCtrl.text = widget.book!.description;
      _imageCtrl.text = widget.book!.imageUrl;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bookProvider = Provider.of<BookProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? "Add Book" : "Edit Book"),
        actions: [
          if (widget.book != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await bookProvider.deleteBook(widget.book!.id);
                Navigator.pop(context);
              },
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a title" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _authorCtrl,
                decoration: const InputDecoration(labelText: "Author"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter an author" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _imageCtrl,
                decoration: const InputDecoration(labelText: "Image URL"),
              ),
              const SizedBox(height: 10),
              Text("Rating: ${bookProvider.rating.toStringAsFixed(1)}"),
              Slider(
                value: bookProvider.rating,
                onChanged: (value) => bookProvider.setRating(value),
                min: 1,
                max: 5,
                divisions: 8,
              ),
              SwitchListTile(
                title: const Text("Available"),
                value: bookProvider.isAvailable,
                onChanged: (val) => bookProvider.checkAvailablity(val),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => bookProvider.saveBook(
                  context,
                  _formKey,
                  widget.book,
                  titleCtrl: _titleCtrl,
                  authorCtrl: _authorCtrl,
                  descCtrl: _descCtrl,
                  imageCtrl: _imageCtrl,
                ),
                child: const Text("Save Book"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
