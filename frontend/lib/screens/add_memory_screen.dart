import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/memory/memory_bloc.dart';
import '../bloc/memory/memory_event.dart';
import '../bloc/memory/memory_state.dart';
import '../services/audio_service.dart';

class AddMemoryScreen extends StatefulWidget {
  const AddMemoryScreen({super.key});

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final _textController = TextEditingController();
  final _titleController = TextEditingController();
  final _audioService = AudioService();
  String? _recordingPath;
  bool _isRecording = false;

  @override
  void dispose() {
    _textController.dispose();
    _titleController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final path = await _audioService.startRecording();
    if (path != null) {
      setState(() {
        _recordingPath = path;
        _isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    final path = await _audioService.stopRecording();
    setState(() {
      _isRecording = false;
      if (path != null) {
        _recordingPath = path;
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null && mounted) {
      context.read<MemoryBloc>().add(UploadImage(image.path));
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null && mounted) {
      final filePath = result.files.single.path!;
      context.read<MemoryBloc>().add(UploadImage(filePath));
    }
  }

  void _uploadText() {
    if (_textController.text.isNotEmpty) {
      context.read<MemoryBloc>().add(
            UploadText(
              content: _textController.text,
              title: _titleController.text.isEmpty
                  ? null
                  : _titleController.text,
            ),
          );
    }
  }

  void _uploadAudio() {
    if (_recordingPath != null) {
      context.read<MemoryBloc>().add(UploadAudio(_recordingPath!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Memory'),
      ),
      body: BlocListener<MemoryBloc, MemoryState>(
        listener: (context, state) {
          if (state is MemoryUploaded) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Memory uploaded successfully!')),
            );
          } else if (state is MemoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Text Input Section
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Text Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _uploadText,
                icon: const Icon(Icons.text_fields),
                label: const Text('Save Text'),
              ),
              const Divider(height: 32),
              // Audio Recording Section
              const Text(
                'Audio Recording',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isRecording)
                    ElevatedButton.icon(
                      onPressed: _startRecording,
                      icon: const Icon(Icons.mic),
                      label: const Text('Start Recording'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: _stopRecording,
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop Recording'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
              if (_recordingPath != null) ...[
                const SizedBox(height: 16),
                Text('Recording saved: ${_recordingPath!.split('/').last}'),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _uploadAudio,
                  icon: const Icon(Icons.upload),
                  label: const Text('Upload Audio'),
                ),
              ],
              const Divider(height: 32),
              // Image Upload Section
              const Text(
                'Image Upload',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Image'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.file_upload),
                    label: const Text('Pick File'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

