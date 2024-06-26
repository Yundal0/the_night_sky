import 'package:everyones_tone/app/config/app_color.dart';
import 'package:everyones_tone/app/constants/app_assets.dart';
import 'package:everyones_tone/app/utils/audio_play_provider.dart';
import 'package:everyones_tone/app/utils/record_status_manager.dart';
import 'package:everyones_tone/presentation/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BeforeRecordButton extends StatelessWidget {
  final RecordStatusManager recordStatusManager;
  final bool isLastMessageMine;

  const BeforeRecordButton({
    super.key,
    required this.recordStatusManager,
    this.isLastMessageMine = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
        backgroundColor: AppColor.primaryBlue,
      ),
      onPressed: () {
        Provider.of<AudioPlayProvider>(context, listen: false).stopPlaying();

        if (isLastMessageMine) {
          DialogWidget.showSingleOptionDialog(context, '답장이 올 때까지 메시지를 보낼 수 없습니다.');
        } else {
          // Otherwise, start recording
          recordStatusManager.startRecording();
        }
      },
      child: SvgPicture.asset(AppAssets.micDefault56),
    );
  }
}
