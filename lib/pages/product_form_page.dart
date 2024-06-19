import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  late Map<String, dynamic> productAlt;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    productAlt = {
      'id': '',
      'title': '',
      'description': '',
      'imageUrl': '',
      'price': '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as Product?;

    if (product != null) {
      productAlt = {
        'id': product.id,
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
      };
    }

    void saveProduct() {
      context
          .read<ProductList>()
          .saveProduct(
            productAlt,
          )
          .catchError((error) => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  title: const Text('Error'), content: Text(error.toString()))))
          .then(
            (value) => Navigator.of(context).pop(),
          );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Product"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                saveProduct();
              }
            },
          ),
        ],
      ),
      body: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'title',
                  initialValue: productAlt['title'].toString(),
                  decoration: const InputDecoration(
                    labelText: 'title',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(3),
                    FormBuilderValidators.maxLength(20),
                  ]),
                  onChanged: (value) {
                    productAlt['title'] = value;
                  },
                ),
                FormBuilderTextField(
                  name: 'description',
                  initialValue: productAlt['description'].toString(),
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(5),
                    FormBuilderValidators.maxLength(100),
                  ]),
                  onChanged: (value) {
                    productAlt['description'] = value;
                  },
                ),
                FormBuilderTextField(
                  name: 'imageUrl',
                  initialValue: productAlt['imageUrl'].toString(),
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.url(),
                  ]),
                  onChanged: (value) {
                    productAlt['imageUrl'] = value;
                  },
                ),
                FormBuilderTextField(
                  name: 'price',
                  initialValue: productAlt['price'].toString(),
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                  ]),
                  onChanged: (value) {
                    productAlt['price'] = value;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
