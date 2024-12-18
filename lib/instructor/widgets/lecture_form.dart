import 'package:coursesnest/utils/paths.dart';

class LectureForm extends StatefulWidget {
  final Map<String, dynamic>? lecture;
  final Function(Map<String, dynamic> lecture) onSaved;
  const LectureForm({super.key, this.lecture, required this.onSaved});

  @override
  State<LectureForm> createState() => _LectureFormState();
}

class _LectureFormState extends State<LectureForm> {
  Map<String, dynamic>? lecture;
  bool? isPreview = false;
  final lectureformKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int hours = 0;
  int mins = 0;
  int secs = 0;

  // State variable for content type
  ContentType? selectedContentType;

  @override
  void initState() {
    super.initState();
    if (widget.lecture != null) {
      lecture = widget.lecture;
      titleController.text = widget.lecture!['lectureTitle'] ?? '';
      isPreview = widget.lecture!['isPreview'] ?? false;
      descriptionController.text = widget.lecture!['description'] ?? '';
      urlController.text = widget.lecture!['videoUrl'] ?? '';
      selectedContentType = stringToEnum(widget.lecture!['contentType'] ?? '');
      convertSecondsToTime(widget.lecture!['duration'] ?? 0);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    urlController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void convertSecondsToTime(int totalSeconds) {
    // Calculate hours, minutes, and seconds
    int hrs = totalSeconds ~/ 3600; // Divide by 3600 to get hours
    int minutes =
        (totalSeconds % 3600) ~/ 60; // Remainder divided by 60 to get minutes
    int seconds = totalSeconds % 60; // Remainder gives seconds

    // Set the values to the default variables
    setState(() {
      hours = hrs;
      mins = minutes;
      secs = seconds;
    });
  }

  int convertToSeconds() {
    // Convert to total seconds
    return (hours * 3600) + (mins * 60) + secs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600, // Custom width
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              lecture == null ? "Create Lecture" : 'Edit Lecture',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Form(
              key: lectureformKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Lecture Title',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter title";
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('isPreview'), // Label on the left
                      Checkbox(
                        value:
                            isPreview, // This is the boolean variable that holds the state of the checkbox
                        onChanged: (bool? newValue) {
                          setState(() {
                            isPreview =
                                newValue; // Update the state of the checkbox
                          });
                        },
                      ),
                    ],
                  ),
                  const Text("Content type"),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<ContentType>(
                            value: ContentType.video,
                            groupValue: selectedContentType,
                            onChanged: (value) {
                              setState(() {
                                selectedContentType = value;
                              });
                            },
                          ),
                          const Text("Video"),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<ContentType>(
                            value: ContentType.article,
                            groupValue: selectedContentType,
                            onChanged: (value) {
                              setState(() {
                                selectedContentType = value;
                              });
                            },
                          ),
                          const Text("Article"),
                        ],
                      ),
                    ],
                  ),
                  if (selectedContentType == ContentType.video)
                    TextFormField(
                      controller: urlController,
                      decoration: const InputDecoration(
                        labelText: 'Video Link',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter title";
                        }
                        return null;
                      },
                    ),
                  if (selectedContentType == ContentType.video)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          // Hours Dropdown
                          SizedBox(
                            width: 70,
                            child: DropdownButtonFormField<int>(
                              value: hours,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              items: List.generate(2, (index) => index)
                                  .map((value) => DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(value.toString()),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  hours = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          // Minutes Dropdown
                          SizedBox(
                            width: 80,
                            child: DropdownButtonFormField<int>(
                              value: mins,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              items: List.generate(60, (index) => index)
                                  .map((value) => DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(value.toString()),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  mins = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          // Seconds Dropdown
                          SizedBox(
                            width: 80,
                            child: DropdownButtonFormField<int>(
                              value: secs,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              items: List.generate(60, (index) => index)
                                  .map((value) => DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(value.toString()),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  secs = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (selectedContentType != null)
                    TextFormField(
                      controller: descriptionController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
                onTap: () {
                  if (selectedContentType == null) {
                    return;
                  }
                  if (lectureformKey.currentState!.validate()) {
                    setState(() {
                      lecture = {};
                      lecture?['lectureTitle'] = titleController.text.trim();
                      lecture?['isPreview'] = isPreview;
                      lecture?['contentType'] =
                          enumToString(selectedContentType!);
                      if (descriptionController.text.trim().isNotEmpty) {
                        lecture?['description'] =
                            descriptionController.text.trim();
                      }
                      lecture?['videoUrl'] = urlController.text.trim();
                      lecture?['duration'] =
                          selectedContentType == ContentType.article
                              ? 60
                              : convertToSeconds();
                    });
                    widget.onSaved.call(lecture!);
                  }
                },
                child: Container(
                    color: Colors.blue,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Center(
                        child: Text(lecture == null ? "Create" : "Update",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)))))
          ],
        ),
      ),
    );
  }
}
