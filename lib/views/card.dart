import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttergo/controllers/shortlink_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CardView extends StatefulWidget {
  const CardView({super.key});
  @override
  State<CardView> createState() => _CardView();
}

class _CardView extends State<CardView> {
  final TextEditingController _urlController = TextEditingController();
  String? _shortUrl;
  bool _isLoading = false;

  Future<void> _handleGenerate() async {
    final longUrl = _urlController.text.trim();

    if (longUrl.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a URL")));
      return;
    }

    setState(() {
      _isLoading = true;
      _shortUrl = null;
    });

    try {
      final result = await ShortlinkController.generateShortLink(longUrl);
      setState(() {
        _shortUrl = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _copyToClipboard() async {
    final shortLink = _shortUrl;
    if (shortLink == null) return;
    await Clipboard.setData(ClipboardData(text: shortLink));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/bg.jpg', fit: BoxFit.cover, cacheWidth: 1080),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: _urlController,
                            style: const TextStyle(
                              color: Colors.white,
                              decorationColor: Colors.black12,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Paste your long URL here!!!',
                              labelStyle: const TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(
                                Icons.link,
                                color: Colors.cyan,
                                size: 24,
                              ),
                              filled: true,
                              fillColor: Colors.black.withValues(alpha: 0.2),
                            ),
                            keyboardType: TextInputType.url,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleGenerate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyanAccent,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Text("🚀 Generate ShortL Link "),
                          ),
                          const SizedBox(height: 24),
                          if (_shortUrl != null)
                            Column(
                              children: [
                                const Text(
                                  "🔗 Your shortened URL",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle.new(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SelectableText(
                                  _shortUrl!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.cyanAccent,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),

                                const SizedBox(height: 20),
                                QrImageView(
                                  data: _shortUrl!,
                                  size: 180,
                                  backgroundColor: Colors.white,
                                ),
                              ],
                            ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 12,
                            children: [
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: _copyToClipboard,
                                label: Text("Copy"),
                                icon: const Icon(Icons.copy),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white30),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
