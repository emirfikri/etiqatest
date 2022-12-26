part of 'dashboard_cubit.dart';

enum DashboardTab {
  todo,
  profile,
}

class DashboardState extends Equatable {
  const DashboardState({
    this.tab = DashboardTab.todo,
  });

  final DashboardTab tab;

  @override
  List<Object> get props => [tab];
}
