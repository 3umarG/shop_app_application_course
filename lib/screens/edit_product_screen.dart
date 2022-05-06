import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/providers/single_product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isInit = true;
  Product _newProduct = Product(
    id: "",
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );
  Map _initValues = {
    "title": "",
    "price": "",
    "description": "",
    "imageUrl": "",
  };
  bool _isLoading = false;

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      String? productId = "";
      final argumentId = ModalRoute.of(context)?.settings.arguments;
      if (argumentId == null) {
        return;
      }
      productId = argumentId as String;
      _newProduct = Provider.of<ProductsProvider>(context, listen: false)
          .findById(productId);
      // _newProduct has a valid value.
      _initValues = {
        "title": _newProduct.title,
        "price": _newProduct.price.toString(),
        "description": _newProduct.description,
        "imageUrl": "",
      };
      _imageUrlController.text = _newProduct.imageUrl;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future _saveForm() async {
    final bool _isValid = _formKey.currentState!.validate();
    if (!_isValid) return;
    _formKey.currentState!.save();

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // ID IS Empty ====>   You Want to Add New Product
      if (_newProduct.id.isEmpty) {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProductWithAsync(_newProduct);
      } else {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_newProduct.id, _newProduct);
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("An Error Occured!"),
          content: const Text("Something went Wrong!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Okay"),
            )
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          // Updated Done.........
          _isLoading = false;
        });
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Your Product",
        ),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.purpleAccent,
            ))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Title",
                      ),
                      initialValue: _initValues["title"],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Empty Title";
                        }
                        return null;
                      },
                      onSaved: (valueTitle) {
                        _newProduct = Product(
                          id: _newProduct.id, // "" OR ID
                          title: valueTitle!,
                          description: _newProduct.description,
                          price: _newProduct.price,
                          imageUrl: _newProduct.imageUrl,
                          isFavourite: _newProduct.isFavourite,
                        );
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Price",
                      ),
                      initialValue: _initValues["price"],
                      validator: (value) {
                        if (value!.isEmpty ||
                            double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return "Enter a Valid Price";
                        }
                        return null;
                      },
                      onSaved: (valuePrice) {
                        _newProduct = Product(
                          id: _newProduct.id,
                          title: _newProduct.title,
                          description: _newProduct.description,
                          price: double.parse(valuePrice!),
                          imageUrl: _newProduct.imageUrl,
                          isFavourite: _newProduct.isFavourite,
                        );
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                      initialValue: _initValues["description"],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Empty Description";
                        }
                        if (value.length < 10) {
                          return "Too short Description";
                        }
                        return null;
                      },
                      onSaved: (valueDesc) {
                        _newProduct = Product(
                          id: _newProduct.id,
                          title: _newProduct.title,
                          description: valueDesc!,
                          price: _newProduct.price,
                          imageUrl: _newProduct.imageUrl,
                          isFavourite: _newProduct.isFavourite,
                        );
                      },
                      maxLines: 3,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          )),
                          child: _imageUrlController.text.isEmpty
                              ? const Text(
                                  "Please , Enter a URL",
                                )
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Image URL",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Empty URL";
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return "This is Not a Valid URL";
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('jpeg')) {
                                return "This is Not a Image..!!";
                              }
                              return null;
                            },
                            onSaved: (valueURL) {
                              _newProduct = Product(
                                id: _newProduct.id,
                                title: _newProduct.title,
                                description: _newProduct.description,
                                price: _newProduct.price,
                                imageUrl: valueURL!,
                                isFavourite: _newProduct.isFavourite,
                              );
                            },
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
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
