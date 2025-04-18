import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../config/colors.dart';

class UriViewer extends StatelessWidget {
  final String uri;

  const UriViewer({super.key, required this.uri});

  Widget _buildPrettyQrCode(QrImage qrImage) {
    return SizedBox(
      width: 300,
      height: 300,
      child: PrettyQrView(
        qrImage: qrImage,
        decoration: const PrettyQrDecoration(
          image: PrettyQrDecorationImage(
            image: AssetImage('assets/icon/icon-full.png'),
          ),
          quietZone: PrettyQrQuietZone.zero,
        ),
      ),
    );
  }

  Widget _buildButtonAction(BuildContext context, IconData icon, String text,
      VoidCallback onPressed) {
    return SizedBox(
      width: 300,
      child: OutlinedButton.icon(
        icon: Icon(icon, size: 32),
        style: const ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        label: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.deepBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Future _exportQrImage(QrImage qrImage) async {
    var bufferImage = await qrImage.toImageAsBytes(size: 512);

    if (bufferImage == null) return;

    Share.shareXFiles([
      XFile.fromData(
        bufferImage.buffer.asUint8List(),
        mimeType: 'image/png',
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    var mobileLayout = width < 600;

    var qrImage = QrImage(
      QrCode.fromData(data: uri, errorCorrectLevel: QrErrorCorrectLevel.M),
    );

    var widgetQrCode = _buildPrettyQrCode(qrImage);

    var widgetButtons = [
      _buildButtonAction(
          context,
          Icons.copy,
          AppLocalizations.of(context)!.copyToClipboard,
          () => Clipboard.setData(ClipboardData(text: uri))),
      _buildButtonAction(
        context,
        Icons.send_sharp,
        AppLocalizations.of(context)!.share,
        () => Share.share(uri),
      ),
      _buildButtonAction(
        context,
        Icons.qr_code,
        AppLocalizations.of(context)!.forwardQrCode,
        () => _exportQrImage(qrImage),
      ),
    ];

    if (mobileLayout) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: widgetQrCode,
            ),
            ...widgetButtons,
          ],
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 32,
      children: [
        Flexible(fit: FlexFit.loose, child: widgetQrCode),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 32,
          children: widgetButtons,
        ),
      ],
    );
  }
}

Future buildDialogUri(
  BuildContext context, {
  String uri = 'https://www.example.com',
  String title = 'This is a URI',
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(title),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close, size: 32),
            ),
          ],
        ),
        content: UriViewer(uri: uri),
        titlePadding: const EdgeInsets.all(20),
        contentPadding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      );
    },
  );
}
