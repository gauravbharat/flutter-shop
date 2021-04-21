import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:max_shop/providers/products_provider.dart';
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

  bool _isInit = true;
  bool _isLoading = false;

  // Interact with the state behind the form widget using the GlobalKey
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  Map<String, dynamic> _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    super.initState();

    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };

        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
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

    // if (!imageUrl.endsWith('.png') ||
    //     !imageUrl.endsWith('.jpg') ||
    //     !imageUrl.endsWith('.jpeg')) {
    //   return 'Please enter a valid image URL.';
    // }

    return null;
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    final action = '${_editedProduct.id != null ? 'updated' : 'added'}';

    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product $action successfully!')));
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product $action successfully!')));

        Navigator.of(context).pop();
      } catch (error) {
        print('inside product page $error');

        Platform.isIOS
            ? showCupertinoDialog(
                context: context,
                builder: (ctx) => CupertinoAlertDialog(
                  title: Text('An error occurred!'),
                  content: Text('Something went wrong!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Okay'),
                    )
                  ],
                ),
              )
            : showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('An error occurred!'),
                  content: Text('Something went wrong!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Okay'),
                    )
                  ],
                ),
              );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    //
    // print(_editedProduct.title);
    // print(_editedProduct.price);
    // print(_editedProduct.description);
    // print(_editedProduct.imageUrl);
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
        title: Text('${_editedProduct.id != null ? 'Edit' : 'Add'} Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
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
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
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
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
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
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
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
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
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
                                  id: _editedProduct.id,
                                  isFavourite: _editedProduct.isFavourite,
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
