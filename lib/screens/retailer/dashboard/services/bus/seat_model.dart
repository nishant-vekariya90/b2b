import 'package:equatable/equatable.dart';

import 'seat_widget.dart';

class SeatModel extends Equatable {
  final SeatState seatState;
  final int rowI;
  final int colI;
  final int seatSvgSize;
  final String pathSelectedSeat;
  final String pathAvailable;
  final String pathBookedFemale;
  final String pathBookedMale;
  final String pathAlreadyBooked;
  final String pathAvailableFemale;
  final String pathAvailableMale;

  const SeatModel({
    required this.seatState,
    required this.rowI,
    required this.colI,
    this.seatSvgSize = 50,
    required this.pathSelectedSeat,
    required this.pathAvailable,
    required this.pathBookedFemale,
    required this.pathBookedMale,
    required this.pathAvailableFemale,
    required this.pathAlreadyBooked,
    required this.pathAvailableMale,
  });

  @override
  List<Object?> get props => [
        seatState,
        rowI,
        colI,
        seatSvgSize,
        pathSelectedSeat,
        pathAvailable,
        pathBookedFemale,
        pathBookedMale,
        pathAvailableFemale,
        pathAlreadyBooked,
        pathAvailableMale,
      ];
}

class SeatLayoutStateModel extends Equatable {
  final int rows;
  final int cols;
  final List<List<SeatState>> currentSeatsState;
  final List<Map<String, dynamic>> seatsData; // List of seat data
  final int seatSvgSize;
  final String pathSelectedSeat;
  final String pathAvailable;
  final String pathBookedFemale;
  final String pathBookedMale;
  final String pathAvailableFemale;
  final String pathAlreadyBooked;
  final String pathAvailableMale;

  const SeatLayoutStateModel({
    required this.rows,
    required this.cols,
    required this.currentSeatsState,
    required this.seatsData,
    this.seatSvgSize = 50,
    required this.pathSelectedSeat,
    required this.pathAvailable,
    required this.pathBookedFemale,
    required this.pathBookedMale,
    required this.pathAvailableFemale,
    required this.pathAlreadyBooked,
    required this.pathAvailableMale,
  });

  @override
  List<Object?> get props => [
        rows,
        cols,
        seatSvgSize,
        currentSeatsState,
        seatsData,
        pathSelectedSeat,
        pathAvailable,
        pathBookedFemale,
        pathBookedMale,
        pathAvailableFemale,
        pathAlreadyBooked,
        pathAvailableMale,
      ];
}
