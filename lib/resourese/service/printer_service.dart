import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/printer.dart';
import 'package:food_delivery_app/resourese/printer/iprinter_repository.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  Future<void> onStartPrint(FoodOrder foodOrder) async {
    if (printers.value.isEmpty) return;

    await Future.wait(printers.value.map((printer) => _printerHandler(foodOrder, printer)));
  }

  Future<void> _printerHandler(FoodOrder foodOrder, Printer printer) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final networkPrinter = NetworkPrinter(paper, profile);

    final res = await networkPrinter.connect(printer.ip ?? '', port: int.tryParse(printer.port ?? '9100') ?? 9100);
    if (res == PosPrintResult.success) {
      await Future.wait((foodOrder.partyOrders ?? []).map((e) => _printReceipt(foodOrder, e, networkPrinter)));
      networkPrinter.disconnect();
    }
  }

  Future<void> _printReceipt(FoodOrder foodOrder, PartyOrder partyOrder, NetworkPrinter networkPrinter) async {
    void createRowTitle(NetworkPrinter networkPrinter, String title, String content,
        {PosTextSize contentSize = PosTextSize.size1, PosColumn? custom}) {
      networkPrinter.row([
        PosColumn(text: title, width: 4),
        PosColumn(text: content, styles: PosStyles(height: contentSize, width: contentSize)),
        if (custom != null) custom
      ]);
    }

    void createOrderItemRow(NetworkPrinter networkPrinter, OrderItem orderItem) {
      networkPrinter.row([]);
    }

    final date = DateTime.tryParse(foodOrder.createdAt ?? '') ?? DateTime.now();
    networkPrinter.feed(4);
    createRowTitle(networkPrinter, 'Bon', (foodOrder.bondNumber ?? 1).toString(),
        contentSize: PosTextSize.size4, custom: PosColumn(text: 'Gangbon'));
    createRowTitle(networkPrinter, 'Datum', DateFormat(PRINTER_DAY_FORMAT).format(date),
        contentSize: PosTextSize.size1);
    createRowTitle(networkPrinter, 'Bedient von', foodOrder.userOrder?.role ?? USER_ROLE.STAFF,
        contentSize: PosTextSize.size1);
    createRowTitle(networkPrinter, 'Terminal', '15a24e3a', contentSize: PosTextSize.size1);
    createRowTitle(networkPrinter, 'Tisch', 'Tisch ${foodOrder.tableNumber ?? '0'}', contentSize: PosTextSize.size6);
    if (partyOrder.partyNumber != null) {
      createRowTitle(networkPrinter, 'Partei', 'Partei ${partyOrder.partyNumber ?? 1}', contentSize: PosTextSize.size6);
    }

    networkPrinter.hr();
    final orderItem = partyOrder.orderItems ?? <OrderItem>[];
    orderItem.sort((a, b) => (a.sortOder ?? -1) > (b.sortOder ?? -1) ? 1 : -1);
    for (final item in orderItem) {
      createOrderItemRow(networkPrinter, item);
    }
    networkPrinter.feed(4);
    networkPrinter.cut();
  }
}
