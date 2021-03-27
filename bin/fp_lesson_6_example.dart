void main(List<String> arguments) {
  final invoicePath = InvoicingPath();
  final availabilityPath = AvailabilityPath();
  final confMap = setConfiguration();
  final order = confMap.keys.first;
  final processConfiguration = confMap.values.first;

  final costOfOrder = calcAdjustedCostOfOrder(
      processConfiguration, invoicePath, availabilityPath);

  print(costOfOrder(order));
}

//Setup of the Process Configuration and Data
Map<Order, ProcessConfiguration> setConfiguration() {
  final processConfiguration = ProcessConfiguration();
  final customer = Customer();
  final order = Order();
  processConfiguration.invoiceChoice = InvoiceChoice.Inv3;
  processConfiguration.shippingChoice = ShippingChoice.Sh2;
  processConfiguration.freightChoice = FreightChoice.FR3;
  processConfiguration.availabilityChoice = AvailabilityChoice.AV2;
  processConfiguration.shippingDateChoice = ShippingDateChoice.SD2;
  order.customer = customer;
  order.date = DateTime(2021, 3, 16);
  order.cost = 2000;
  return {order: processConfiguration};
}

//Adjusted Cost for Order
double Function(Order) calcAdjustedCostOfOrder(
  ProcessConfiguration c,
  InvoicingPath invoicePath,
  AvailabilityPath availabilityPath,
) {
  return (x) => adjustCost(x, invoicePathFunc(c, invoicePath),
      availabilityPathFunc(c, availabilityPath));
}

//Adjusted Cost
double adjustCost(Order r, Freight Function(Order) calcFreight,
    ShippingDate Function(Order) calcShippingDate) {
  final f = calcFreight(r);
  final s = calcShippingDate(r);
  print('\n\nDay of Shipping : ' + getDayName(s.date.weekday) + '\n');

  final cost =
      (s.date.weekday == DateTime.monday) ? f.cost + 1000 : f.cost + 500;

  ///Final Cost
  return cost;
}

/// Return InvoicePath Composed Function
Freight Function(Order) invoicePathFunc(
  ProcessConfiguration c,
  InvoicingPath fpl,
) {
  final p = fpl.invoiceFunctions[c.invoiceChoice]
      .compose(fpl.shippingFunctions[c.shippingChoice])
      .compose(fpl.freightFunctions[c.freightChoice]);
  return p;
}

///  Return AvailabilityPath Composed Function
ShippingDate Function(Order) availabilityPathFunc(
  ProcessConfiguration c,
  AvailabilityPath spl,
) {
  final p = spl.availabilityFunctions[c.availabilityChoice]
      .compose(spl.shippingDateFunctions[c.shippingDateChoice]);

  return p;
}

///extension method
///note. "this" stands for the current function "f1" which we are calling compose from
extension MyFunction on Function {
  T3 Function(T1) compose<T1, T2, T3>(T3 Function(T2) f2) {
    var f1 = this;
    return (x) => f2(f1(x));
  }
}

//region Basic Data
class InvoicingPath {
  final invoiceFunctions = <InvoiceChoice, Invoice Function(Order)>{};
  final shippingFunctions = <ShippingChoice, Shipping Function(Invoice)>{};
  final freightFunctions = <FreightChoice, Freight Function(Shipping)>{};

  InvoicingPath() {
    invoiceFunctions.addAll({
      InvoiceChoice.Inv1: calcInvoice1,
      InvoiceChoice.Inv2: calcInvoice2,
      InvoiceChoice.Inv3: calcInvoice3,
      InvoiceChoice.Inv4: calcInvoice4,
      InvoiceChoice.Inv5: calcInvoice5,
    });
    shippingFunctions.addAll({
      ShippingChoice.Sh1: calcShipping1,
      ShippingChoice.Sh2: calcShipping2,
      ShippingChoice.Sh3: calcShipping3,
    });
    freightFunctions.addAll({
      FreightChoice.FR1: calcFreightCost1,
      FreightChoice.FR2: calcFreightCost2,
      FreightChoice.FR3: calcFreightCost3,
      FreightChoice.FR4: calcFreightCost4,
      FreightChoice.FR5: calcFreightCost5,
      FreightChoice.FR6: calcFreightCost6,
    });
  }
}

class AvailabilityPath {
  final availabilityFunctions =
      <AvailabilityChoice, Availability Function(Order)>{};

  final shippingDateFunctions =
      <ShippingDateChoice, ShippingDate Function(Availability)>{};

  AvailabilityPath() {
    availabilityFunctions.addAll({
      AvailabilityChoice.AV1: calcAvailability1,
      AvailabilityChoice.AV2: calcAvailability2,
      AvailabilityChoice.AV3: calcAvailability3,
      AvailabilityChoice.AV4: calcAvailability4,
    });
    shippingDateFunctions.addAll({
      ShippingDateChoice.SD1: calcShippingDate1,
      ShippingDateChoice.SD2: calcShippingDate2,
      ShippingDateChoice.SD3: calcShippingDate3,
      ShippingDateChoice.SD4: calcShippingDate4,
      ShippingDateChoice.SD5: calcShippingDate5,
    });
  }
}

Invoice calcInvoice1(Order o) {
  print('Invoice 1');
  final invoice = Invoice();
  invoice.cost = o.cost * 1.1;
  return invoice;
}

Invoice calcInvoice2(Order o) {
  print('Invoice 2');
  final invoice = Invoice();
  invoice.cost = o.cost * 1.2;
  return invoice;
}

