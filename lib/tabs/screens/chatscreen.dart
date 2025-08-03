import 'package:devconnect/core/colors.dart';
import 'package:devconnect/tabs/apiServices/groupchatnotifier.dart';
import 'package:devconnect/tabs/apiServices/groupnotifier.dart';
import 'package:devconnect/tabs/apiServices/userdetails.dart';

import 'package:devconnect/tabs/model/group.dart';
import 'package:devconnect/tabs/model/message.dart';
import 'package:devconnect/tabs/model/userdetails.dart';
import 'package:devconnect/tabs/widgets/chatbubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Chatscreen extends ConsumerStatefulWidget {
  const Chatscreen({
    super.key,
    required this.group,
    required this.userId,
    required this.isforjoin,
  });

  final Group group;
  final int? userId;
  final bool isforjoin;

  @override
  ConsumerState<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends ConsumerState<Chatscreen> {
  bool isjoining = false;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => joinGroup());
  }

  void joinGroup() async {
    if (widget.isforjoin) {
      setState(() => isjoining = true);

      await ref
          .read(groupProvider.notifier)
          .togglejoinGroup(widget.group.id!, widget.userId!);
      widget.group.members!.add(widget.userId!);

      setState(() => isjoining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(groupChatProvider(widget.group.id!));
    final chatNotifier = ref.read(groupChatProvider(widget.group.id!).notifier);
    final isSending = ref.watch(sendingMsgProvider(widget.group.id!));
    final userprofile = ref.watch(userdetailsprovider);
    return Scaffold(
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        automaticallyImplyLeading: context.mounted,
        elevation: 2,
        titleSpacing: 0,
        title: Row(
          children: [
            SizedBox(width: 8.w),
            CircleAvatar(
              radius: 24.r,
              backgroundColor: Colors.blueGrey.shade400,
              child:
                  Icon(Icons.group_outlined, color: Colors.black, size: 28.r),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                widget.group.name ?? "Group Chat",
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            color: const Color.fromARGB(197, 0, 0, 0),
            onSelected: (value) async {
              if (value == 'leave') {
                await ref
                    .read(groupProvider.notifier)
                    .toggleleaveGroup(widget.group.id!, widget.userId!);
                widget.group.members!.removeWhere((e) => e == widget.userId!);
                if (context.mounted) Navigator.pop(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'leave',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Leave Group', style: TextStyle(color: Colors.red)),
                    Icon(Icons.exit_to_app_outlined, color: Colors.red),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: isjoining
            ? [
                Center(
                  child: Container(
                    height: 150.h,
                    width: 150.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                )
              ]
            : [
                // messages list
                Padding(
                  padding: EdgeInsets.only(bottom: 70.h),
                  child: chatState.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (e, _) => Center(
                      child: Text(
                        'Error loading messages\n$e',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    data: (messages) {
                      if (messages.isEmpty) {
                        return const Center(child: Text("No messages yet"));
                      }
                      return ListView.builder(
                        itemCount: messages.length,
                        reverse: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 10.h),
                        itemBuilder: (context, index) {
                          final msg =
                              messages[messages.length - 1 - index]; // reverse

                          print(
                              '${msg.message} :  ${msg.userProfile?.user?.id}');
                          final isSent =
                              msg.userProfile?.user?.id == widget.userId;
                          return ChatBubble(
                            msg: msg,
                            isSent: isSent,
                          );
                        },
                      );
                    },
                  ),
                ),
                // composer
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: "Type a message...",
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) =>
                                  _onSend(chatNotifier, userprofile.value!),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        isSending
                            ? const SizedBox(
                                height: 32,
                                width: 32,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : GestureDetector(
                                onTap: () =>
                                    _onSend(chatNotifier, userprofile.value!),
                                child: CircleAvatar(
                                  backgroundColor: seedcolor,
                                  child: const Icon(Icons.send,
                                      color: Colors.white),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
      ),
    );
  }

  void _onSend(GroupChatNotifier chatNotifier, UserProfile userprofile) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    chatNotifier.sendMessage(
      text,
      userprofile, // adapt to your real model
    );
    _controller.clear();
  }
}
