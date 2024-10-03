import 'package:dartz/dartz.dart';
import 'package:flutter_twitter_app/core/errors/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
