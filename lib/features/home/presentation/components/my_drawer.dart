import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialapp/features/home/presentation/components/my_drawer_tile.dart';
import 'package:socialapp/features/profile/presentation/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),

              // home tile
              MyDrawerTile(
                icon: Icons.home,
                text: 'H O M E',
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              // profile tile
              MyDrawerTile(
                icon: Icons.person,
                text: 'P R O F I L E',
                onTap: () {
                  Navigator.pop(context);

                  // get current user id
                  final user = context.read<AuthCubit>().currentUser;
                  String uid = user!.uid;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(uid: uid,),
                    ),
                  );
                },
              ),

              // search tile
              MyDrawerTile(
                icon: Icons.search,
                text: 'S E A R C H',
                onTap: () {},
              ),

              // setting tile
              MyDrawerTile(
                icon: Icons.settings,
                text: 'S E T T I N G S',
                onTap: () {},
              ),

              Spacer(),

              // logout tile
              MyDrawerTile(
                icon: Icons.logout,
                text: 'L O G O U T',
                onTap: () =>  context.read<AuthCubit>().logout(),
              ),

              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
