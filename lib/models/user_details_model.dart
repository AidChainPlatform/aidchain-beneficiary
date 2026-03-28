import 'dart:convert';

import 'package:CHATS/models/campaign_model.dart';
import 'package:CHATS/models/wallet.dart';
import 'package:flutter/foundation.dart';

class UserDetails {
  double? totalWalletBalance;
  double? totalWalletReceived;
  double? totalWalletSpent;
  int? id;
  String? referalId;
  int? roleId;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? phone;
  String? bvn;
  String? nin;
  String? maritalStatus;
  String? gender;
  String? status;

  /// Keep as String to avoid UI type errors. Store JSON text here.
  String? location;

  String? pin;
  String? address;
  int? vendorId;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  bool? isBvnVerified;
  bool? isNinVerified;
  bool? isSelfSignup;
  bool? isPublic;
  bool? isTfaEnabled;
  String? lastLogin;
  String? profilePic;
  String? nfc;
  String? dob;
  String? createdAt;
  String? updatedAt;
  String? ip;

  List<Campaign>? campaigns;
  List<Wallet>? wallets = [];
  Wallet? userWallet;
  List<Map>? accounts;

  UserDetails({
    this.totalWalletBalance,
    this.totalWalletReceived,
    this.totalWalletSpent,
    this.id,
    this.referalId,
    this.roleId,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.phone,
    this.bvn,
    this.nin,
    this.maritalStatus,
    this.gender,
    this.status,
    this.location,
    this.pin,
    this.address,
    this.vendorId,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.isBvnVerified,
    this.isNinVerified,
    this.isSelfSignup,
    this.isPublic,
    this.isTfaEnabled,
    this.lastLogin,
    this.profilePic,
    this.nfc,
    this.dob,
    this.createdAt,
    this.updatedAt,
    this.ip,
    this.campaigns,
    this.wallets,
    this.userWallet,
    this.accounts,
  });

  /// Helper for code that needs a parsed location map.
  Map<String, dynamic>? get locationMap {
    final loc = location;
    if (loc == null || loc.isEmpty) return null;
    try {
      final decoded = jsonDecode(loc);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded as Map);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  UserDetails.fromJson(Map<String, dynamic> jsonData) {
    totalWalletBalance = jsonData['total_wallet_balance']?.toDouble();
    totalWalletReceived = jsonData['total_wallet_received']?.toDouble();
    totalWalletSpent = jsonData['total_wallet_spent']?.toDouble();
    id = jsonData['id'];
    referalId = jsonData['referal_id'];
    roleId = jsonData['RoleId'];
    firstName = jsonData['first_name'];
    lastName = jsonData['last_name'];
    username = jsonData['username'];
    email = jsonData['email'];
    phone = jsonData['phone'];
    bvn = jsonData['bvn'];
    nin = jsonData['nin'];
    maritalStatus = jsonData['marital_status'];
    gender = jsonData['gender'];
    status = jsonData['status'];

    // Location can arrive as String or Map. Always store JSON string in `location`.
    final loc = jsonData['location'];
    if (loc == null) {
      location = null;
    } else if (loc is String) {
      location = loc.isNotEmpty ? loc : null;
    } else if (loc is Map) {
      try {
        location = jsonEncode(loc);
      } catch (_) {
        location = null;
      }
    } else {
      location = null;
    }

    pin = jsonData['pin'];
    address = jsonData['address'];
    vendorId = jsonData['vendor_id'];
    isEmailVerified = jsonData['is_email_verified'];
    isPhoneVerified = jsonData['is_phone_verified'];
    isBvnVerified = jsonData['is_bvn_verified'];
    isNinVerified = jsonData['is_nin_verified'];
    isSelfSignup = jsonData['is_self_signup'];
    isPublic = jsonData['is_public'];
    isTfaEnabled = jsonData['is_tfa_enabled'];
    lastLogin = jsonData['last_login'];
    profilePic = jsonData['profile_pic'];
    nfc = jsonData['nfc'];
    dob = jsonData['dob'];
    createdAt = jsonData['createdAt'];
    updatedAt = jsonData['updatedAt'];

    // Campaigns
    if (jsonData['Campaigns'] != null) {
      campaigns = <Campaign>[];
      for (final v in (jsonData['Campaigns'] as List)) {
        campaigns!.add(Campaign.fromJson(Map<String, dynamic>.from(v as Map)));
      }
    } else {
      campaigns = <Campaign>[];
    }

    // Wallets
    if (jsonData['Wallets'] != null) {
      if (kDebugMode) print({"<<< WALLETS >>>", jsonData["Wallets"]});
      wallets = <Wallet>[];

      final hasCampaignsList = jsonData['Campaigns'] is List;
      final Set<int> activeCampaignIds = {};
      if (hasCampaignsList) {
        for (final c in (jsonData['Campaigns'] as List)) {
          try {
            if (c is Map &&
                (c['status'] == 'active' || c['status'] == 'ongoing')) {
              activeCampaignIds.add(c['id'] as int);
            }
          } catch (_) {}
        }
      }

      for (final w in (jsonData['Wallets'] as List)) {
        if (w is! Map) continue;
        final wm = Map<String, dynamic>.from(w as Map);

        final campaignId = wm['CampaignId'];

        // Personal/default wallet
        if (campaignId == null) {
          userWallet = Wallet.fromJson(wm);
          continue;
        }

        // Campaign wallet: show if campaign is active/ongoing when Campaigns is present.
        final includeWallet =
            !hasCampaignsList || activeCampaignIds.contains(campaignId);

        if (includeWallet) {
          wallets!.add(Wallet.fromJson(wm));
        }
      }
    } else {
      wallets = <Wallet>[];
    }

    // Accounts (if/when you need them)
    if (jsonData['Accounts'] != null) {
      accounts = <Map>[];
      // Populate here when model is defined.
    } else {
      accounts = <Map>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    if (phone != null) data['phone'] = phone;
    if (nin != null && nin!.isNotEmpty) data['nin'] = nin;
    if (gender != null) data['gender'] = gender;
    if (username != null) data['username'] = username;
    if (ip != null) data['ip'] = ip;
    if (dob != null && dob!.isNotEmpty) data['dob'] = dob;

    // NOTE: we intentionally do not send `location` from here;
    // server controls it, and it may be a Map or String upstream.
    if (kDebugMode) print({data, "Formatted data"});
    return data;
  }
}