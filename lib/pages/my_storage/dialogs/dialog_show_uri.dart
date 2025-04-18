import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pascalstorage/config/colors.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class UriViewer extends StatelessWidget {
  final String uri;

  const UriViewer({super.key, required this.uri});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        PrettyQrView.data(
          data: uri,
          decoration: const PrettyQrDecoration(
            image: PrettyQrDecorationImage(
              image: AssetImage('assets/icon/icon-small.png'),
            ),
            quietZone: PrettyQrQuietZone.zero,
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: uri));
          },
          style: const ButtonStyle(
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
          ),
          label: Text(
            'Copia negli appunti',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColors.deepBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          icon: const Icon(
            Icons.copy,
            size: 32,
          ),
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
