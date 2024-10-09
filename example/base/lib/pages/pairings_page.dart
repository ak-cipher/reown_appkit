import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';

import 'package:reown_appkit_dapp/utils/constants.dart';
import 'package:reown_appkit_dapp/utils/string_constants.dart';
import 'package:reown_appkit_dapp/widgets/pairing_item.dart';

class PairingsPage extends StatefulWidget {
  const PairingsPage({
    super.key,
    required this.appKit,
  });

  final ReownAppKit appKit;

  @override
  PairingsPageState createState() => PairingsPageState();
}

class PairingsPageState extends State<PairingsPage> {
  List<PairingInfo> _pairings = [];

  @override
  void initState() {
    _pairings = widget.appKit.pairings.getAll();
    // widget.appKit.onSessionDelete.subscribe(_onSessionDelete);
    widget.appKit.core.pairing.onPairingDelete.subscribe(_onPairingDelete);
    widget.appKit.core.pairing.onPairingExpire.subscribe(_onPairingDelete);
    super.initState();
  }

  @override
  void dispose() {
    // widget.appKit.onSessionDelete.unsubscribe(_onSessionDelete);
    widget.appKit.core.pairing.onPairingDelete.unsubscribe(_onPairingDelete);
    widget.appKit.core.pairing.onPairingExpire.unsubscribe(_onPairingDelete);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<PairingItem> pairingItems = _pairings
        .map(
          (PairingInfo pairing) => PairingItem(
            key: ValueKey(pairing.topic),
            pairing: pairing,
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      StringConstants.deletePairing,
                      style: StyleConstants.titleText,
                    ),
                    content: Text(
                      pairing.topic,
                    ),
                    actions: [
                      TextButton(
                        child: const Text(
                          StringConstants.cancel,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text(
                          StringConstants.delete,
                        ),
                        onPressed: () async {
                          try {
                            widget.appKit.core.pairing.disconnect(
                              topic: pairing.topic,
                            );
                            Navigator.of(context).pop();
                          } catch (e) {
                            debugPrint('[SampleDapp] ${e.toString()}');
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        )
        .toList();

    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: StyleConstants.maxWidth,
        ),
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: pairingItems,
        ),
      ),
    );
  }

  void _onPairingDelete(PairingEvent? event) {
    setState(() {
      _pairings = widget.appKit.pairings.getAll();
    });
  }
}