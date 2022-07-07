import 'package:flutter/widgets.dart';
import 'package:swayze/delegates.dart';

import '../data/cell_data.dart';
import 'painters/cell_text.dart';
import 'policies/painting_policies.dart';

/// The [CellDelegate] for the [EditorTable].
class MyCellDelegate<CellDataType extends MyCellData>
    extends CellDelegate<CellDataType> with Overlays {
  /// The list of [CellOverlayPolicy] to be applied to each cell.
  @override
  final Iterable<CellOverlayPolicy<CellDataType>>? overlayPolicies;

  MyCellDelegate({this.overlayPolicies});

  @override
  CellLayout getCellLayout(CellDataType data) {
    return EditorCellLayout(
      cellData: data,
      cellOverlays: getOverlaysOfACell(data),
    );
  }
}

class EditorCellLayout<CellDataType extends MyCellData> extends CellLayout {
  final CellDataType cellData;
  final CellOverlays<CellDataType> cellOverlays;

  @override
  bool get isActiveCellAware => cellOverlays.hasAnyOverlay;

  @override
  bool get isHoverAware => cellOverlays.hasAnyOverlay;

  EditorCellLayout({
    required this.cellData,
    required this.cellOverlays,
  });

  @override
  Iterable<Widget> buildOverlayWidgets(
    BuildContext context, {
    bool isHover = false,
    bool isActive = false,
  }) {
    final cellOverlayWidgets = <Widget>[];
    if (cellOverlays.hasAnyOverlay && isHover) {
      cellOverlayWidgets.addAll(
        cellOverlays.overlayPolicies!.map(
          (cellOverlay) => cellOverlay.builder(context, cellData),
        ),
      );
    }
    return cellOverlayWidgets;
  }

  @override
  Widget buildCell(
    BuildContext context, {
    bool isHover = false,
    bool isActive = false,
  }) {
    return CellTextOnly(
      data: cellData,
      position: cellData.position,
      textDirection: TextDirection.ltr,
    );
  }
}
