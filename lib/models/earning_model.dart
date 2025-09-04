class GuardPaymentData {
  final Guard guard;
  final List<Payment> payments;

  GuardPaymentData({required this.guard, required this.payments});

  factory GuardPaymentData.fromJson(Map<String, dynamic> json) {
    final guard = Guard.fromJson(json['guard']);
    final payments = (json['payments'] as List)
        .map((e) => Payment.fromJson(e))
        .toList();
    return GuardPaymentData(guard: guard, payments: payments);
  }

  Map<String, dynamic> toJson() => {
    'guard': guard.toJson(),
    'payments': payments.map((e) => e.toJson()).toList(),
  };
}

class Guard {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? profileImage;
  final String totalBalance;

  Guard({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.totalBalance,
  });

  factory Guard.fromJson(Map<String, dynamic> json) => Guard(
    id: json['id'],
    fullName: json['fullName'],
    email: json['email'],
    phone: json['phone'],
    profileImage: json['profileImage'],
    totalBalance: json['totalBalance'] ?? '0.00',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'profileImage': profileImage,
    'totalBalance': totalBalance,
  };
}

class Payment {
  final String id;
  final String amount;
  final String paymentDate;
  final String status;
  final String bankName;
  final String accountNumber;
  final String reference;
  final String transferProof;
  final Contractor contractor;

  Payment({
    required this.id,
    required this.amount,
    required this.paymentDate,
    required this.status,
    required this.bankName,
    required this.accountNumber,
    required this.reference,
    required this.transferProof,
    required this.contractor,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json['id'],
    amount: json['amount'],
    paymentDate: json['paymentDate'],
    status: json['status'],
    bankName: json['bankName'],
    accountNumber: json['accountNumber'],
    reference: json['reference'],
    transferProof: json['transferProof'],
    contractor: Contractor.fromJson(json['contractor']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'paymentDate': paymentDate,
    'status': status,
    'bankName': bankName,
    'accountNumber': accountNumber,
    'reference': reference,
    'transferProof': transferProof,
    'contractor': contractor.toJson(),
  };
}

class Contractor {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;

  Contractor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
  });

  factory Contractor.fromJson(Map<String, dynamic> json) => Contractor(
    id: json['id'],
    name: json['name'] ?? '',
    email: json['email'],
    phone: json['phone'],
    profileImage: json['profileImage'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'profileImage': profileImage,
  };
}