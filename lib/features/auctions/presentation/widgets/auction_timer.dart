import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';

class AuctionTimer extends StatefulWidget {
  final DateTime endTime;
  final TextStyle? textStyle;

  const AuctionTimer({
    super.key,
    required this.endTime,
    this.textStyle,
  });

  @override
  State<AuctionTimer> createState() => _AuctionTimerState();
}

class _AuctionTimerState extends State<AuctionTimer> {
  late Timer _timer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateRemainingTime();
    });
  }

  void _calculateRemainingTime() {
    final now = DateTime.now();
    setState(() {
      _remainingTime = widget.endTime.isAfter(now)
          ? widget.endTime.difference(now)
          : Duration.zero;
    });
    if (_remainingTime == Duration.zero) {
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) return "Auction Ended";
    
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (days > 0) {
      return "${days}d ${hours}h ${minutes}m ${seconds}s";
    }
    return "${hours}h ${minutes}m ${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    final isEndingSoon = _remainingTime.inHours < 1 && _remainingTime != Duration.zero;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.timer_outlined,
          size: 14,
          color: isEndingSoon ? AppColors.clay : AppColors.forest,
        ),
        const SizedBox(width: 4),
        Text(
          _formatDuration(_remainingTime),
          style: widget.textStyle ?? TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isEndingSoon ? AppColors.clay : AppColors.forest,
          ),
        ),
      ],
    );
  }
}
