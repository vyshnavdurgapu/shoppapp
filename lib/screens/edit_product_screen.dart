import 'package:flutter/material.dart';
import 'package:shoppapp/providers/products_provider.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';

class EditproductScreen extends StatefulWidget {
  static const routename = '/editproductscreen';
  @override
  State<EditproductScreen> createState() => _EditproductScreenState();
}

class _EditproductScreenState extends State<EditproductScreen> {
  final _pricefocusnode = FocusNode();
  final _descriptionfocusnode = FocusNode();
  final _imageurlfocusnode = FocusNode();
  final _imageurlcontroller = TextEditingController();
  final _form = GlobalKey<FormState>();
  var init = true;
  var _edittedproduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');

  var initvalues = {
    'title': '',
    'description': '',
    'price': '',
    'imageurl': '',
  };

  @override
  void initState() {
    _imageurlfocusnode.addListener(updateimageurl);
    // TODO: implement initState
    super.initState();
  }

  void didChangeDependencies() {
    if (init) {
      final productid = ModalRoute.of(context)!.settings.arguments;
      if (productid != null) {
        _edittedproduct = Provider.of<Products>(context, listen: false)
            .findbyid(productid as String);
        initvalues = {
          'title': _edittedproduct.title,
          'description': _edittedproduct.description,
          'price': _edittedproduct.price.toString(),
          'imageurl': '',
        };
        _imageurlcontroller.text = _edittedproduct.imageUrl;
      }
    }
    init = false;
    super.didChangeDependencies();
  }

  void updateimageurl() {
    if (!_imageurlfocusnode.hasFocus) {
      // if ((!_imageurlcontroller.text.startsWith('http') &&
      //         !_imageurlcontroller.text.startsWith('https')) ||
      //     (!_imageurlcontroller.text.endsWith('.png') &&
      //         !_imageurlcontroller.text.endsWith('.jpg') &&
      //         !_imageurlcontroller.text.endsWith('.jpeg'))) {
      //   return;
      // }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pricefocusnode.dispose();
    _descriptionfocusnode.dispose();
    _imageurlcontroller.dispose();
    _imageurlfocusnode.removeListener(updateimageurl);
    // TODO: implement dispose
    super.dispose();
  }

  void saveform() {
    final isvalid = _form.currentState!.validate();
    if (isvalid) {
      _form.currentState!.save();
      if (_edittedproduct.id != '') {
        Provider.of<Products>(context, listen: false)
            .updateproduct(_edittedproduct.id, _edittedproduct);
      } else {
        Provider.of<Products>(context, listen: false)
            .addproduct(_edittedproduct);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product.'),
        actions: [IconButton(onPressed: saveform, icon: Icon(Icons.save))],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: initvalues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_pricefocusnode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter a title';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _edittedproduct = Product(
                    title: value.toString(),
                    description: _edittedproduct.description,
                    price: _edittedproduct.price,
                    imageUrl: _edittedproduct.imageUrl,
                    id: _edittedproduct.id,
                    isFavorite: _edittedproduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                initialValue: initvalues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _pricefocusnode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionfocusnode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter a title';
                  } else if (double.tryParse(value) == null) {
                    return 'enter a valid price';
                  } else if (double.parse(value) <= 0) {
                    return 'price should be greater than zero';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _edittedproduct = Product(
                      id: _edittedproduct.id,
                      isFavorite: _edittedproduct.isFavorite,
                      title: _edittedproduct.title,
                      description: _edittedproduct.description,
                      price: double.parse(value.toString()),
                      imageUrl: _edittedproduct.imageUrl);
                },
              ),
              TextFormField(
                initialValue: initvalues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionfocusnode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter a description';
                  } else if (value.length <= 10) {
                    return 'description should me longer than 10 characters';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _edittedproduct = Product(
                      id: _edittedproduct.id,
                      isFavorite: _edittedproduct.isFavorite,
                      title: _edittedproduct.title,
                      description: value.toString(),
                      price: _edittedproduct.price,
                      imageUrl: _edittedproduct.imageUrl);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageurlcontroller.text.isEmpty
                        ? Text('enter the url to view')
                        : FittedBox(
                            child: Image.network(_imageurlcontroller.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      // initialValue: initvalues['imageurl'],//this does not work because this conflcts with controller
                      decoration: InputDecoration(labelText: 'image url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageurlcontroller,
                      focusNode: _imageurlfocusnode,
                      onFieldSubmitted: (_) => saveform(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter a title';
                          // } else if (!value.startsWith('http') ||
                          //     !value.startsWith('https')) {
                          //   return 'please enter a valid url';
                          // }
                          // if (!value.endsWith('.png') ||
                          //     !value.endsWith('.jpg') ||
                          //     !value.endsWith('.jpeg')) {
                          //   return 'the provided is not a image';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _edittedproduct = Product(
                            id: _edittedproduct.id,
                            isFavorite: _edittedproduct.isFavorite,
                            title: _edittedproduct.title,
                            description: _edittedproduct.description,
                            price: _edittedproduct.price,
                            imageUrl: value.toString());
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
