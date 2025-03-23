import 'dart:developer';
import 'dart:io';

import 'package:members_app/view_models/app_states.dart';
import 'package:path_provider/path_provider.dart';

import '../models/members/absent_members_model.dart';

abstract class AbsenceIcalService {
  Future generateICalFile({required List<AbsentMember> absences});
}

class AbsenceIcalServiceRepository implements AbsenceIcalService {
  @override
  Future generateICalFile({required List<AbsentMember> absences}) async {
    try {
      StringBuffer icsContent = StringBuffer();
      icsContent.writeln('BEGIN:VCALENDAR');
      icsContent.writeln('VERSION:2.0');
      icsContent.writeln('PRODID:-//MembersApp//NONSGML Event//EN');

      for (var absence in absences) {
        String startDate = absence.startDate.toString();
        String endDate = absence.endDate.toString();
        String summary = '${absence.member?.name} - ${absence.type}';
        String description = absence.memberNote ?? 'No additional details';

        icsContent.writeln('BEGIN:VEVENT');
        icsContent.writeln('UID:${absence.id}@membersapp.com');
        icsContent.writeln('DTSTAMP:${_formatDate(DateTime.now())}');
        icsContent.writeln('DTSTART:${_formatDate(DateTime.parse(startDate))}');
        icsContent.writeln('DTEND:${_formatDate(DateTime.parse(endDate))}');
        icsContent.writeln('SUMMARY:$summary');
        icsContent.writeln('DESCRIPTION:$description');
        icsContent.writeln('END:VEVENT');
      }

      icsContent.writeln('END:VCALENDAR');

      // Save the iCal file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/absences.ics';
      File file = File(filePath);
      await file.writeAsString(icsContent.toString());
      log('iCal file saved at: $filePath');
      return 'iCal file saved at: $filePath';
    } catch(e) {
      throw UnknownErrorState(error: e.toString());
    }
  }

// Helper function to format dates in iCal format
  String _formatDate(DateTime dateTime) {
    return '${dateTime.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.')[0]}Z';
  }
}