import 'package:coursesnest/utils/paths.dart';

class EditContentExpansionTile extends StatefulWidget {
  final Map<String, dynamic> module;
  final bool isMobile;
  final Function(Map<String, dynamic> module) onUpdate;
  final Function() onDeleteRequest;
  const EditContentExpansionTile(
      {super.key,
      required this.module,
      required this.isMobile,
      required this.onUpdate,
      required this.onDeleteRequest});

  @override
  State<EditContentExpansionTile> createState() =>
      _EditContentExpansionTileState();
}

class _EditContentExpansionTileState extends State<EditContentExpansionTile> {
  Map<String, dynamic>? module;
  List<dynamic> topics = [];
  bool _isExpanded = false;
  final moduleformKey = GlobalKey<FormState>();
  TextEditingController moduleController = TextEditingController();
  TextEditingController lectureController = TextEditingController();

  @override
  void initState() {
    module = widget.module;
    topics = widget.module['lectures'];
    super.initState();
  }

  @override
  void dispose() {
    moduleController.dispose();
    lectureController.dispose();
    super.dispose();
  }

  void editSectionNameDialog(BuildContext context, String title) {
    setState(() {
      moduleController.text = title;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 600, // Custom width
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit Section Name',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Form(
                  key: moduleformKey,
                  child: TextFormField(
                    controller: moduleController,
                    decoration: const InputDecoration(
                      labelText: 'Section Name',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter title";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                    onTap: () {
                      if (moduleformKey.currentState!.validate()) {
                        module!['title'] = moduleController.text.trim();
                        widget.onUpdate.call(module!);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                        color: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        child: const Center(
                            child: Text("Update",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)))))
              ],
            ),
          ),
        );
      },
    );
  }

  void lectureDialog(BuildContext context, {Map<String, dynamic>? lecture}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: LectureForm(
              lecture: lecture,
              onSaved: (updatedLecture) {
                if (lecture == null) {
                  Navigator.pop(context);
                  setState(() {
                    topics.add(updatedLecture);
                  });
                } else {
                  Navigator.pop(context);
                  int lectureIndex = topics.indexOf(lecture);
                  setState(() {
                    topics[lectureIndex] = updatedLecture;
                  });
                }
              }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        title: Text(
          overflow: TextOverflow.ellipsis,
          module!['title'],
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  widget.onDeleteRequest.call();
                },
                icon: const Icon(Icons.delete, color: Colors.red)),
            IconButton(
                onPressed: () {
                  editSectionNameDialog(context, module!['title']);
                },
                icon: const Icon(Icons.edit)),
          ],
        ),
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
                              color: topic['isPreview'] == true
                                  ? Colors.blue
                                  : null)
                          : context.courseLargeTopicDetails.copyWith(
                              color: topic['isPreview'] == true
                                  ? Colors.blue
                                  : null),
                    ),
                    leading: stringToEnum(topic['contentType']) ==
                            ContentType.video
                        ? Icon(Icons.ondemand_video,
                            color:
                                topic['isPreview'] == true ? Colors.blue : null)
                        : const Icon(Icons.article),
                    trailing: IconButton(
                        onPressed: () {
                          lectureDialog(context, lecture: topic);
                        },
                        icon: const Icon(Icons.edit)));
              }).toList()
          ..add(InkWell(
            onTap: () {
              lectureDialog(context);
            },
            child: SizedBox(
              child: Center(
                child: Text(
                  "Add new Lecture",
                  style: GoogleFonts.robotoCondensed(
                      fontSize: widget.isMobile
                          ? context.courseLargeTopicDetails.fontSize
                          : context.courseLargeDescription.fontSize),
                ),
              ),
            ),
          )),
      ),
    );
  }
}
