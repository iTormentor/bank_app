class DummyData {

  final List<User> allUsers = [];


  void initializeDummyData() {
    final user1 = User("Per", "per@per.no");
    final user2 = User("Ole", "ole@ole.no");

    allUsers.add(user1);
    allUsers.add(user2);

    user1.createNewWallet("Savingsaccount", balance: 100000);
    user1.createNewWallet("Spendingsaccount", balance: 2000);
  }



  List<Wallet> getAllWalletsForUser(int id) {
    User? foundUser;
    for (User user in allUsers) {
      if (user.userId == id) {
        foundUser = user;
      }
    }
    if (foundUser != null) {
      return foundUser.wallets;
    }
    else {
      throw Exception("User not found");
    }
  }
}

class User {

  static int _totalUsers = 1;

  final int userId;
  final String name;
  final String email;
  List<Wallet> wallets = [];

  User(this.name, this.email) : userId = _totalUsers++;

  void createNewWallet(String walletName, {balance}){

    wallets.add(Wallet(this, walletName, balance: balance));
  }

  }

class Wallet {
  static int _walletNumber = 1;

  final User owner;
  final int walletId;
  double balance;
  String accountName;

  Wallet(this.owner, this.accountName, {this.balance = 1000}) : walletId = _walletNumber++;
}


// TODO Create methods one card for user
// TODO Create method to transfer money between users own cards
// TODO Create method to pay from own account to outside account