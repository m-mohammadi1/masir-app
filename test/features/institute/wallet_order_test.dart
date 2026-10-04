import 'package:flutter_test/flutter_test.dart';
import 'package:mohammad/features/institute/data/models/wallet_card_model.dart';
import 'package:mohammad/features/institute/domain/entities/wallet_card.dart';
import 'package:mohammad/features/institute/presentation/page/wallet_page.dart';

WalletCardModel _card(String id, {bool learning = false}) => WalletCardModel(
  instituteId: id,
  name: id,
  nextAction: learning
      ? WalletNextAction(courseId: 'c-$id', progressPercent: 10)
      : null,
);

void main() {
  test('current first, then learning, then not started, ties keep order', () {
    final cards = [
      _card('a'),
      _card('b', learning: true),
      _card('c'),
      _card('d', learning: true),
      _card('e', learning: true),
    ];
    final ids = orderWalletCards(cards, 'e').map((e) => e.instituteId);
    expect(ids, ['e', 'b', 'd', 'a', 'c']);
  });

  test('no current institute: learning first', () {
    final cards = [_card('a'), _card('b', learning: true)];
    expect(orderWalletCards(cards, null).map((e) => e.instituteId), ['b', 'a']);
  });
}
