import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endIsWithFile =
        url.toLowerCase().endsWith('.png') || url.toLowerCase().endsWith('.jpg') || url.toLowerCase().endsWith('.jpeg');

    return isValidUrl && endIsWithFile;
  }

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    setState(() => isLoading = true);
    try {
      await Provider.of<ProductList>(context, listen: false).saveProduct(_formData);
      Future.delayed(
        Duration.zero,
        () {
          Navigator.of(context).pop();
        },
      );
    } catch (error) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Ocorreu um erro"),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario de produto"),
        actions: [
          IconButton(
            onPressed: () => _submitForm(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['name']?.toString(),
                      decoration: const InputDecoration(
                        labelText: "Nome",
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      onSaved: (name) => _formData['name'] = name ?? "",
                      validator: (newName) {
                        final name = newName ?? "";
                        if (name.trim().isEmpty) {
                          return 'Nome ?? obrigat??rio';
                        }
                        if (name.trim().length < 3) {
                          return 'Nome precisa no minimo de 3 letras';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price']?.toString(),
                      decoration: const InputDecoration(
                        labelText: "Pre??o",
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocus,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      onSaved: (price) => _formData['price'] = double.parse(price ?? "0"),
                      validator: (newPrice) {
                        final priceString = newPrice ?? '';
                        final price = double.tryParse(priceString) ?? -1;
                        if (price <= 0) {
                          return 'informe um pre??o v??lido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      decoration: const InputDecoration(
                        labelText: "Descri????o",
                      ),
                      focusNode: _descriptionFocus,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (description) => _formData['description'] = description ?? "",
                      validator: (newDescription) {
                        final description = newDescription ?? "";
                        if (description.trim().isEmpty) {
                          return 'Descri????o ?? obrigat??rio';
                        }
                        if (description.trim().length < 10) {
                          return 'Descri????o precisa no minimo de 10 letras';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _imageUrlController,
                            decoration: const InputDecoration(
                              labelText: "URL da imagem",
                            ),
                            focusNode: _imageUrlFocus,
                            onSaved: (imageUrl) => _formData['imageUrl'] = imageUrl ?? "",
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submitForm(),
                            validator: (newImageUrl) {
                              final imageUrl = newImageUrl ?? "";
                              if (!isValidImageUrl(imageUrl)) {
                                return 'Informe uma Url v??lida!';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(left: 10, top: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? const Text("Informe a Url")
                              : Image.network(_imageUrlController.text),
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
