import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/food_order.dart';
import 'package:food_delivery_app/models/order_item.dart';
import 'package:food_delivery_app/models/party_order.dart';
import 'package:food_delivery_app/models/printer.dart';
import 'package:food_delivery_app/resourese/printer/iprinter_repository.dart';
import 'package:food_delivery_app/utils/utils.dart';
import 'package:food_delivery_app/widgets/loading.dart';
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
    showPrinterLoading();
    try {
      _onHandlePrinter(foodOrder);
      await Future.delayed(const Duration(milliseconds: 5000));
    } catch (e) {
      print(e);
    }
    dissmissLoading();
  }

  Future<void> _onHandlePrinter(FoodOrder foodOrder) async {
    for (final printer in printers.value) {
      await _printerHandler(foodOrder, printer);
    }
  }

  Future<void> _printerHandler(FoodOrder foodOrder, Printer printer) async {
    try {
      const PaperSize paper = PaperSize.mm80;
      final profile = await CapabilityProfile.load();
      final networkPrinter = NetworkPrinter(paper, profile);

      final res = await networkPrinter.connect(printer.ip ?? '', port: int.tryParse(printer.port ?? '9100') ?? 9100);
      if (res == PosPrintResult.success) {
        await Future.wait((foodOrder.partyOrders ?? []).map((partyOrder) async {
          final items = (partyOrder.orderItems ?? <OrderItem>[]).where((element) {
            final printerIds = element.food?.foodType?.printersIs ?? <String>[];
            return printerIds.isEmpty || printerIds.contains(printer.id);
          }).toList();
          if (items.isEmpty) return;
          items.sort((a, b) => (a.sortOder) > (b.sortOder) ? 1 : -1);
          await _printReceipt(foodOrder, partyOrder, items, printer, networkPrinter);
        }));
        networkPrinter.disconnect();
      }
      printerRepository.log('Sucess', '', printer.id ?? '');
    } catch (e) {
      print(e.toString());
      printerRepository.log('Error', e.toString(), printer.id ?? '');
    }
  }

  Future<void> _printReceipt(FoodOrder foodOrder, PartyOrder partyOrder, List<OrderItem> orderItems, Printer printer,
      NetworkPrinter networkPrinter) async {
    void createRowTitle(NetworkPrinter networkPrinter, String title, String content,
        {PosTextSize contentSize = PosTextSize.size1, PosColumn? custom, int contentWidth = 8}) {
      networkPrinter.row([
        PosColumn(text: title, width: 4),
        PosColumn(text: content, width: contentWidth, styles: PosStyles(height: contentSize, width: contentSize)),
        if (custom != null) custom
      ]);
    }

    void createOrderItemRow(NetworkPrinter networkPrinter, OrderItem orderItem) {
      final price = orderItem.food?.price ?? 0;
      final quantity = orderItem.quantity;
      networkPrinter.text('${quantity}x' + "  " + (orderItem.food?.name ?? ''),
          styles: PosStyles(height: PosTextSize.size2, width: PosTextSize.size2));

      final priceText = Utils.getCurrency(orderItem.food?.price, removeCurrencyFormat: true);
      networkPrinter.row([
        PosColumn(
            text: '($priceText) ${Utils.getCurrency(price * quantity, removeCurrencyFormat: true)}',
            width: 12,
            styles: PosStyles(align: PosAlign.right, height: PosTextSize.size2, width: PosTextSize.size2)),
      ]);
      // networkPrinter.text('($priceText x $quantity) ${Utils.getCurrency(price * quantity, removeCurrencyFormat: true)}',
      //     styles: PosStyles(align: PosAlign.right));
      networkPrinter.hr();
    }

    final date = DateTime.tryParse(foodOrder.createdAt ?? '') ?? DateTime.now();
    networkPrinter.feed(4);
    createRowTitle(networkPrinter, 'Bon', (foodOrder.bondNumber ?? 1).toString(),
        contentWidth: 4, contentSize: PosTextSize.size2, custom: PosColumn(text: 'Gangbon', width: 4));
    createRowTitle(networkPrinter, 'Datum', DateFormat(PRINTER_DAY_FORMAT).format(date),
        contentSize: PosTextSize.size1);
    createRowTitle(networkPrinter, 'Bedient von', foodOrder.userOrder?.role ?? USER_ROLE.STAFF,
        contentSize: PosTextSize.size1);
    createRowTitle(networkPrinter, 'Terminal', '15a24e3a', contentSize: PosTextSize.size1);
    createRowTitle(networkPrinter, 'Tisch', 'Tisch ${foodOrder.tableNumber ?? '0'}', contentSize: PosTextSize.size2);
    if (partyOrder.partyNumber != null) {
      createRowTitle(networkPrinter, 'Partei', 'Partei ${(partyOrder.partyNumber ?? 0) + 1}',
          contentSize: PosTextSize.size2);
    }

    networkPrinter.hr();
    for (final item in orderItems) {
      createOrderItemRow(networkPrinter, item);
    }
    networkPrinter.feed(2);
    networkPrinter.cut();
  }
}
