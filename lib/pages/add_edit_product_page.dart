import 'package:flutter/material.dart';

class AddEditProductPage extends StatefulWidget {
  static const routeName = '/add-edit-product';

  @override
  _AddEditProductPageState createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _priceFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  focusNode: _priceFocusNode,
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
