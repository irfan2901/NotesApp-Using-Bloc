import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_bloc/bloc/notes_bloc.dart';
import 'package:notes_bloc/models/notes_model.dart';
import 'package:notes_bloc/utils/custom_widgets.dart';

class AddOrUpdateNotes extends StatefulWidget {
  final NotesModel? notesModel;
  const AddOrUpdateNotes({super.key, this.notesModel});

  @override
  State<AddOrUpdateNotes> createState() => _AddOrUpdateNotesState();
}

class _AddOrUpdateNotesState extends State<AddOrUpdateNotes> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController =
        TextEditingController(text: widget.notesModel?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.notesModel?.descrpition ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _saveNotes();
            },
            icon: const Icon(Icons.save),
          ),
          if (widget.notesModel != null)
            IconButton(
              onPressed: () async {
                _deleteNotes();
              },
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomWidgets.customTextField(titleController, 'Title'),
            CustomWidgets.customTextField(descriptionController, 'Description'),
          ],
        ),
      ),
    );
  }

  _saveNotes() {
    if (widget.notesModel != null) {
      var updatedNotes = NotesModel(
          id: widget.notesModel!.id,
          title: titleController.text,
          descrpition: descriptionController.text);
      context.read<NotesBloc>().add(UpdateNotesEvent(updatedNotes));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note Updated successfully!'),
        ),
      );
    } else {
      var newNote = NotesModel(
          title: titleController.text, descrpition: descriptionController.text);
      context.read<NotesBloc>().add(AddNotesEvent(newNote));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note added successfully!'),
        ),
      );
    }
    Navigator.pop(context);
  }

  _deleteNotes() {
    var id = widget.notesModel!.id;
    context.read<NotesBloc>().add(DeleteNotesEvent(id!));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note deleted successfully!'),
      ),
    );
    Navigator.pop(context);
  }
}
