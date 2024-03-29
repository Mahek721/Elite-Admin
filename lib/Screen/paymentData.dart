import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentDataInfo extends StatelessWidget {
  final List<dynamic> data;

  PaymentDataInfo({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment Data",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: data.isEmpty ? Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Payment : COD"),
          ),
        ),
      ) : ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final paymentData = data;
          final orderId = paymentData[index]['o_id'];
          var pdataEntity = data[0]['pdata'];
          var parsedData = jsonDecode(pdataEntity);

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order ID: $orderId',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () async {
                      String phoneNumber = parsedData['items'][index]['contact'];
                      if (await canLaunch("tel:$phoneNumber")) {
                        await launch("tel:$phoneNumber");
                      } else {
                        print("Could not launch phone dialer");
                      }
                    },
                    child: parsedData['items'][index]['contact']!= null ? Text(style: TextStyle(fontWeight: FontWeight.bold),"Buyer Contact: ${parsedData['items'][index]['contact']}") : Container()),
                  InkWell(
                    onTap: () async {
                      const email = 'rutvikpatel0q@gmail.com';
                      final Uri _emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: email,
                      );
                      if (await canLaunch(_emailLaunchUri.toString())) {
                        await launch(_emailLaunchUri.toString());
                      } else {
                        throw 'Could not launch $email';
                      }
                    },
                    child: parsedData['items'][index]['email'] != null ? Text(style: TextStyle(fontWeight: FontWeight.bold),"Buyer Email: ${parsedData['items'][index]['email']}") : Container()),
                  
                  Text(
                    style: TextStyle(fontWeight: FontWeight.bold),'Items Amount: ${(parsedData['items'][index]['amount'] / 100).toString()} ${parsedData["items"][index]['currency']}',
                  ),
                  Text(style: TextStyle(fontWeight: FontWeight.bold),"Payment id: ${parsedData['items'][index]['id']}"),
                  SizedBox(height: 8),
                  parsedData['items'][index]['order_id'] != null ? Text("Razorpay Order_id: ${parsedData['items'][index]['order_id']}") : Container(),
                  parsedData['items'][index]['vpa'] != null ? Text("Payment Vpa: ${parsedData['items'][index]['vpa']}") : Container(),
                  parsedData['items'][index]['method'] != null ? Text("Razorpay Method: ${parsedData['items'][index]['method']}") : Container(),
                  parsedData['items'][index]["acquirer_data"]['upi_transaction_id'] != null ? Text("Razorpay upi_transaction_id: ${parsedData['items'][index]["acquirer_data"]['upi_transaction_id']}") : Container(),
                  parsedData['items'][index]['created_at'] != null ? Text("Razorpay created_at: ${parsedData['items'][index]['created_at']}") : Container(),
                  parsedData['items'][index]["acquirer_data"]['rrn'] != null ? Text("Razorpay RRN: ${parsedData['items'][index]["acquirer_data"]['rrn']}") : Container(),

                  Text('Entity: ${parsedData['entity']}'),
                  Text('Count: ${parsedData['count']}'),
                  
                  parsedData['items'][index]['entity'] != null ? Text("Items Entity: ${parsedData['items'][index]['entity']}") : Container(),
                  parsedData['items'][index]['status'] != null ? Text("Items Status: ${parsedData['items'][index]['status']}") : Container(),
                  parsedData['items'][index]['invoice_id'] != null ? Text("Razorpay Invoice_id: ${parsedData['items'][index]['invoice_id']}") : Container(),
                  parsedData['items'][index]['amount_refunded'] != null ? Text("Payment Amount_refunded: ${parsedData['items'][index]['amount_refunded']}") : Container(),
                  parsedData['items'][index]['refund_status'] != null ? Text("Payment Refund_status: ${parsedData['items'][index]['refund_status']}") : Container(),
                  parsedData['items'][index]['captured'] != null ? Text("Razorpay Captured: ${parsedData['items'][index]['captured']}") : Container(),
                  parsedData['items'][index]['description'] != null ? Text("Razorpay Description: ${parsedData['items'][index]['description']}") : Container(),
                  parsedData['items'][index]['card_id'] != null ? Text("Payment Card_id: ${parsedData['items'][index]['card_id']}") : Container(),
                  parsedData['items'][index]['bank'] != null ? Text("Payment Bank: ${parsedData['items'][index]['bank']}") : Container(),
                  parsedData['items'][index]['wallet'] != null ? Text("Payment Wallet: ${parsedData['items'][index]['wallet']}") : Container(),
                  parsedData['items'][index]['notes'] != null ? Text("Buyer Notes: ${parsedData['items'][index]['notes']}") : Container(),
                  parsedData['items'][index]['fee'] != null ? Text("Fee: ${parsedData['items'][index]['fee']}") : Container(),
                  parsedData['items'][index]['tax'] != null ? Text("Tax: ${parsedData['items'][index]['tax']}") : Container(),
                  parsedData['items'][index]['error_code'] != null ? Text("Razorpay error_code: ${parsedData['items'][index]['error_code']}") : Container(),
                ]
              ),
            ),
          );
        },
      ),
    );
  }
}
