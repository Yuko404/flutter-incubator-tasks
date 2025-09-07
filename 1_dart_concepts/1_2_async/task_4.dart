import 'dart:io';
import 'dart:isolate';
import 'dart:math';

const int markOfNotPrime = 0;
const int defaultUpperBound = 100000;

/// Receives a random upper bound for the interval to search for prime numbers.
int generateRandomUpperBound() {
  return Random().nextInt(defaultUpperBound) + 1;
}

/// Finding base prime numbers up to `limit`
/// for the segmented sieve algorithm.
List<int> findBasePrimes(int border) {
  List<int> sieve = List.generate(border + 1, (int index) => index);
  final int limit = sieve.length - 1;

  // Strike out even numbers greater than 2
  // for optimization.
  for (int num = 4; num <= border; num += 2) {
    sieve[num] = markOfNotPrime;
  }

  // 0, 1 is not Prime
  sieve[0] = markOfNotPrime;
  sieve[1] = markOfNotPrime;

  // Go to sqrt(limit), as all non-prime numbers up to `limit`
  // will have a factor less than or equal to sqrt(limit).
  int sqrtLimit = sqrt(limit).toInt();
  // Starting from 3, because we have already strike out even numbers.
  for (int num = 3; num <= sqrtLimit; num++) {
    if (sieve[num] != markOfNotPrime) {
      for (int index = num * num; index <= limit; index += 2 * num) {
        sieve[index] = markOfNotPrime;
      }
    }
  }

  List<int> basePrimes = [];
  for (final num in sieve) {
    if (num != markOfNotPrime) {
      basePrimes.add(num);
    }
  }
  return basePrimes;
}

/// Finding prime numbers in the segment `sieve`
/// `offset` is the starting number of the segment represented by `sieve`.
int findSumOfPrimesInInterval(
  List<int> basePrimes,
  int currentStart,
  int currentEnd,
) {
  int offset = currentStart;
  List<int> segment = List.generate(
    currentEnd - currentStart,
    (index) => ((currentStart + index) % 2 == 0) ? 0 : (currentStart + index),
  );
  for (final prime in basePrimes.sublist(1)) {
    // Find the first number in the segment that is a multiple of `prime`.
    int startNum = (offset + prime - 1) ~/ prime * prime;

    // Find the index in the sieve corresponding to `startNum`.
    int startIndexInSieve = startNum - offset;

    // Strikeing out numbers that are multiples of the given prime number `prime`
    for (int i = startIndexInSieve; i < segment.length; i += prime) {
      segment[i] = markOfNotPrime;
    }
  }

  return calculateSumOfPrimes(segment);
}

/// Filters out and returns the list of prime numbers from the segment.
int calculateSumOfPrimes(List<int> sieve) {
  int sumOfPrimes = 0;
  for (final num in sieve) {
    if (num != markOfNotPrime) {
      sumOfPrimes += num;
    }
  }
  return sumOfPrimes;
}

void main() async {
  final int borderOfInterval = generateRandomUpperBound();
  int sumOfPrimes = 0;

  // Define the number of isolates to use.
  int numberOfIsolates = Platform.numberOfProcessors ~/ 2;
  if (numberOfIsolates == 0) numberOfIsolates = 1;

  print('The number of Isolates: $numberOfIsolates');
  print('Upper bound: $borderOfInterval');

  final int sqrtBorder = sqrt(borderOfInterval).toInt();
  final List<int> basePrimes = findBasePrimes(sqrtBorder);
  sumOfPrimes = basePrimes.fold(0, (prev, curr) => prev + curr);

  final int startOfRawPart = sqrtBorder + 1;
  final int rangeToProcess = borderOfInterval - startOfRawPart + 1;
  final int partsOfInterval = (rangeToProcess / numberOfIsolates).ceil();

  final tasks = <Future<int>>[];

  if (rangeToProcess > 0) {
    for (
      int numOfCurrSegment = 0;
      numOfCurrSegment < numberOfIsolates;
      numOfCurrSegment++
    ) {
      final int currentStart =
          startOfRawPart + numOfCurrSegment * partsOfInterval;

      if (currentStart > borderOfInterval) continue;

      final int currentEnd =
          (currentStart + partsOfInterval > borderOfInterval + 1)
          ? (borderOfInterval + 1)
          : (currentStart + partsOfInterval);

      tasks.add(
        Isolate.run(
          () => findSumOfPrimesInInterval(basePrimes, currentStart, currentEnd),
        ),
      );
    }
    final results = await Future.wait(tasks);
    sumOfPrimes = results.fold(sumOfPrimes, (prev, curr) => prev + curr);
  }

  print('Sum of primes: $sumOfPrimes');
}
