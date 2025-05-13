import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/internet/chatbot/chat_service.dart';
import 'package:quimify_client/internet/payments/payments.dart';
import 'package:quimify_client/pages/widgets/bars/camera_button_handler.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/message_dialog.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

import '../widgets/dialogs/messages/no_internet_dialog.dart';

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold.noAd(
      header: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.only(
            top: 15,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          child: Row(
            children: [
              QuimifyIconButton.square(
                height: 50,
                backgroundColor: QuimifyColors.secondaryTeal(context),
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back,
                  color: QuimifyColors.inverseText(context),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  context.l10n.chatWithAtomic,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 19,
                    color: QuimifyColors.inverseText(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              QuimifyIconButton.square(
                height: 40,
                backgroundColor: Colors.white,
                onPressed: () async {
                  await ChatService().clearHistory();
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: QuimifyColors.teal(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: const _Body(),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isUser;
  final bool showAvatar;
  final String? type;

  const ChatMessage({
    Key? key,
    required this.message,
    required this.isUser,
    this.type = 'text',
    this.showAvatar = false,
  }) : super(key: key);

  Widget _buildMathContent(String text, BuildContext context) {
    // Handle both display math \[ ... \] and inline math \( ... \)
    final RegExp mathExp =
        RegExp(r'(\\\[.*?\\\]|\\\(.*?\\\))', multiLine: true, dotAll: true);
    final List<String> parts = text.split(mathExp);
    final List<String?> matches =
        mathExp.allMatches(text).map((m) => m.group(0)).toList();

    List<Widget> children = [];

    for (int i = 0; i < parts.length; i++) {
      // Add text part
      if (parts[i].isNotEmpty) {
        children.add(MarkdownBody(
          data: parts[i],
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              color: isUser ? Colors.white : Colors.black,
            ),
            code: TextStyle(
              backgroundColor:
                  isUser ? Colors.blue[700] : Colors.black.withOpacity(0.10),
              color: Colors.black,
            ),
            codeblockDecoration: BoxDecoration(
              color: isUser ? Colors.blue[700] : Colors.grey.withOpacity(0.75),
              borderRadius: BorderRadius.circular(8),
            ),
            blockquote: TextStyle(
              color: isUser ? Colors.white70 : Colors.black87,
              fontStyle: FontStyle.italic,
            ),
            blockquoteDecoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: isUser ? Colors.white30 : Colors.black26,
                  width: 4,
                ),
              ),
            ),
            listBullet: TextStyle(
              color: isUser ? Colors.white : Colors.black,
            ),
            strong: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
            em: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontStyle: FontStyle.italic,
            ),
            h1: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            h2: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            h3: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            listIndent: 20.0,
            blockSpacing: 8.0,
            h1Padding: const EdgeInsets.only(top: 8, bottom: 4),
            h2Padding: const EdgeInsets.only(top: 8, bottom: 4),
            h3Padding: const EdgeInsets.only(top: 8, bottom: 4),
          ),
          selectable: true,
        ));
      }

      // Add math part if exists
      if (i < matches.length && matches[i] != null) {
        final mathText = matches[i]!;
        final isDisplayMode = mathText.startsWith(r'\[');

        // Remove the delimiters
        final cleanMathText = mathText
            .replaceAll(r'\[', '')
            .replaceAll(r'\]', '')
            .replaceAll(r'\(', '')
            .replaceAll(r'\)', '')
            .trim();

        children.add(Padding(
          padding: EdgeInsets.symmetric(
            vertical: isDisplayMode ? 8.0 : 0.0,
            horizontal: 2.0,
          ),
          child: Math.tex(
            cleanMathText,
            textStyle: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontSize: 16,
            ),
            mathStyle: isDisplayMode ? MathStyle.display : MathStyle.text,
          ),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser && showAvatar) ...[
            Image.asset(
              'assets/images/atomic.png',
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue : QuimifyColors.teal(),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (type == 'image') ...[
                    Text(
                      context.l10n.photoAttached,
                      style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 15),
                    ),
                  ],
                  if (message.isEmpty && !isUser)
                    Text(
                      context.l10n.thinking,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.black38,
                      ),
                    )
                  else if (message.isNotEmpty) ...[
                    if (type != null) const SizedBox(height: 4),
                    _buildMathContent(message, context),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final ChatService _chatService = ChatService();
  bool _isFirstLoad = true;
  bool _isLoading = false; // Add this line
  String? _selectedImageBase64;
  bool _hasSelectedImage = false;
  Future<void> _pickImage() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => const ImageSourceDialog(),
    );

    if (source == null) return;

    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo != null && context.mounted) {
      // Show the cropping screen
      if (!context.mounted) {
        return;
      }

      // ignore: use_build_context_synchronously
      final croppedFile = await Navigator.of(context).push<File>(
        MaterialPageRoute(
          builder: (context) => ImageCropperScreen(imageFile: File(photo.path)),
        ),
      );

      if (croppedFile == null) return;

      final bytes = await croppedFile.readAsBytes();
      setState(() {
        _selectedImageBase64 = base64Encode(bytes);
        _hasSelectedImage = true;
      });
    }
  }

  List<String> quickQuestions = [];

  final welcomeMessage = ChatMessageModel(
    id: 'welcome',
    content:
        'Hola! Mi nombre es Atomic! Soy tu profesor particular con inteligencia '
        'artifical, preguntame lo que quieras sobre Química',
    isUser: false,
    timestamp: DateTime.now(),
    status: 'delivered',
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    quickQuestions = [
      context.l10n.whatIsChemicalNomenclature,
      context.l10n.giveMeAnExample,
      context.l10n.howDoIAdjustAResponse,
      context.l10n.whatAreYouCapableOf,
      context.l10n.whoAreYourCreators,
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _handleSendMessage(String text) async {
    // Check internet connectivity before proceeding
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (BuildContext context) => noInternetDialog(context),
      );
      return;
    }
    if ((!_hasSelectedImage && text.trim().isEmpty) || _isLoading) return;

    final messageText = text.trim();
    final payments = Payments();
    final ads = Ads();

    if (!payments.isSubscribed) {
      if (ads.canWatchRewardedAd && !_hasSelectedImage) {
        if (!context.mounted) return;

        await MessageDialog(
          title: context.l10n.sendMessage,
          details: context.l10n.youCanSendThisMessageByWatchingAVideoAd,
          onButtonPressed: () async {
            final bool wasRewarded = await ads.showRewarded();
            if (wasRewarded && context.mounted) {
              // Send the message if rewarded
              await _sendMessageToService(messageText);
            }
          },
        ).show(context);

        return;
      } else if (!ads.canWatchRewardedAd && !_hasSelectedImage) {
        if (!context.mounted) return;

        await MessageDialog(
          title: context.l10n.dailyMaximumReached,
          details: context.l10n
              .ifYouWantToContinueSendingMessagesToAtomicSubscribeToPremium,
        ).show(context);

        return;
      } else if (!payments.isSubscribed && _hasSelectedImage) {
        if (!context.mounted) return;

        await MessageDialog(
          title: context.l10n.onlyWithPremium,
          details:
              context.l10n.ifYouWantToSendAPictureToAtomicSubscribeToPremium,
        ).show(context);

        return;
      }
      return;
    }

    await _sendMessageToService(messageText);
  }

  // Helper method to handle the actual message sending
  Future<void> _sendMessageToService(String messageText) async {
    _textController.clear();

    setState(() {
      _isLoading = true;
    });

    if (context.mounted) {
      FocusScope.of(context).unfocus();
    }

    try {
      await _chatService.sendMessage(
        messageText,
        imageBase64: _selectedImageBase64,
      );

      setState(() {
        _selectedImageBase64 = null;
        _hasSelectedImage = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.errorSendingMessage)),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              StreamBuilder<List<ChatMessageModel>>(
                stream: _chatService.streamMessages(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(context.l10n.error));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Add welcome message to the beginning of the list
                  final messages = [welcomeMessage, ...snapshot.data!];

                  // In StreamBuilder
                  if (_isFirstLoad && messages.length > 1) {
                    _isFirstLoad = false;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollToBottom();
                      }
                    });
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final showAvatar = !message.isUser &&
                          (index == 0 || messages[index - 1].isUser);

                      if (index == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/atomic.png',
                                  height: 95,
                                  width: 95,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: QuimifyColors.teal(),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      message.content,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }

                      return ChatMessage(
                        message: message.content,
                        type: message.messageType,
                        isUser: message.isUser,
                        showAvatar: showAvatar,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          decoration: BoxDecoration(
            color: QuimifyColors.background(context),
            boxShadow: [
              BoxShadow(
                color: QuimifyColors.teal(),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                color: QuimifyColors.background(context),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      ...quickQuestions.map((question) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _QuickQuestionButton(
                              text: question,
                              onTap: _isLoading
                                  ? null
                                  : () => _handleSendMessage(question),
                              enabled: !_isLoading,
                            ),
                          )),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    if (_hasSelectedImage) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: QuimifyColors.foreground(context),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.photo, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(context.l10n.selectedPhoto),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => setState(() {
                                _selectedImageBase64 = null;
                                _hasSelectedImage = false;
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.photo_camera,
                            color: QuimifyColors.teal(),
                          ),
                          onPressed: _isLoading ? null : _pickImage,
                        ),
                        Expanded(
                          child: TextField(
                            enabled: !_isLoading,
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: _hasSelectedImage
                                  ? context.l10n.addMessage
                                  : context.l10n.askMeAQuestion,
                              hintStyle: TextStyle(
                                  color: QuimifyColors.quaternary(context)),
                              filled: true,
                              fillColor: _isLoading
                                  ? QuimifyColors.foreground(context)
                                      .withOpacity(0.7)
                                  : QuimifyColors.foreground(context),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                    color: QuimifyColors.tertiary(context)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                    color: QuimifyColors.tertiary(context)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide:
                                    BorderSide(color: QuimifyColors.teal()),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            style: TextStyle(
                                color: QuimifyColors.primary(context)),
                            onSubmitted: _isLoading ? null : _handleSendMessage,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: _isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      QuimifyColors.teal()),
                                  strokeWidth: 2,
                                )
                              : Icon(Icons.send, color: QuimifyColors.teal()),
                          onPressed: _isLoading
                              ? null
                              : () => _handleSendMessage(_textController.text),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickQuestionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool enabled;

  const _QuickQuestionButton({
    required this.text,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: QuimifyColors.teal().withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: QuimifyColors.primary(context),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class AutomaticKeepAliveClient extends StatefulWidget {
  final Widget child;

  const AutomaticKeepAliveClient({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  AutomaticKeepAliveClientState createState() =>
      AutomaticKeepAliveClientState();
}

class AutomaticKeepAliveClientState extends State<AutomaticKeepAliveClient>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
