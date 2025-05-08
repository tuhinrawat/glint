import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../core/theme/app_theme.dart';

class TripPlannerPage extends StatefulWidget {
  const TripPlannerPage({super.key});

  @override
  State<TripPlannerPage> createState() => _TripPlannerPageState();
}

class _TripPlannerPageState extends State<TripPlannerPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  final List<String> _suggestedPrompts = [
    "Plan a 5-day trip to Bali with a budget of ₹1,50,000",
    "Suggest a romantic honeymoon destination for December",
    "Create an adventure trip itinerary for the Swiss Alps",
    "Plan a family-friendly weekend getaway near Mumbai",
    "Design a backpacking trip across Southeast Asia",
  ];

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      "Hi! I'm your AI travel planner. I can help you plan your perfect trip. "
      "Choose a suggestion below or type your own request.",
    );
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
      _isTyping = true;
    });

    // Scroll to bottom
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    // Simulate AI response
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(
        text: "I'll help you plan that trip! Let me generate a detailed itinerary for you...",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });

    // Scroll to bottom again after response
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Plan Your Trip'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _messages.clear();
                _addBotMessage(
                  "Let's start fresh! How can I help you plan your trip?",
                );
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessage(message);
              },
            ),
          ),
          if (_messages.length == 1) // Show suggestions only at the start
            Container(
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suggestedPrompts.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      onPressed: () => _handleSubmitted(_suggestedPrompts[index]),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Text(_suggestedPrompts[index]),
                    ),
                  );
                },
              ),
            ),
          if (_isTyping)
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: SpinKitThreeBounce(
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your travel plans...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: _handleSubmitted,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_messageController.text),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: message.isUser
                    ? Colors.white.withOpacity(0.7)
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
} 