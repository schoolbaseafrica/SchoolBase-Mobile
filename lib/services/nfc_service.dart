import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

class NfcService {
  // Check availability
  Future<bool> checkAvailability() async {
    return await NfcManager.instance.isAvailable();
  }

  void startSession({
    required Function(String) onTagRead,
    required Function(String) onError,
  }) {
    NfcManager.instance
        .startSession(
          pollingOptions: {
            NfcPollingOption.iso14443,
            NfcPollingOption.iso15693,
            NfcPollingOption.iso18092,
          },
          onDiscovered: (NfcTag tag) async {
            try {
              String? tagId = _extractTagId(tag);

              if (tagId != null) {
                onTagRead(tagId);
                NfcManager.instance.stopSession();
              } else {
                NfcManager.instance.stopSession();
                onError("Could not read Card ID");
              }
            } catch (e) {
              NfcManager.instance.stopSession();
              onError(e.toString());
            }
          },
        )
        .catchError((e) {
          onError(e.toString());
        });
  }

  void stopSession() {
    NfcManager.instance.stopSession();
  }

  // --- HELPER: Extract Serial Number Safely ---
  String? _extractTagId(NfcTag tag) {
    List<int>? idBytes;

    // 1. NfcA (Removed redundant 'if (idBytes == null)' check)
    var nfcA = NfcA.from(tag);
    if (nfcA != null) {
      idBytes = nfcA.identifier;
    }

    // 2. Mifare Classic
    if (idBytes == null) {
      var mifare = MifareClassic.from(tag);
      if (mifare != null) {
        idBytes = mifare.identifier;
      }
    }

    // 3. IsoDep
    if (idBytes == null) {
      var isoDep = IsoDep.from(tag);
      if (isoDep != null) {
        idBytes = isoDep.identifier;
      }
    }

    // 4. NfcB
    if (idBytes == null) {
      var nfcB = NfcB.from(tag);
      if (nfcB != null) {
        idBytes = nfcB.identifier;
      }
    }

    // 5. NfcF
    if (idBytes == null) {
      var nfcF = NfcF.from(tag);
      if (nfcF != null) {
        idBytes = nfcF.identifier;
      }
    }

    // 6. NfcV
    if (idBytes == null) {
      var nfcV = NfcV.from(tag);
      if (nfcV != null) {
        idBytes = nfcV.identifier;
      }
    }

    if (idBytes == null) return null;

    return idBytes
        .map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(':');
  }
}
