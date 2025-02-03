import 'package:eticket_atc/controller/searchController.dart';
import 'package:eticket_atc/widgets/microwidgets/form/dtaePick.dart';
import 'package:eticket_atc/widgets/microwidgets/form/suggestionList.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormFields extends StatefulWidget {
  const FormFields({super.key});

  @override
  _FormFieldsState createState() => _FormFieldsState();
}

class _FormFieldsState extends State<FormFields> {
  final BusSearchController busSearchController =
      Get.put(BusSearchController());

  OverlayEntry? _overlayEntryFrom;
  OverlayEntry? _overlayEntryTo;

  final GlobalKey _fromFieldKey = GlobalKey();
  final GlobalKey _toFieldKey = GlobalKey();

  @override
  void dispose() {
    _removeOverlay(_overlayEntryFrom);
    _removeOverlay(_overlayEntryTo);
    super.dispose();
  }

  void _removeOverlay(OverlayEntry? entry) {
    if (entry != null) {
      entry.remove();
    }
  }

  void _showOverlay(GlobalKey fieldKey, String field) {
    final renderBox = fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: Material(
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: SuggestionList(field: field),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);

    if (field == 'from') {
      _overlayEntryFrom = overlayEntry;
    } else {
      _overlayEntryTo = overlayEntry;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isFromFocused = busSearchController.isFrom.value;
      bool isToFocused = busSearchController.isTo.value;
      bool hasSuggestions = busSearchController.filteredSuggestions.isNotEmpty;

      if (isFromFocused && hasSuggestions) {
        if (_overlayEntryFrom == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showOverlay(_fromFieldKey, 'from');
          });
        }
      } else if (!isFromFocused) {
        _removeOverlay(_overlayEntryFrom);
        _overlayEntryFrom = null;
      }

      if (isToFocused && hasSuggestions) {
        if (_overlayEntryTo == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showOverlay(_toFieldKey, 'to');
          });
        }
      } else if (!isToFocused) {
        _removeOverlay(_overlayEntryTo);
        _overlayEntryTo = null;
      }

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!busSearchController.isSelecting.value) {
            FocusScope.of(context).unfocus();
            busSearchController.clearFocus();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: TextField(
                      key: _fromFieldKey,
                      controller: busSearchController.fromController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                        ),
                        labelText: 'From',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        busSearchController.checkSuggestions(value,
                            field: 'from');
                      },
                      onTap: () {
                        busSearchController.toggleFocus(true);
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    flex: 1,
                    child: TextField(
                      key: _toFieldKey,
                      controller: busSearchController.toController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlue),
                        ),
                        labelText: 'To',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        busSearchController.checkSuggestions(value,
                            field: 'to');
                      },
                      onTap: () {
                        busSearchController.toggleFocus(false);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Flexible(flex: 1, child: DatePick(isJourneyDate: true)),
                  const SizedBox(width: 20),
                  Flexible(
                    flex: 1,
                    child: Obx(() {
                      return Opacity(
                        opacity: busSearchController.isReturn.value ? 1.0 : 0.5,
                        child: IgnorePointer(
                          ignoring: !busSearchController.isReturn.value,
                          child: DatePick(isJourneyDate: false),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }
}
