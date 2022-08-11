class AppSettings {
  bool swap_erc20_bep20 = false;
  bool buy_pro_premium = false;
  bool buy_vpn = false;
  bool lottery = false;
  late String bc_rpc;
  late String bsc_rpc;
  late String eth_rpc;
  late String eth_dapp_rpc;
  late String sol_rpc;
  int? lastNewsId;
  AppSettings();
  AppSettings.fromJson(Map<String, dynamic> json) {
    swap_erc20_bep20 = json['swap_erc20_bep20'] ?? false;
    buy_pro_premium = json['buy_pro_premium'] ?? false;
    buy_vpn = json['buy_vpn'] ?? false;
    lottery = json['lottery'] ?? false;
    lastNewsId = json['last_news_id'] ?? 0;
    bc_rpc = json['bc_rpc'] ?? 'dex.binance.org/api';
    //bc_rpc = json['bc_env'] ?? 'ep0.tbcc.com/api';
    bsc_rpc = json['bsc_rpc'] ?? 'https://bsc-dataseed1.defibit.io';
    //bsc_rpc = 'https://epbal.tbcc.com';
    eth_rpc = json['eth_rpc'] ?? 'https://mainnet.infura.io/v3/6548e442303c4fd0906cdbc6f78ea968';
    //eth_rpc = 'https://ep1.tbcc.com';
    eth_dapp_rpc = json['eth_dapp_rpc'] ?? 'https://mainnet.infura.io/v3/24a2a8ee9d3f4e35a18fbb02376cf768';
    sol_rpc = json['sol_rpc'] ?? 'https://api.mainnet-beta.solana.com';
  }

  void from(AppSettings settings) {
    swap_erc20_bep20 = settings.swap_erc20_bep20;
    buy_pro_premium = settings.buy_pro_premium;
    buy_vpn = settings.buy_vpn;
    lottery = settings.lottery;
    lastNewsId = settings.lastNewsId;
    bc_rpc = settings.bc_rpc;
    bsc_rpc = settings.bsc_rpc;
    eth_rpc = settings.eth_rpc;
    eth_dapp_rpc = settings.eth_dapp_rpc;
    sol_rpc = settings.sol_rpc;
  }
}

class LotterySettings {
  /// 0 = active
  /// 1 = waiting results
  /// 2 = results
  /// 3 = ended
  late int status;

  late DateTime startTickets;
  late DateTime endTickets;
  late DateTime startCount;
  late DateTime endCount;
  late DateTime end;
  late int userCount;
  late int ticketPrice;

  LotterySettings.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    ticketPrice = json['ticket_price'];
    startTickets = DateTime.parse(json['start_tickets']);
    endTickets = DateTime.parse(json['end_tickets']);
    startCount = DateTime.parse(json['start_count']);
    endCount = DateTime.parse(json['end_count']);
    end = DateTime.parse(json['end']);
    userCount = json['user_count'];
  }
}
