import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lufick/models/rates.dart';
import 'package:lufick/providers/data_service.dart';
import 'package:provider/provider.dart';

class ExchangeRateScreen extends StatefulWidget {
  @override
  _ExchangeRateScreenState createState() => _ExchangeRateScreenState();
}

class _ExchangeRateScreenState extends State<ExchangeRateScreen> {
  TextEditingController _textController = new TextEditingController();
  double textValue = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
        builder: (context, DataService dataService, child) => Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Euro",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Last refresh : ${dataService.lastTimeRefreshDate}",
                          style: TextStyle(fontSize: 13),
                        )
                      ],
                    )),
                actions: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 12, bottom: 12, right: 20),
                    child: OutlineButton(
                      borderSide: BorderSide(color: Colors.white),
                      child: Text(
                        "Refresh",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        dataService.fetchCurrencyRates();
                      },
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      convertBar(dataService),
                      dataService.currencyRates.isFetching
                          ? SizedBox(
                              height: 4,
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.orangeAccent,
                                ),
                              ))
                          : dataService.currencyRates.hasError()
                              ? Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 30),
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.error_outline,
                                        size: 30,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          "${dataService.currencyRates.errorMessage}")
                                    ],
                                  ),
                                )
                              : currencyTable(dataService)
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget convertBar(DataService dataService) {
    return Container(
        color: Colors.blue,
        padding: EdgeInsets.only(bottom: 10, left: 25, right: 25, top: 10),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (text) {
                if (text.isEmpty) {
                  setState(() {
                    textValue = 1;
                  });
                }
              },
              controller: _textController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 12.0),
                    child: Icon(Icons.swap_horiz),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Convert here",
                  hintStyle: TextStyle(fontSize: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(width: 10.0, color: Colors.white)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),
            SizedBox(
              height: 5,
            ),
            RaisedButton(
              elevation: 0,
              color: Colors.orange,
              child: Text(
                "Convert",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  if (_textController.text.isNotEmpty) {
                    textValue = double.parse(_textController.text);
                  }
                });
              },
              padding: EdgeInsets.only(left: 30, right: 30),
            )
          ],
        ));
  }

  Widget currencyTable(DataService dataService) {
    final rows = <TableRow>[];
    //adding header Row
    rows.add(TableRow(children: [
      TableCell(
          child: Center(
              child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          'Country',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ))),
      TableCell(
        child: Center(
            child: Text(
          'Currency',
          style: TextStyle(fontWeight: FontWeight.w600),
        )),
      )
    ]));

    // adding country data to the row
    for (RateItems country in dataService.currencyRates.data) {
      rows.add(TableRow(children: [
        TableCell(
            child: Center(
                child: Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Text('${country.country}'),
        ))),
        TableCell(
          child: Center(child: Text('${country.currency * textValue}')),
        )
      ]));
    }

    return Expanded(
      child: SingleChildScrollView(
          child: Table(
              border: TableBorder.all(
                  color: Colors.grey.withOpacity(0.4), width: 1),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: rows)),
    );
  }
}
