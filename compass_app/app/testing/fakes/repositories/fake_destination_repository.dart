import 'package:compass_model/model.dart';
import 'package:compass_app/data/repositories/destination/destination_repository.dart';
import 'package:compass_app/utils/result.dart';
import 'package:flutter/foundation.dart';

import '../../models/destination.dart';

class FakeDestinationRepository implements DestinationRepository {
  @override
  Future<Result<List<Destination>>> getDestinations() {
    return SynchronousFuture(Result.ok([kDestination1, kDestination2]));
  }
}
