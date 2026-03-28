import 'dart:io';
import 'package:CHATS/api/user_api.dart';
import 'package:CHATS/domain/locator.dart';
import 'package:CHATS/router.dart';
import 'package:CHATS/services/user_service.dart';
import 'package:CHATS/theme_changer.dart';
import 'package:CHATS/utils/colors.dart';
import 'package:CHATS/utils/text.dart';
import 'package:CHATS/utils/ui_helper.dart';
import 'package:CHATS/widgets/custom_btn.dart';
import 'package:CHATS/widgets/error_widget_handler.dart';
import 'package:flutter/material.dart';
import 'package:snack/snack.dart';

class PaymentConfirmationQrUploadView extends StatefulWidget {
  const PaymentConfirmationQrUploadView({Key? key, required this.qrUploadData}) : super(key: key);

  final Map<String, dynamic> qrUploadData;
  
  @override
  _PaymentConfirmationQrUploadViewState createState() => _PaymentConfirmationQrUploadViewState();
}

class _PaymentConfirmationQrUploadViewState extends State<PaymentConfirmationQrUploadView> {
  final TextEditingController _amountController = TextEditingController();
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Pre-fill amount if available from QR
    if (widget.qrUploadData['amount'] != null) {
      _amountController.text = widget.qrUploadData['amount'].toString();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qrPayload = widget.qrUploadData['qr_payload'] as Map<String, dynamic>;
    
    return WillPopScope(
      onWillPop: () => onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: ThemeBuilder.of(context)!.getCurrentTheme() == Brightness.light
              ? Colors.white
              : primaryColorDarkMode,
          title: CustomText(
            text: 'Payment Confirmation',
            fontFamily: 'Gilroy-medium',
            fontSize: 22,
            edgeInset: EdgeInsets.only(top: 3),
            color: ThemeBuilder.of(context)!.getCurrentTheme() == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: ThemeBuilder.of(context)!.getCurrentTheme() == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
        body: Container(
          color: ThemeBuilder.of(context)!.getCurrentTheme() == Brightness.light
              ? Colors.white
              : primaryColorDarkMode,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // QR Info Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.qr_code, color: Colors.green, size: 24),
                        SizedBox(width: 10),
                        CustomText(
                          text: 'QR Code Payment',
                          fontFamily: 'Gilroy-bold',
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    _buildInfoRow('Campaign ID', qrPayload['campaignId'].toString()),
                    _buildInfoRow('Vendor ID', qrPayload['vendorId'].toString()),
                    if (qrPayload['orderRef'] != null)
                      _buildInfoRow('Order Reference', qrPayload['orderRef']),
                    _buildInfoRow('Vendor Address', _formatAddress(qrPayload['vendorAddress'])),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Amount Input
              CustomText(
                text: 'Payment Amount',
                fontFamily: 'Gilroy-bold',
                fontSize: 18,
                color: ThemeBuilder.of(context)!.getCurrentTheme() == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: ThemeBuilder.of(context)!.getCurrentTheme() == Brightness.light
                        ? Colors.black
                        : Colors.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixText: 'PKR ',
                    prefixStyle: TextStyle(
                      color: ThemeBuilder.of(context)!.getCurrentTheme() == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Error Message
              if (_errorMessage != null) ...[
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomText(
                          text: _errorMessage!,
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],

              // Payment Button
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      height: 50,
                      bgColor: _isProcessing ? Colors.grey : Constants.usedGreen,
                      children: [
                        if (_isProcessing)
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        else
                          Icon(
                            Icons.payment,
                            color: Colors.white,
                            size: 20,
                          ),
                        SizedBox(width: 10),
                        CustomText(
                          text: _isProcessing ? 'Processing Payment...' : 'Confirm Payment',
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Gilroy-medium',
                        ),
                      ],
                      onTap: _isProcessing ? null : _processPayment,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: CustomText(
              text: '$label:',
              fontFamily: 'Gilroy-medium',
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: CustomText(
              text: value,
              fontFamily: 'Gilroy-medium',
              fontSize: 14,
              color: ThemeBuilder.of(context)!.getCurrentTheme() == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAddress(String address) {
    if (address.length > 10) {
      return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
    }
    return address;
  }

  Future<void> _processPayment() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a payment amount';
      });
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid amount';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final UserAPI userAPI = UserAPI();
      final qrPayload = widget.qrUploadData['qr_payload'] as Map<String, dynamic>;
      final campaignId = widget.qrUploadData['campaign_id'] as int;

      final result = await userAPI.scanPay(campaignId, amount, qrPayload);

      if (result is Map<String, dynamic> && result.containsKey('status') && result['status'] == 'failed') {
        setState(() {
          _errorMessage = result['message'] ?? 'Payment failed';
          _isProcessing = false;
        });
        return;
      }

      // Show success message
      final snackBar = SnackBar(
        content: CustomText(
          text: 'Payment processed successfully!',
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
      );
      snackBar.show(context);

      // Navigate back to home or transactions
      Navigator.pushNamedAndRemoveUntil(
        context,
        'home',
        (route) => false,
      );

    } catch (e) {
      setState(() {
        _errorMessage = 'Payment failed: $e';
        _isProcessing = false;
      });
    }
  }
}
