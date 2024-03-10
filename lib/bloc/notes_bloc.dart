import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes_bloc/database/database_helper.dart';
import 'package:notes_bloc/models/notes_model.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  DbHelper dbHelper;
  NotesBloc({required this.dbHelper}) : super(NotesInitial()) {
    on<FetchNotesEvent>(
      (event, emit) async {
        emit(NotesLoadingState());
        var notes = await dbHelper.showAllNotes();
        emit(NotesLoadedState(notesModel: notes));
      },
    );

    on<AddNotesEvent>(
      (event, emit) async {
        emit(NotesLoadingState());
        await dbHelper.addNotes(event.notesModel);
        var notes = await dbHelper.showAllNotes();
        emit(NotesLoadedState(notesModel: notes));
      },
    );

    on<UpdateNotesEvent>(
      (event, emit) async {
        emit(NotesLoadingState());
        await dbHelper.updateNotes(event.notesModel);
        var notes = await dbHelper.showAllNotes();
        emit(NotesLoadedState(notesModel: notes));
      },
    );

    on<DeleteNotesEvent>(
      (event, emit) async {
        emit(NotesLoadingState());
        await dbHelper.deleteNotes(event.id);
        var notes = await dbHelper.showAllNotes();
        emit(NotesLoadedState(notesModel: notes));
      },
    );
  }
}
