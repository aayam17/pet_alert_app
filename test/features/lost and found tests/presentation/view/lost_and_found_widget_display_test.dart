import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/lost and found/domian/entity/lost_and_found_entity.dart';
import 'package:pet_alert_app/features/lost and found/presentation/view_model/lost_and_found_cubit.dart';
import 'package:pet_alert_app/features/lost and found/presentation/view_model/lost_and_found_state.dart';
import 'package:pet_alert_app/features/lost%20and%20found/presentation/view/lost_and_found.dart';

class MockLostAndFoundCubit extends Mock implements LostAndFoundCubit {}

void main() {
  testWidgets('displays entry data when loaded', (tester) async {
    final mockCubit = MockLostAndFoundCubit();

    when(() => mockCubit.state).thenReturn(
      LostAndFoundLoaded([
        LostAndFoundEntity(
          id: '1',
          type: 'Lost',
          description: 'Lost Cat',
          location: 'Temple Street',
          date: '2025-08-01',
          time: '8:00 AM',
          contactInfo: 'contact@lost.com',
        )
      ]),
    );
    when(() => mockCubit.stream).thenAnswer(
      (_) => Stream.value(
        LostAndFoundLoaded([
          LostAndFoundEntity(
            id: '1',
            type: 'Lost',
            description: 'Lost Cat',
            location: 'Temple Street',
            date: '2025-08-01',
            time: '8:00 AM',
            contactInfo: 'contact@lost.com',
          )
        ]),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<LostAndFoundCubit>.value(
          value: mockCubit,
          child: const LostAndFoundScreen(),
        ),
      ),
    );

    expect(find.text('Lost Cat'), findsOneWidget);
    expect(find.textContaining('Temple Street'), findsOneWidget);
    expect(find.textContaining('8:00 AM'), findsOneWidget);
  });
}
