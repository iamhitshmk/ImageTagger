import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imgtag/models/user_data.dart';
import 'package:imgtag/models/user_model.dart';
import 'package:imgtag/screens/ProfileScreen.dart';
import 'package:imgtag/services/database_service.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final String userId;
  SearchScreen({this.userId});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  Future<QuerySnapshot> _users;

  _buildUserTile(User user) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          backgroundImage: user.profileImageUrl.isEmpty
              ? AssetImage('assets/images/user-placeholder.jpg')
              : CachedNetworkImageProvider(user.profileImageUrl),
        ),
        title: Text(
          user.name,
          style: TextStyle(
            fontFamily: 'PTSerif',
          ),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(
              currentUserId: Provider.of<UserData>(context).currentUserId,
              userId: user.id,
            ),
          ),
        ),
      ),
    );
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    _searchController.clear();
    setState(() {
      _users = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          style: TextStyle(
            fontFamily: 'PTSerif',
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(
                fontFamily: 'PTSerif',
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 30.0,
                color: Colors.deepPurple[300],
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.deepPurple[300],
                ),
                onPressed: _clearSearch,
              ),
              filled: true,
              fillColor: Colors.white),
          onSubmitted: (input) {
            print(input);
            if (input.isNotEmpty) {
              setState(() {
                _users = DatabaseService.searchUsers(input);
              });
            }
          },
        ),
      ),
      body: _users == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 70,
                    color: Colors.deepPurple[300].withOpacity(0.7),
                  ),
                  Text(
                    'Search for a user',
                    style: TextStyle(
                      fontFamily: 'PTSerif',
                      color: Colors.deepPurple[300].withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )
          : FutureBuilder(
              future: _users,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.documents.length == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.youtube_searched_for,
                          size: 70,
                          color: Colors.deepPurple[300].withOpacity(0.7),
                        ),
                        Text(
                          'No users found! Please try again.',
                          style: TextStyle(
                            fontFamily: 'PTSerif',
                            color: Colors.deepPurple[300].withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      User user = User.fromDoc(snapshot.data.documents[index]);
                      return _buildUserTile(user);
                    });
              },
            ),
    );
  }
}
