// import 'package:member_app/common/print/printer_helper.dart';
//
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//
// void printPdf() async {
//   final doc = getDocument();
//   await Printing.layoutPdf(onLayout: (format) async => await doc.save());
// }
//
// void printPdfDirect(Printer printer) async {
//   final doc = getDocument();
//   var result = await Printing.directPrintPdf(
//       printer: printer, onLayout: (format) async => await doc.save());
// }
//
// getDocument() {
//   return createPDF([
//     pw.Center(
//       child: pw.Text('1. Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('2. Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('3. Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('4. Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('5. Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('6. Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('7. Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('8. Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('9. Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('10. Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('11, Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('12, Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('13, Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('14, Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('15, Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('16, Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('17, Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('18, Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('19, Hello World'),
//     ),
//     pw.Container(height: 30),
//     pw.Center(
//       child: pw.Text('20, Hello World'),
//     )
//   ], true);
// }
