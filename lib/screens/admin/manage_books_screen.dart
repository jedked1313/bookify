import 'package:bookify/models/book_model.dart';
import 'package:bookify/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ManageBookScreen extends StatefulWidget {
  final Book? book;

  const ManageBookScreen({super.key, this.book});

  @override
  State<ManageBookScreen> createState() => _ManageBookScreenState();
}

class _ManageBookScreenState extends State<ManageBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  double _rating = 3.0;
  bool _isAvailable = true;

  @override
  void initState() {
    if (widget.book != null) {
      _titleCtrl.text = widget.book!.title;
      _authorCtrl.text = widget.book!.author;
      _descCtrl.text = widget.book!.description;
      _imageCtrl.text = widget.book!.imageUrl;
      _rating = widget.book!.rating;
      _isAvailable = widget.book!.isAvailable;
    }
    super.initState();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<BookProvider>(context, listen: false);

    final newBook = Book(
      id: widget.book?.id ?? const Uuid().v4(),
      title: _titleCtrl.text.trim(),
      author: _authorCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      imageUrl: _imageCtrl.text.trim(),
      rating: _rating,
      isAvailable: _isAvailable,
    );

    if (widget.book == null) {
      provider.addBook(newBook);
    } else {
      provider.updateBook(newBook);
    }

    Navigator.pop(context);
  }

  void _delete() {
    if (widget.book != null) {
      Provider.of<BookProvider>(context, listen: false).deleteBook(widget.book!.id);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? "Add Book" : "Edit Book"),
        actions: [
          if (widget.book != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _delete,
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
              TextFormField(
                controller: _authorCtrl,
                decoration: const InputDecoration(labelText: "Author"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter an author" : null,
              ),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              TextFormField(
                controller: _imageCtrl,
                decoration: const InputDecoration(labelText: "Image URL"),
              ),
              const SizedBox(height: 10),
              Text("Rating: ${_rating.toStringAsFixed(1)}"),
              Slider(
                value: _rating,
                onChanged: (value) => setState(() => _rating = value),
                min: 1,
                max: 5,
                divisions: 8,
              ),
              SwitchListTile(
                title: const Text("Available"),
                value: _isAvailable,
                onChanged: (val) => setState(() => _isAvailable = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: const Text("Save Book"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
