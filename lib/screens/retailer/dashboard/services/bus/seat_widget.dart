import 'package:flutter/material.dart';

import 'seat_model.dart';

/// current state of a seat
enum SeatState {
  selectedSeat,
  availableSeats,
  alreadyBooked,
  availableForFemale,
  availableForMale,
  alreadyBookByMale,
  alreadyBookByFeMale,
}

class SeatWidget extends StatefulWidget {
  final SeatModel model;
  final void Function(int rowI, int colI, SeatState currentState) onSeatStateChanged;

  const SeatWidget({
    Key? key,
    required this.model,
    required this.onSeatStateChanged,
  }) : super(key: key);

  @override
  State<SeatWidget> createState() => _SeatWidgetState();
}

class _SeatWidgetState extends State<SeatWidget> {
  SeatState? seatState;
  int rowI = 0;
  int colI = 0;

  @override
  void initState() {
    super.initState();
    seatState = widget.model.seatState;
    rowI = widget.model.rowI;
    colI = widget.model.colI;
  }

  @override
  Widget build(BuildContext context) {
    final safeCheckedSeatState = seatState;
    if (safeCheckedSeatState != null) {
      return GestureDetector(
          onTapUp: (_) {
            switch (seatState) {
              case SeatState.selectedSeat:
                {
                  setState(() {
                    seatState = SeatState.selectedSeat;
                    widget.onSeatStateChanged(rowI, colI, SeatState.selectedSeat);
                  });
                }
                break;
              /* case SeatState.unselected:
              {
                setState(() {
                  seatState = SeatState.selected;
                  widget.onSeatStateChanged(rowI, colI, SeatState.selected);
                });
              }
              break;*/
              case SeatState.alreadyBookByFeMale:
              case SeatState.alreadyBooked:
              case SeatState.alreadyBookByMale:
              default:
                {}
                break;
            }
          },
          child: /*seatState != SeatState.empty
            ?*/
              Image.asset(
            _getSvgPath(safeCheckedSeatState),
            height: widget.model.seatSvgSize.toDouble(),
            width: widget.model.seatSvgSize.toDouble(),
            fit: BoxFit.cover,
          )
          /* : SizedBox(
                height: widget.model.seatSvgSize.toDouble(),
                width: widget.model.seatSvgSize.toDouble(),
              ),*/
          );
    }
    return const SizedBox();
  }

  String _getSvgPath(SeatState state) {
    switch (state) {
      case SeatState.availableSeats:
        {
          return widget.model.pathAvailable;
        }
      case SeatState.selectedSeat:
        {
          return widget.model.pathSelectedSeat;
        }
      case SeatState.alreadyBookByFeMale:
        {
          return widget.model.pathBookedFemale;
        }
      case SeatState.alreadyBookByMale:
        {
          return widget.model.pathBookedMale;
        }
      case SeatState.availableForFemale:
        {
          return widget.model.pathAvailableFemale;
        }
      case SeatState.availableForMale:
        {
          return widget.model.pathAvailableMale;
        }
      default:
        {
          return widget.model.pathAlreadyBooked;
        }
    }
  }
}
