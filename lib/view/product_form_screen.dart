import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/provider/product.dart';
import 'package:shop/provider/products.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({Key? key}) : super(key: key);

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageURlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      if (_formData.isEmpty) {
        final product = ModalRoute.of(context)!.settings.arguments as Product;
        _formData['id'] = product.id.isEmpty ? '' : product.id;
        _formData['title'] = product.title.isEmpty ? '' : product.title;
        _formData['description'] =
            product.description.isEmpty ? '' : product.description;
        _formData['price'] = product.price == 0.0 ? 0 : product.price;
        _formData['imageUrl'] =
            product.imageUrl.isEmpty ? '' : product.imageUrl;

        _imageURlController.text = _formData['imageUrl'].toString();
      }
    } else {
      _formData['id'] = '';
      _formData['title'] = '';
      _formData['description'] = '';
      _formData['price'] = '';
      _formData['imageUrl'] = '';
    }
  }

  void _updateImageUrl() {
    if (isValidImageUrl(_imageURlController.text)) {
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool isValidProtocolHttp = url.toLowerCase().startsWith('http://');
    bool isValidProtocolHttps = url.toLowerCase().startsWith('https://');
    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(url);

    return (isValidProtocolHttp || isValidProtocolHttps) &&
            (endsWithJpeg || endsWithPng || endsWithJpg) ||
        emailValid;
  }

  void _saveForm() {
    bool isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    final product = Product(
      id: _formData['id'].toString(),
      title: _formData['title']!.toString(),
      price: double.parse(_formData['price'].toString()),
      description: _formData['description'].toString(),
      imageUrl: _formData['imageUrl'].toString(),
    );

    final products = Provider.of<Products>(context, listen: false);

    if (_formData['id'] == '' || _formData['id'] == null) {
      products.addProduct(product);
    } else {
      products.updateProduct(product);
    }

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Formulário Produto'),
        actions: [
          IconButton(
            onPressed: () => _saveForm(),
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['title'].toString(),
                decoration: InputDecoration(labelText: 'Título'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) => _formData['title'] = value!,
                validator: (value) {
                  if (value!.trim().isEmpty || value.trim().length < 3) {
                    return 'Informe um título valido';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['price'].toString(),
                decoration: InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) => _formData['price'] = double.parse(value!),
                validator: (value) {
                  var newPrice = double.tryParse(value!);
                  bool isInvalid = newPrice == null || newPrice <= 0;
                  if (value.trim().isEmpty || isInvalid) {
                    return 'Informe um valor válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['description'].toString(),
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) => _formData['description'] = value!,
                validator: (value) {
                  if (value!.trim().isEmpty || value.trim().length < 10) {
                    return 'Informe uma descrição válida';
                  }

                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                        decoration: InputDecoration(labelText: 'URL da Imagem'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        focusNode: _imageUrlFocusNode,
                        controller: _imageURlController,
                        onSaved: (value) => _formData['imageUrl'] = value!,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        validator: (value) {
                          if (!isValidImageUrl(value!) ||
                              value.trim().isEmpty) {
                            return 'URL Invalida!';
                          }
                          return null;
                        }),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageURlController.text.isEmpty
                        ? Image.network(
                            'https://cdn.neemo.com.br/uploads/settings_webdelivery/logo/2184/340719-200.png',
                          )
                        : FittedBox(
                            child: Image.network(
                              _imageURlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
