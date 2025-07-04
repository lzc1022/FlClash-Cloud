import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/box.dart';
import '../../../../models/notice_model.dart';

class NoticeItem extends StatelessWidget {
  const NoticeItem({super.key, required this.model});
  final NoticeModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.title ?? '',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          vBox(10),
          Html(
            data: md.markdownToHtml(model.content ?? ''),
            style: {
              'body': Style(
                fontSize: FontSize(14),
                color: Colors.grey,
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
            },
            onLinkTap: (url, attributes, element) {
              if (url != null) {
                final uri = Uri.parse(url);
                launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
    );
  }
}