Invoice calcInvoice3(Order o) {
  print('Invoice 3');
  final invoice = Invoice();
  invoice.cost = o.cost * 1.3;
  return invoice;
}

Invoice calcInvoice4(Order o) {
  print('Invoice 4');
  final invoice = Invoice();
  invoice.cost = o.cost * 1.4;
  return invoice;
}

Invoice calcInvoice5(Order o) {
  print('Invoice 5');
  final invoice = Invoice();
  invoice.cost = o.cost * 1.5;
  return invoice;
}

Shipping calcShipping1(Invoice o) {
  print('Shipping 1');
  final s = Shipping();
  s.ShipperID = (o.cost > 1000) ? 1 : 2;
  s.cost = o.cost;

  return s;
}

Shipping calcShipping2(Invoice i) {
  print('Shipping 2');
  final s = Shipping();

  s.ShipperID = (i.cost > 1100) ? 1 : 2;
  s.cost = i.cost;

  return s;
}

Shipping calcShipping3(Invoice i) {
  print('Shipping 3');
  final s = Shipping();
  s.ShipperID = (i.cost > 1200) ? 1 : 2;
  s.cost = i.cost;

  return s;
}

Freight calcFreightCost1(Shipping s) {
  print('Freight 1');
  final f = Freight();
  f.cost = (s.ShipperID == 1) ? s.cost * 0.25 : s.cost * 0.5;
  return f;
}

Freight calcFreightCost2(Shipping s) {
  print('Freight 2');
  final f = Freight();
  f.cost = (s.ShipperID == 1) ? s.cost * 0.28 : s.cost * 0.52;
  return f;
}

Freight calcFreightCost3(Shipping s) {
  print('Freight 3');
  final f = Freight();
  f.cost = (s.ShipperID == 1) ? s.cost * 0.3 : s.cost * 0.6;
  return f;
}

Freight calcFreightCost4(Shipping s) {
  print('Freight 4');
  final f = Freight();
  f.cost = (s.ShipperID == 1) ? s.cost * 0.35 : s.cost * 0.65;
  return f;
}

Freight calcFreightCost5(Shipping s) {
  print('Freight 5');
  final f = Freight();
  f.cost = (s.ShipperID == 1) ? s.cost * 0.15 : s.cost * 0.2;
  return f;
}

Freight calcFreightCost6(Shipping s) {
  print('Freight 6');
  final f = Freight();
  f.cost = (s.ShipperID == 1) ? s.cost * 0.1 : s.cost * 0.15;
  return f;
}

Availability calcAvailability1(Order o) {
  print('Availability 1');
  final a = Availability();
  a.date = o.date.add(Duration(days: 3));
  return a;
}

Availability calcAvailability2(Order o) {
  print('Availability 2');
  final a = Availability();
  a.date = o.date.add(Duration(days: 2));
  return a;
}

Availability calcAvailability3(Order o) {
  print('Availability 3');
  final a = Availability();
  a.date = o.date.add(Duration(days: 1));
  return a;
}

Availability calcAvailability4(Order o) {
  print('Availability 4');
  final a = Availability();
  a.date = o.date.add(Duration(days: 4));
  return a;
}

ShippingDate calcShippingDate1(Availability o) {
  print('ShippingDate 1');
  final a = ShippingDate();
  a.date = o.date.add(Duration(days: 1));
  return a;
}

ShippingDate calcShippingDate2(Availability o) {
  print('ShippingDate 2');
  final a = ShippingDate();
  a.date = o.date.add(Duration(days: 2));
  return a;
}

ShippingDate calcShippingDate3(Availability o) {
  print('ShippingDate 3');
  final a = ShippingDate();
  a.date = o.date.add(Duration(hours: 14));
  return a;
}

ShippingDate calcShippingDate4(Availability o) {
  print('ShippingDate 4');
  final a = ShippingDate();
  a.date = o.date.add(Duration(hours: 20));
  return a;
}

ShippingDate calcShippingDate5(Availability o) {
  print('ShippingDate 5');
  final a = ShippingDate();
  a.date = o.date.add(Duration(hours: 10));
  return a;
}
//end region

//  Classes
class ProcessConfiguration {
  InvoiceChoice invoiceChoice;
  ShippingChoice shippingChoice;
  FreightChoice freightChoice;
  AvailabilityChoice availabilityChoice;
  ShippingDateChoice shippingDateChoice;
}

class Customer {}

class Order {
  Customer customer;
  DateTime date;
  double cost;
}

class Invoice {
  double cost;
  Invoice() {
    cost = 0;
  }
}

class Shipping {
  double cost;
  int ShipperID;
  Shipping() {
    cost = 0;
  }
}

class Freight {
  double cost;

  Freight() {
    cost = 0;
  }
}

class Availability {
  DateTime date;
  Availability();
}

class ShippingDate {
  DateTime date;

  ShippingDate();
}

enum InvoiceChoice { Inv1, Inv2, Inv3, Inv4, Inv5 }
enum ShippingChoice { Sh1, Sh2, Sh3 }
enum FreightChoice { FR1, FR2, FR3, FR4, FR5, FR6 }
enum AvailabilityChoice { AV1, AV2, AV3, AV4 }
enum ShippingDateChoice { SD1, SD2, SD3, SD4, SD5 }

String getDayName(int weekday) {
  switch (weekday) {
    case 1:
      return 'monday';
    case 2:
      return 'tuesday';
    case 3:
      return 'wednesday';
    case 4:
      return 'thursday';
    case 5:
      return 'friday';
    case 6:
      return 'saturday';
    case 7:
      return 'sunday';
    default:
      throw Exception('This day is now exist');
  }
}
