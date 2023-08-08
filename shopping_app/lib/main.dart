import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Product {
  final String prodName;
  final double prodPrice;
  final String prodCategory;

  Product({required this.prodName, required this.prodPrice, required this.prodCategory});
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Shopping App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShoppingApp(),
    );
  }
}

class ShoppingApp extends StatefulWidget {
  @override
  _ShoppingAppState createState() => _ShoppingAppState();
}

class _ShoppingAppState extends State<ShoppingApp> {
  List<Product> products = [
    Product(prodName: 'Product 1', prodPrice: 10.0, prodCategory: 'Category A'),
    Product(prodName: 'Product 2', prodPrice: 20.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 3', prodPrice: 56.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 4', prodPrice: 34.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 5', prodPrice: 23.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 6', prodPrice: 87.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 7', prodPrice: 78.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 8', prodPrice: 45.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 9', prodPrice: 12.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 11', prodPrice: 90.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 12', prodPrice: 30.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 22', prodPrice: 40.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 21', prodPrice: 40.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 23', prodPrice: 60.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 24', prodPrice: 20.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 25', prodPrice: 80.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 26', prodPrice: 60.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 27', prodPrice: 50.0, prodCategory: 'Category B'),
    Product(prodName: 'Product 28', prodPrice: 30.0, prodCategory: 'Category B')

    
  ];

  List<CartItem> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Shopping App'),
      ),
      body: Row(
        children: [
          Expanded(
            child: ProductCategoryList(products, _addToCart, _editProduct, _deleteProduct),
          ),
          Expanded(
            child: ShoppingCart(cartItems, _removeFromCart, _editCartItem, _deleteCartItem, _increaseCartItemQuantity, _decreaseCartItemQuantity),
          ),
        ],
      ),
    );
  }

  void _addToCart(Product product) {
    setState(() {
      bool itemExists = false;
      for (var cartItem in cartItems) {
        if (cartItem.product == product) {
          cartItem.quantity++;
          itemExists = true;
          break;
        }
      }
      if (!itemExists) {
        cartItems.add(CartItem(product: product));
      }
    });
  }

  void _removeFromCart(CartItem cartItem) {
    setState(() {
      if (cartItem.quantity > 1) {
        cartItem.quantity--;
      } else {
        cartItems.remove(cartItem);
      }
    });
  }

  void _editProduct(Product product) async {
    Product editedProduct = await showDialog(
      context: context,
      builder: (context) => EditProductDialog(product),
    );

    if (editedProduct != null) {
      setState(() {
        int index = products.indexWhere((element) => element.prodName == product.prodName);
        if (index != -1) {
          products[index] = editedProduct;
        }
      });
    }
  }

  void _deleteProduct(Product product) {
    setState(() {
      products.remove(product);
    });
  }

  void _editCartItem(CartItem cartItem) async {
    CartItem editedCartItem = await showDialog(
      context: context,
      builder: (context) => EditCartItemDialog(cartItem),
    );

    if (editedCartItem != null) {
      setState(() {
        int index = cartItems.indexWhere((element) => element.product == cartItem.product);
        if (index != -1) {
          cartItems[index] = editedCartItem;
        }
      });
    }
  }

  void _deleteCartItem(CartItem cartItem) {
    setState(() {
      cartItems.remove(cartItem);
    });
  }

  void _increaseCartItemQuantity(CartItem cartItem) {
    setState(() {
      cartItem.quantity++;
    });
  }

  void _decreaseCartItemQuantity(CartItem cartItem) {
    setState(() {
      if (cartItem.quantity > 1) {
        cartItem.quantity--;
      }
    });
  }
}

class ProductCategoryList extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductSelected;
  final Function(Product) onEditProduct;
  final Function(Product) onDeleteProduct;

  ProductCategoryList(this.products, this.onProductSelected, this.onEditProduct, this.onDeleteProduct);

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        //bug
        // ElevatedButton(
        //   onPressed: _addNewProduct,
        //   child: Text('Add New Product'),
        // ),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(products[index].prodName),
                subtitle: Text('${products[index].prodPrice.toStringAsFixed(2)} \$'),
                onTap: () => onProductSelected(products[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => onEditProduct(products[index]),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => onDeleteProduct(products[index]),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

//bug add product
  // void _addNewProduct() {
  //   Product newProduct = Product(prodName: 'New Product', prodPrice: 0.0, prodCategory: 'New Category');
  //   onProductSelected(newProduct);
  // }
}

class EditProductDialog extends StatefulWidget {
  final Product product;

  EditProductDialog(this.product);

  @override
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.prodName);
    _priceController = TextEditingController(text: widget.product.prodPrice.toString());
    _categoryController = TextEditingController(text: widget.product.prodCategory);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Product'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Name')),
          TextField(controller: _priceController, decoration: InputDecoration(labelText: 'Price')),
          TextField(controller: _categoryController, decoration: InputDecoration(labelText: 'Category')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String name = _nameController.text;
            double price = double.tryParse(_priceController.text) ?? 0.0;
            String category = _categoryController.text;

            if (name.isNotEmpty && price > 0 && category.isNotEmpty) {
              Product editedProduct = Product(prodName: name, prodPrice: price, prodCategory: category);
              Navigator.pop(context, editedProduct);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

class EditCartItemDialog extends StatefulWidget {
  final CartItem cartItem;

  EditCartItemDialog(this.cartItem);

  @override
  _EditCartItemDialogState createState() => _EditCartItemDialogState();
}

class _EditCartItemDialogState extends State<EditCartItemDialog> {
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: widget.cartItem.quantity.toString());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Cart Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _quantityController, decoration: InputDecoration(labelText: 'Quantity')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            int quantity = int.tryParse(_quantityController.text) ?? 0;

            if (quantity > 0) {
              CartItem editedCartItem = CartItem(product: widget.cartItem.product, quantity: quantity);
              Navigator.pop(context, editedCartItem);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

class ShoppingCart extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(CartItem) onItemRemoved;
  final Function(CartItem) onEditCartItem;
  final Function(CartItem) onDeleteCartItem;
  final Function(CartItem) onIncreaseCartItemQuantity;
  final Function(CartItem) onDecreaseCartItemQuantity;

  ShoppingCart(this.cartItems, this.onItemRemoved, this.onEditCartItem, this.onDeleteCartItem, this.onIncreaseCartItemQuantity, this.onDecreaseCartItemQuantity);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Shopping Cart',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(cartItems[index].product.prodName),
                subtitle: Text('Price: ${cartItems[index].product.prodPrice.toStringAsFixed(2)} \$ - Quantity: ${cartItems[index].quantity}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => onEditCartItem(cartItems[index]),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => onDeleteCartItem(cartItems[index]),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => onDecreaseCartItemQuantity(cartItems[index]),
                    ),
                    Text('${cartItems[index].quantity}'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => onIncreaseCartItemQuantity(cartItems[index]),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
