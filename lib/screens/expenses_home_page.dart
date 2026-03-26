import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_expense_page.dart';
import 'all_expenses_page.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';

class ExpensesHomePage extends StatefulWidget {
  const ExpensesHomePage({super.key});

  @override
  State<ExpensesHomePage> createState() => _ExpensesHomePageState();
}

class _ExpensesHomePageState extends State<ExpensesHomePage> {

  @override
  void initState() {
    super.initState();
    // Load expenses from SQLite when the home page first opens
    Future.microtask(() =>
        context.read<ExpenseProvider>().loadExpenses(),
    );
  }

  String _getDayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expenseDate = DateTime(date.year, date.month, date.day);

    if (expenseDate == today) return 'Today';
    if (expenseDate == today.subtract(const Duration(days: 1))) return 'Yesterday';

    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return weekdays[date.weekday - 1];
  }

  void _showExpenseDetails(Expense expense) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8E1F4), Color(0xFFE5D1FA)],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Expense Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A2C4A)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFFB0578D)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(expense.category).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(_getCategoryIcon(expense.category),
                              color: _getCategoryColor(expense.category), size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(expense.title,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4A2C4A))),
                              const SizedBox(height: 4),
                              Text(expense.category, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Amount', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text('₱${expense.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFB0578D))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Date', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text(
                                '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}-${expense.date.day.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF4A2C4A)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _navigateToEditExpense(expense);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB0578D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('Update')],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteConfirmation(expense);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[100],
                        foregroundColor: Colors.red[800],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.delete, size: 18), SizedBox(width: 8), Text('Delete')],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Expense',
            style: TextStyle(color: Color(0xFF4A2C4A), fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${expense.title}"?',
            style: const TextStyle(color: Color(0xFF4A2C4A))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFFB0578D))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteExpense(expense.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[100],
              foregroundColor: Colors.red[800],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteExpense(String id) {
    // Call provider — updates DB + state + notifies UI
    context.read<ExpenseProvider>().deleteExpense(id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        backgroundColor: const Color(0xFFB0578D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _navigateToAddExpense() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpensePage()),
    );
    // No result needed — AddExpensePage calls provider directly
  }

  Future<void> _navigateToEditExpense(Expense expense) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddExpensePage(expense: expense)),
    );
    // No result needed — AddExpensePage calls provider directly
  }

  Future<void> _navigateToAllExpenses() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllExpensesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider — rebuilds when notifyListeners() is called
    final provider = context.watch<ExpenseProvider>();
    final expenses = provider.expenses;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8E1F4), Color(0xFFE5D1FA), Color(0xFFD1E0FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('EXPENSE TRACKER',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                                color: Color(0xFF6B4E71), letterSpacing: 0.5)),
                        const SizedBox(height: 4),
                        Text('Mar 6, 2026',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                      ],
                    ),
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person_outline, color: Color(0xFF6B4E71), size: 20),
                    ),
                  ],
                ),
              ),

              // Total Spent Card
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFD988B9).withValues(alpha: 0.9),
                        const Color(0xFFB0578D).withValues(alpha: 0.9),
                        const Color(0xFF8E44AD).withValues(alpha: 0.9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8E44AD).withValues(alpha: 0.3),
                        blurRadius: 12, offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('TOTAL SPENT',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                              color: Colors.white70, letterSpacing: 0.5)),
                      const SizedBox(height: 8),
                      Text('₱${provider.totalSpent.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('${expenses.length} expenses',
                                style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('This month',
                                style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Activity',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF4A2C4A))),
                    GestureDetector(
                      onTap: _navigateToAllExpenses,
                      child: const Text('See All',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                              color: Color(0xFF8E44AD), decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: expenses.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenses[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () => _showExpenseDetails(expense),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFB0578D).withValues(alpha: 0.1),
                                      blurRadius: 8, offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  leading: Container(
                                    width: 48, height: 48,
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(expense.category).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(_getCategoryIcon(expense.category),
                                        color: _getCategoryColor(expense.category), size: 24),
                                  ),
                                  title: Text(expense.title,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF4A2C4A))),
                                  subtitle: Text('${expense.category} • ${_getDayLabel(expense.date)}',
                                      style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                                  trailing: Text('₱${expense.amount.toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFB0578D))),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: _navigateToAddExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB0578D),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('+ Add Expense',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long, size: 40, color: Color(0xFFB0578D)),
          ),
          const SizedBox(height: 16),
          const Text('No expenses yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF4A2C4A))),
          const SizedBox(height: 8),
          Text('Tap the + button to add your first expense',
              style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food': return const Color(0xFFE67E22);
      case 'Transport': return const Color(0xFF27AE60);
      case 'Entertainment': return const Color(0xFF9B59B6);
      case 'Shopping': return const Color(0xFFE91E63);
      default: return const Color(0xFF3498DB);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food': return Icons.fastfood;
      case 'Transport': return Icons.directions_car;
      case 'Entertainment': return Icons.movie;
      case 'Shopping': return Icons.shopping_cart;
      default: return Icons.receipt;
    }
  }
}