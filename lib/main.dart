// Personal Finance Tracker
// By Majid Aliyev

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: FinanceTrackerApp()));
}

class FinanceTrackerApp extends ConsumerWidget {
  const FinanceTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Finance Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const HomeScreen(),
    );
  }
}

// Sample data for demo purposes
final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, List<Transaction>>((ref) {
  return TransactionsNotifier();
});

class TransactionsNotifier extends StateNotifier<List<Transaction>> {
  TransactionsNotifier()
      : super([
          Transaction('Amazon', 'Shopping', -120.00, Icons.shopping_bag,
              const Color(0xFF00FF88)),
          Transaction('Uber', 'Transport', -25.00, Icons.directions_car,
              const Color(0xFF00D4FF)),
          Transaction('Starbucks', 'Food & Drinks', -8.00, Icons.coffee,
              const Color(0xFFFF8C00)),
          Transaction('Spotify', 'Entertainment', -10.00, Icons.music_note,
              const Color(0xFF9D4EDD)),
          Transaction('Salary', 'Income', 5000.00, Icons.account_balance,
              const Color(0xFF00FF88)),
        ]);

  void addTransaction(Transaction transaction) {
    state = [transaction, ...state];
  }

  void removeTransaction(int index) {
    state = List.from(state)..removeAt(index);
  }
}

class Transaction {
  final String title;
  final String category;
  final double amount;
  final IconData icon;
  final Color color;

  Transaction(this.title, this.category, this.amount, this.icon, this.color);
}

// Main home screen with all the UI
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider);

    final totalIncome = transactions
        .where((t) => t.amount > 0)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpenses = transactions
        .where((t) => t.amount < 0)
        .fold(0.0, (sum, t) => sum + t.amount.abs());

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF1A1A1A),
              Color(0xFF0F0F0F),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                _buildBalanceCard(context, totalIncome - totalExpenses),
                const SizedBox(height: 24),
                _buildStatsRow(context, totalIncome, totalExpenses),
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 24),
                _buildTransactionsList(context, transactions),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00FF88), Color(0xFF00D4FF)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00FF88).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: const Icon(Icons.person, color: Colors.black, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Majid',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF00FF88)),
                    SizedBox(width: 12),
                    Text('🔔 No new notifications'),
                  ],
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color(0xFF1A1A1A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Icon(Icons.notifications_outlined,
                color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context, double balance) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Balance Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                _buildDetailRow('Current Balance',
                    '\$${balance.toStringAsFixed(2)}', const Color(0xFF00FF88)),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF0F0F0F),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: -10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Balance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00FF88).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF00FF88).withOpacity(0.3),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up,
                          size: 14, color: Color(0xFF00FF88)),
                      SizedBox(width: 4),
                      Text(
                        '+12.5%',
                        style: TextStyle(
                          color: Color(0xFF00FF88),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '\$${balance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -2,
                    height: 1.1,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, double income, double expenses) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.arrow_downward_rounded,
            label: 'Income',
            amount: '\$${income.toStringAsFixed(2)}',
            color: const Color(0xFF00FF88),
            isIncome: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.arrow_upward_rounded,
            label: 'Expenses',
            amount: '\$${expenses.toStringAsFixed(2)}',
            color: const Color(0xFFFF6B6B),
            isIncome: false,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String amount,
    required Color color,
    required bool isIncome,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _showAddTransaction(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  'Add Transaction',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddTransaction(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = 'Shopping';
    bool isExpense = true; // Track whether it's an expense or income

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Add Transaction',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                // Type selection buttons
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setModalState(() => isExpense = true);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isExpense
                                ? const Color(0xFFFF6B6B).withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isExpense
                                  ? const Color(0xFFFF6B6B)
                                  : Colors.grey[800]!,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.remove_circle,
                                color: isExpense
                                    ? const Color(0xFFFF6B6B)
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Money Spent',
                                style: TextStyle(
                                  color: isExpense
                                      ? const Color(0xFFFF6B6B)
                                      : Colors.grey[600],
                                  fontWeight: isExpense
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setModalState(() => isExpense = false);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: !isExpense
                                ? const Color(0xFF00FF88).withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: !isExpense
                                  ? const Color(0xFF00FF88)
                                  : Colors.grey[800]!,
                            ),
                          ),
                          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle,
                                color: !isExpense
                                    ? const Color(0xFF00FF88)
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Money Received',
                                style: TextStyle(
                                  color: !isExpense
                                      ? const Color(0xFF00FF88)
                                      : Colors.grey[600],
                                  fontWeight: !isExpense
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[800]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[800]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF6366F1)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixText: '\$',
                    prefixStyle: TextStyle(color: Colors.grey[400]),
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[800]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[800]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF6366F1)),
                    ),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        amountController.text.isNotEmpty) {
                      final amount = double.parse(amountController.text);
                      ref.read(transactionsProvider.notifier).addTransaction(
                            Transaction(
                              titleController.text,
                              selectedCategory,
                              isExpense ? -amount : amount,
                              isExpense
                                  ? Icons.shopping_bag
                                  : Icons.account_balance,
                              isExpense
                                  ? const Color(0xFFFF6B6B)
                                  : const Color(0xFF00FF88),
                            ),
                          );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Color(0xFF00FF88)),
                              SizedBox(width: 12),
                              Text('Transaction added successfully'),
                            ],
                          ),
                          backgroundColor: const Color(0xFF1A1A1A),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 16),
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add Transaction',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsList(
      BuildContext context, List<Transaction> transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transactions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '${transactions.length} items',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...transactions.asMap().entries.map((entry) {
          final index = entry.key;
          final transaction = entry.value;
          return _buildTransactionItem(context, transaction, index);
        }),
      ],
    );
  }

  Widget _buildTransactionItem(
      BuildContext context, Transaction transaction, int index) {
    return InkWell(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text('Delete Transaction?',
                style: TextStyle(color: Colors.white)),
            content: Text(
              'Are you sure you want to delete "${transaction.title}"?',
              style: TextStyle(color: Colors.grey[400]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    Text('Cancel', style: TextStyle(color: Colors.grey[400])),
              ),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(transactionsProvider.notifier)
                      .removeTransaction(index);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.delete, color: Color(0xFFFF6B6B)),
                          const SizedBox(width: 12),
                          Text('Deleted "${transaction.title}"'),
                        ],
                      ),
                      backgroundColor: const Color(0xFF1A1A1A),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: transaction.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(transaction.icon, color: transaction.color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.category,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              transaction.amount > 0
                  ? '+\$${transaction.amount.toStringAsFixed(2)}'
                  : '\$${transaction.amount.abs().toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: transaction.amount > 0
                    ? const Color(0xFF00FF88)
                    : const Color(0xFFFF6B6B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
