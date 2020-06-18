import '../pages/todo.dart' show TodoPage;
import '../pages/history.dart' show HistoryPage;

final routes = {
  '/': (context) => TodoPage(),
  '/history': (context) => HistoryPage(),
};
