import 'package:coursesnest/utils/paths.dart';

class ContentExpansionTile extends StatefulWidget {
  final Map<String, dynamic> module;
  final bool isMobile;
  const ContentExpansionTile(
      {super.key, required this.module, required this.isMobile});

  @override
  State<ContentExpansionTile> createState() => _ContentExpansionTileState();
}

class _ContentExpansionTileState extends State<ContentExpansionTile> {
  bool _isExpanded = false;

  String formatDuration(int totalSeconds) {
    int minutes = totalSeconds ~/ 60; // Calculate the number of minutes
    int seconds = totalSeconds % 60; // Get the remaining seconds
    return seconds > 30 ? '${minutes + 1} mins' : "$minutes mins";
  }

  String calculateTotalDuration(List<Map<String, dynamic>> topics) {
    // Calculate total duration in seconds
    int totalSeconds =
        // ignore: avoid_types_as_parameter_names
        topics.fold(0, (sum, topic) => sum + (topic['duration'] as int));

    // Convert to hours and minutes
    int hours = totalSeconds ~/ 3600; // 1 hour = 3600 seconds
    int minutes = (totalSeconds % 3600) ~/ 60;

    // Format the output
    if (hours > 0) {
      return '$hours hrs, $minutes mins';
    } else {
      return '$minutes mins';
    }
  }

  @override
  Widget build(BuildContext context) {
    final topics = (widget.module['lectures'] as List<dynamic>);
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        title: Text(
          overflow: TextOverflow.ellipsis,
          widget.module['title'],
          style: GoogleFonts.robotoCondensed(
              fontSize: widget.isMobile
                  ? context.courseLargeTopicDetails.fontSize
                  : context.courseLargeDescription.fontSize),
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        leading: Icon(
          _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: Colors.purple,
        ),
        trailing: topics.isEmpty
            ? Text("0 Lectures • 0 hrs",
                style: widget.isMobile
                    ? context.courseSmallTopicDetails
                    : context.courseLargeTopicDetails)
            : Text(
                "${topics.length} Lectures • ${calculateTotalDuration((topics as List<Map<String, dynamic>>))}",
                style: widget.isMobile
                    ? context.courseSmallTopicDetails
                    : context.courseLargeTopicDetails),
        shape: Border.all(color: Colors.transparent),
        children: topics.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("No lectures available."),
                ),
              ]
            : topics.map<Widget>((topic) {
                return ListTile(
                  onTap: topic['isPreview'] == false
                      ? null
                      : () {
                          // play video
                        },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    topic['lectureTitle'],
                    overflow: TextOverflow.ellipsis,
                    style: widget.isMobile
                        ? context.courseSmallTopicDetails.copyWith(
                            color:
                                topic['isPreview'] == true ? Colors.blue : null)
                        : context.courseLargeTopicDetails.copyWith(
                            color: topic['isPreview'] == true
                                ? Colors.blue
                                : null),
                  ),
                  leading: topic['isVideo'] == true
                      ? Icon(Icons.ondemand_video,
                          color:
                              topic['isPreview'] == true ? Colors.blue : null)
                      : const Icon(Icons.article),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (topic['isPreview'] == true)
                        const Icon(
                          Icons.play_circle,
                          color: Colors.blue,
                        ),
                      const SizedBox(width: 5),
                      Text(formatDuration(topic['duration']),
                          style: TextStyle(
                              fontSize: 14,
                              color: topic['isPreview'] == true
                                  ? Colors.blue
                                  : null))
                    ],
                  ),
                );
              }).toList(),
      ),
    );
  }
}
