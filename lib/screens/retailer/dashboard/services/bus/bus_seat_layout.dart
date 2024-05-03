import 'package:flutter/material.dart';

import 'seat_model.dart';
import 'seat_widget.dart';

class SeatLayoutWidget extends StatelessWidget {
  final SeatLayoutStateModel stateModel;

  final void Function(int rowI, int colI, SeatState currentState) onSeatStateChanged;

  const SeatLayoutWidget({
    Key? key,
    required this.stateModel,
    required this.onSeatStateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: 5,
      minScale: 0.8,
      boundaryMargin: const EdgeInsets.all(8),
      constrained: true,
      child: Column(
        children: List<int>.generate(stateModel.rows, (rowI) => rowI)
            .map<Row>(
              (rowI) => Row(
                children: List<int>.generate(stateModel.cols, (colI) => colI).map<SeatWidget>(
                  (colI) {
                    // final seatData = stateModel.seatsData.firstWhere((data) => data['rows'] == rowI.toString() && data['column'] == colI.toString());
                    // final seatData = stateModel.seatsData.firstWhere((data) => data['rows'] == rowI.toString() && data['column'] == colI.toString());
                    return SeatWidget(
                      model: SeatModel(
                        seatState: stateModel.currentSeatsState[rowI][colI],
                        rowI: rowI,
                        colI: colI,
                        // seatState: seatData['available'] == 'true'
                        //     ? SeatState.availableSeats
                        //     : seatData['available'] == 'true' && seatData['malesSeat'] == 'false'
                        //         ? SeatState.availableForMale
                        //         : SeatState.availableForFemale,
                        // rowI: rowI,
                        // colI: colI,
                        seatSvgSize: stateModel.seatSvgSize,
                        pathSelectedSeat: stateModel.pathSelectedSeat,
                        pathAvailable: stateModel.pathAvailable,
                        pathAvailableFemale: stateModel.pathAvailableFemale,
                        pathAvailableMale: stateModel.pathAvailableMale,
                        pathAlreadyBooked: stateModel.pathAlreadyBooked,
                        pathBookedFemale: stateModel.pathBookedFemale,
                        pathBookedMale: stateModel.pathBookedMale,
                      ),
                      onSeatStateChanged: onSeatStateChanged,
                    );
                  },
                ).toList(),
              ),
            )
            .toList(),
      ),
      /*[
          ...List<int>.generate(stateModel.rows, (rowI) => rowI)
              .map<Row>(
                (rowI) => Row(
                  children: [
                    ...List<int>.generate(stateModel.cols, (colI) => colI)
                        .map<SeatWidget>((colI) => SeatWidget(
                              model: SeatModel(
                                seatState: stateModel.currentSeatsState[rowI][colI],
                                rowI: rowI,
                                colI: colI,
                                seatSvgSize: stateModel.seatSvgSize,
                                pathSelectedSeat: stateModel.pathSelectedSeat,
                                pathAvailable: stateModel.pathAvailable,
                                pathAvailableFemale: stateModel.pathAvailableFemale,
                                pathAvailableMale: stateModel.pathAvailableMale,
                                pathAlreadyBooked: stateModel.pathAlreadyBooked,
                                pathBookedFemale: stateModel.pathBookedFemale,
                                pathBookedMale: stateModel.pathBookedMale,
                              ),
                              onSeatStateChanged: onSeatStateChanged,
                            ))
                        .toList()
                  ],
                ),
              )
              .toList()
        ],*/
    );
  }
}
