import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:food_delivery_app/models/printer.dart';
import 'package:food_delivery_app/resourese/printer/iprinter_repository.dart';
import 'package:get/get.dart';

class PrinterService extends GetxService {
  final IPrinterRepository printerRepository;

  PrinterService({required this.printerRepository});

  final printers = Rx<List<Printer>>([]);

  Future<void> init() async {
    printers.value = await printerRepository.getPrinter();
  }

  void clear() {
    printers.value = [];
  }

  @override
  void onClose() {
    printers.close();
    super.onClose();
  }

  Future<void> onStartPrint() async {
    if (printers.value.isEmpty) return;

    await Future.wait(printers.value.map(_printerHandler));
  }

  Future<void> _printerHandler(Printer printer) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final networkPrinter = NetworkPrinter(paper, profile);

    final res = await networkPrinter.connect(printer.ip ?? '', port: int.tryParse(printer.port ?? '9100') ?? 9100);
    if (res == PosPrintResult.success) {
      await _printReceipt(networkPrinter);
      networkPrinter.disconnect();
    }
  }

  Future<void> _printReceipt(NetworkPrinter networkPrinter) async {
    networkPrinter.text('Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    networkPrinter.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ', styles: PosStyles(codeTable: 'CP1252'));
    networkPrinter.text('Special 2: blåbærgrød', styles: PosStyles(codeTable: 'CP1252'));

    networkPrinter.text('Bold text', styles: PosStyles(bold: true));
    networkPrinter.text('Reverse text', styles: PosStyles(reverse: true));
    networkPrinter.text('Underlined text', styles: PosStyles(underline: true), linesAfter: 1);
    networkPrinter.text('Align left', styles: PosStyles(align: PosAlign.left));
    networkPrinter.text('Align center', styles: PosStyles(align: PosAlign.center));
    networkPrinter.text('Align right', styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    networkPrinter.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    networkPrinter.text('Text size 200%',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    // Print barcode
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    networkPrinter.barcode(Barcode.upcA(barData));

    networkPrinter.feed(2);
    networkPrinter.cut();
  }
}
