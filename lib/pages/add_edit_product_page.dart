import 'package:flutter/material.dart';
import 'package:max_shop/providers/product_provider.dart' show Product;

class AddEditProductPage extends StatefulWidget {
  static const routeName = '/add-edit-product';

  @override
  _AddEditProductPageState createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  // Interact with the state behind the form widget using the GlobalKey
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    // show url image when field loses focus
    if (!_imageUrlFocusNode.hasFocus) {
      // _validateImageUrl(_imageUrlController.text);
      setState(() {});
    }
  }

  String _validateImageUrl(String imageUrl) {
    if (imageUrl.isEmpty) {
      return 'Please enter an image URL.';
    }

    if (!imageUrl.startsWith('http') || !imageUrl.startsWith('https')) {
      return 'Please enter a valid URL.';
    }

    if (!imageUrl.endsWith('.png') ||
        !imageUrl.endsWith('.jpg') ||
        !imageUrl.endsWith('.jpeg')) {
      return 'Please enter a valid image URL.';
    }

    return null;
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
  }

  @override
  void dispose() {
    // dispose focus nodes to avoid memory leaks
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a value.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: value,
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: null,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a price.';
                    }

                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }

                    if (double.parse(value) <= 0) {
                      return 'Price should be greater than 0.';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      price: double.parse(value),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: null,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a value.';
                    }

                    if (value.length < 10) {
                      return 'Should be at least 10 characters long';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: value,
                      imageUrl: _editedProduct.imageUrl,
                      id: null,
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      margin: EdgeInsets.only(top: 8.0, right: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        enableInteractiveSelection: true,
                        // Set empty state to rebuild the page because
                        // the latest image url was not picked up for the image
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onFieldSubmitted: (_) => _saveForm(),
                        validator: _validateImageUrl,
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: value,
                            id: null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* When working with Forms, you typically have multiple input fields above each other - that's why you might want to
 * ensure that the list of inputs is scrollable. Especially, since the soft keyboard will also take up some space on the screen.
 *
 * For very long forms (i.e. many input fields) OR in landscape mode (i.e. less vertical space on the screen), you might encounter
 * a strange behavior: User input might get lost if an input fields scrolls out of view.
 *
 * That happens because the ListView widget dynamically removes and re-adds widgets as they scroll out of and back into view.
 *
 * For short lists/ portrait-only apps, where only minimal scrolling might be needed, a ListView should be fine, since items
 * won't scroll that far out of view (ListView has a certain threshold until which it will keep items in memory).
 * But for longer lists or apps that should work in landscape mode as well - or maybe just to be safe - you might want to use
 * a Column (combined with SingleChildScrollView) instead. Since SingleChildScrollView doesn't clear widgets that scroll out of
 * view, you are not in danger of losing user input in that case.
* */
