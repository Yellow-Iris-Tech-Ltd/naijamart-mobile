

abstract class WalkthroughState{}

class WalkThroughInitialState extends WalkthroughState{}

class WalkThroughPageChanged extends WalkthroughState {
  final int index;
  WalkThroughPageChanged(this.index);
}

class WalkThroughFinished extends WalkthroughState{}