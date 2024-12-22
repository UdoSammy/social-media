import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/auth/presentation/components/my_text_field.dart';
import 'package:socialapp/features/profile/domain/entities/profile_user.dart';
import 'package:socialapp/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:socialapp/features/profile/presentation/cubits/profile_states.dart';
import 'package:socialapp/features/profile/presentation/pages/profile_page.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // mobile image picker

  PlatformFile? imagePickedFile;

  // web picked image
  Uint8List? webImage;

  // method to pick the image
  Future<void> pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: kIsWeb);

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
      });

      if (kIsWeb) {
        webImage = imagePickedFile!.bytes;
      }
    }
  }

  final bioController = TextEditingController();

  void updateProfile() async {
    // profile cubit
    final profileCubit = context.read<ProfileCubit>();

    // prepare images
    final String uid = widget.user.uid;
    final String? newBio =
        bioController.text.isNotEmpty ? bioController.text : null;
    final mobileImagePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebPath = kIsWeb ? imagePickedFile?.bytes : null;

    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateProfile(
          uid: uid,
          newBio: newBio,
          mobileImagePath: mobileImagePath,
          imageWebBytes: imageWebPath);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        // profile loading
        if (state is ProfileLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    'U p l o a d i n g...',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              ),
            ),
          );
        }

        // profile error
        else if (state is ProfileError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    'Can not update bio at the moment',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          uid: widget.user.uid,
                        ),
                      ),
                    ),
                    child: Text(
                      'Return to profile page',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // profile loaded
        return buildEditPage();
      },
      listener: (context, state) {
        if (state is PorfileLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Bio'),
        foregroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        actions: [
          // save button
          IconButton(
            onPressed: updateProfile,
            icon: Icon(Icons.upload),
          )
        ],
      ),

      // body
      body: Column(
        children: [
          // profile picture
          Center(
            child: Container(
              clipBehavior: Clip.hardEdge,
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child:
                  // display image for mobile
                  (!kIsWeb && imagePickedFile != null)
                      ? Image.file(
                          File(imagePickedFile!.path!),
                          fit: BoxFit.cover,
                        )
                      :
                      // for web
                      (kIsWeb && webImage != null)
                          ? Image.memory(webImage!, fit: BoxFit.cover,)
                          :
                          // if there is no image
                          CachedNetworkImage(
                              imageUrl: widget.user.profileImageUrl,
                              // loading
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),

                              // erorr
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                size: 72,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              // loaded
                              imageBuilder: (context, imageProvider) => Image(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
            ),
          ),

          const SizedBox(
            height: 25,
          ),

          Center(
            child: MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: Text(
                'Pick Image',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          // bio

          Text(
            'Bio',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(
              controller: bioController,
              hintext: widget.user.bio,
              obscureText: false,
            ),
          )
        ],
      ),
    );
  }
}
