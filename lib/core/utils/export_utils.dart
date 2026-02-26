import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// PDF
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Excel
import 'package:excel/excel.dart';

import '../../shared/models/earning.dart';
import '../../shared/models/expense.dart';
import 'currency_formatter.dart';

class ExportUtils {
  ExportUtils._();

  /// Exporta os dados como PDF e chama o compartilhamento nativo.
  static Future<void> exportPdf({
    required BuildContext context,
    required String driverName,
    required String periodName,
    required double earnings,
    required double expenses,
    required double profit,
    required List<Earning> allEarnings,
    required List<Expense> allExpenses,
  }) async {
    final doc = pw.Document();

    // Mescla ganhos e gastos em uma lista unificada de transações
    final transactions = _mergeTransactions(allEarnings, allExpenses);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context ctx) {
          return [
            _buildPdfHeader(driverName, periodName),
            pw.SizedBox(height: 20),
            _buildPdfSummary(earnings, expenses, profit),
            pw.SizedBox(height: 20),
            _buildPdfTransactionsTable(transactions),
          ];
        },
        footer: (pw.Context ctx) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            padding: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              'Gerado em: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
          );
        },
      ),
    );

    final bytes = await doc.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'Relatorio_${periodName.replaceAll(' ', '_')}.pdf',
    );
  }

  /// Exporta os dados como Excel e chama o compartilhamento.
  static Future<void> exportExcel({
    required BuildContext context,
    required String driverName,
    required String periodName,
    required double earnings,
    required double expenses,
    required double profit,
    required List<Earning> allEarnings,
    required List<Expense> allExpenses,
  }) async {
    final excel = Excel.createExcel();
    
    _buildExcelSummarySheet(excel, driverName, periodName, earnings, expenses, profit);
    _buildExcelEarningsSheet(excel, allEarnings);
    _buildExcelExpensesSheet(excel, allExpenses);

    final fileBytes = excel.save();
    if (fileBytes == null) return;

    final directory = await getTemporaryDirectory();
    final fileName = 'Relatorio_${periodName.replaceAll(' ', '_')}.xlsx';
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(fileBytes);

    await Share.shareXFiles(
      [XFile(filePath)],
      text: 'Relatório Financeiro - $periodName',
    );
  }

  // ---------------------------------------------------------------------------
  // Auxiliares (Mesclagem)
  // ---------------------------------------------------------------------------
  static List<Map<String, dynamic>> _mergeTransactions(
    List<Earning> earningsList,
    List<Expense> expensesList,
  ) {
    final merged = <Map<String, dynamic>>[];
    for (var e in earningsList) {
      merged.add({
        'date': e.date,
        'type': 'Ganho',
        'value': e.value,
        'desc': e.platform ?? 'Ganhos',
      });
    }
    for (var x in expensesList) {
      merged.add({
        'date': x.date,
        'type': 'Gasto',
        'value': -x.value, // negativo para diferenciar
        'desc': '${x.category} - ${x.description}',
      });
    }
    merged.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return merged;
  }

  // ---------------------------------------------------------------------------
  // Builders de PDF
  // ---------------------------------------------------------------------------
  static pw.Widget _buildPdfHeader(String driverName, String periodName) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('UberControl - Relatório Financeiro', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
        pw.SizedBox(height: 10),
        pw.Text('Motorista: $driverName', style: const pw.TextStyle(fontSize: 14)),
        pw.Text('Período: $periodName', style: const pw.TextStyle(fontSize: 14)),
      ],
    );
  }

  static pw.Widget _buildPdfSummary(double earnings, double expenses, double profit) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildPdfSummaryCard('Ganhos', earnings, PdfColors.green700),
        _buildPdfSummaryCard('Gastos', expenses, PdfColors.red700),
        _buildPdfSummaryCard('Lucro Líquido', profit, PdfColors.blue700),
      ],
    );
  }

  static pw.Widget _buildPdfSummaryCard(String title, double value, PdfColor color) {
    return pw.Container(
      width: 150,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: color, width: 2),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
          pw.SizedBox(height: 4),
          pw.Text(CurrencyFormatter.format(value), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  static pw.Widget _buildPdfTransactionsTable(List<Map<String, dynamic>> transactions) {
    if (transactions.isEmpty) {
      return pw.Text('Sem transações neste período.', style: const pw.TextStyle(fontSize: 12));
    }

    final headers = ['Data', 'Tipo', 'Descrição', 'Valor (R\$)'];
    final data = transactions.map((t) {
      final date = DateFormat('dd/MM/yyyy').format(t['date'] as DateTime);
      final isEarning = t['type'] == 'Ganho';
      final valueStr = (isEarning ? '+' : '-') + CurrencyFormatter.format((t['value'] as double).abs());
      return [date, t['type'], t['desc'], valueStr];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300)),
      ),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  // ---------------------------------------------------------------------------
  // Builders de Excel
  // ---------------------------------------------------------------------------
  static void _buildExcelSummarySheet(
      Excel excel, String driverName, String periodName, double e, double x, double p) {
    // A library excel já cria uma aba 'Sheet1', vamos renomear
    final sheet = excel['Resumo'];
    if (excel.tables.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    sheet.cell(CellIndex.indexByString("A1")).value = 'Motorista:';
    sheet.cell(CellIndex.indexByString("B1")).value = driverName;
    
    sheet.cell(CellIndex.indexByString("A2")).value = 'Período:';
    sheet.cell(CellIndex.indexByString("B2")).value = periodName;

    sheet.cell(CellIndex.indexByString("A4")).value = 'Ganhos Totais:';
    sheet.cell(CellIndex.indexByString("B4")).value = CurrencyFormatter.format(e);

    sheet.cell(CellIndex.indexByString("A5")).value = 'Gastos Totais:';
    sheet.cell(CellIndex.indexByString("B5")).value = CurrencyFormatter.format(x);

    sheet.cell(CellIndex.indexByString("A6")).value = 'Lucro Líquido:';
    sheet.cell(CellIndex.indexByString("B6")).value = CurrencyFormatter.format(p);
  }

  static void _buildExcelEarningsSheet(Excel excel, List<Earning> list) {
    final sheet = excel['Ganhos'];
    
    // Headers
    sheet.appendRow([
      'Data',
      'Plataforma',
      'Corridas',
      'Horas',
      'Valor (R\$)',
    ]);

    for (final item in list) {
      sheet.appendRow([
        DateFormat('dd/MM/yyyy').format(item.date),
        item.platform ?? '',
        item.numberOfRides?.toString() ?? '',
        item.hoursWorked?.toString() ?? '',
        item.value.toStringAsFixed(2),
      ]);
    }
  }

  static void _buildExcelExpensesSheet(Excel excel, List<Expense> list) {
    final sheet = excel['Gastos'];
    
    // Headers
    sheet.appendRow([
      'Data',
      'Categoria',
      'Descrição',
      'Litros',
      'Valor (R\$)',
    ]);

    for (final item in list) {
      sheet.appendRow([
        DateFormat('dd/MM/yyyy').format(item.date),
        item.category,
        item.description,
        item.liters?.toStringAsFixed(2) ?? '',
        item.value.toStringAsFixed(2),
      ]);
    }
  }
}
