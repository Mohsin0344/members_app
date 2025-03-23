import 'dart:developer';
import 'dart:io';

import 'package:members_app/view_models/app_states.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/members/absent_members_model.dart';

abstract class AbsenceIcalService {
  Future generateICalFile({required List<AbsentMember> absences});
}

class AbsenceIcalServiceRepository implements AbsenceIcalService {
  @override
  Future generateICalFile({required List<AbsentMember> absences}) async {
    try {
      StringBuffer icsContent = StringBuffer();
      icsContent.write('BEGIN:VCALENDAR\r\n');
      icsContent.write('VERSION:2.0\r\n');
      icsContent.write('PRODID:-//MembersApp//NONSGML Event//EN\r\n');

      for (var absence in absences) {
        String startDate = absence.startDate.toString();
        String endDate = absence.endDate.toString();
        String summary = '${absence.member?.name} - ${absence.type}';
        String description = absence.memberNote?.replaceAll('\n', '\\n') ?? 'No additional details';

        icsContent.write('BEGIN:VEVENT\r\n');
        icsContent.write('UID:${absence.id}@membersapp.com\r\n');
        icsContent.write('DTSTAMP:${_formatDate(DateTime.now())}\r\n');
        icsContent.write('DTSTART:${_formatDate(DateTime.parse(startDate))}\r\n');
        icsContent.write('DTEND:${_formatDate(DateTime.parse(endDate))}\r\n');
        icsContent.write('SUMMARY:$summary\r\n');
        icsContent.write('DESCRIPTION:$description\r\n');
        icsContent.write('END:VEVENT\r\n');
      }

      icsContent.write('END:VCALENDAR\r\n');

      // Save the iCal file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/absences.ics';
      File file = File(filePath);
      await file.writeAsString(icsContent.toString(), mode: FileMode.write, flush: true);
      log('iCal file saved at: $filePath');
      Share.shareXFiles([XFile(filePath)]);
      return 'iCal file saved at: $filePath';
    } catch (e) {
      throw UnknownErrorState(error: e.toString());
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.')[0]}Z';
  }
}