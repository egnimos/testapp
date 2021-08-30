import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:testapp/product.dart';
import 'package:testapp/productProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Test App'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() => _isLoading = true);
      Provider.of<ProductProvider>(context, listen: false)
          .loadAndParse(context)
          .then(
            (value) => setState(() => _isLoading = false),
          );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const CircularProgressIndicator()
          : Consumer<ProductProvider?>(
              builder: (context, pp, __) => ListView(
                physics: ClampingScrollPhysics(),
                children: [
                  //categorys
                  ...pp!.getCategories!
                      .map(
                        (it) => ProductWidget(
                          category: it,
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
    );
  }
}

//product display
class ProductWidget extends StatelessWidget {
  final String category;

  const ProductWidget({
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //category
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Text(
            "$category",
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),

        Divider(
          thickness: 1.0,
          endIndent: 10.0,
          indent: 10.0,
        ),
        //list of info
        Consumer<ProductProvider?>(
          builder: (BuildContext context, pp, Widget? child) {
            var prod =
                pp!.getProducts!.where((p) => p.category == category).toList();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: prod.length,
                itemBuilder: (context, i) => ListTile(
                  title: Text("${prod[i].productName}"),
                  subtitle: Text("${prod[i].category}"),
                  trailing: Text("${prod[i].price}"),
                ),
              ),
            );
          },
        ),

        SizedBox(height: 50.0),
      ],
    );
  }
}
