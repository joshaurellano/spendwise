import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/database.dart';

class ExpenseProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Expense> _expenses = [];

  List<Expense> get expenses => List.unmodifiable(_expenses);

  double get totalSpent =>
      _expenses.fold(0, (sum, item) => sum + item.amount);

  // Load all expenses from SQLite on startup
  Future<void> loadExpenses() async {
    _expenses = await _dbHelper.fetchAllExpenses();
    notifyListeners();
  }

  // Add a new expense to DB + state
  Future<void> addExpense(Expense expense) async {
    await _dbHelper.insertExpense(expense);
    _expenses.insert(0, expense); // keep newest first
    notifyListeners();
  }

  // Update an existing expense in DB + state
  Future<void> updateExpense(Expense expense) async {
    await _dbHelper.updateExpense(expense);
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
      notifyListeners();
    }
  }

  // Delete an expense from DB + state
  Future<void> deleteExpense(String id) async {
    await _dbHelper.deleteExpense(id);
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}