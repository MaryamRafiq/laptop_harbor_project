import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptor_harbor/post/posts.dart';
import '../product/product_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please login to view wishlist")),
      );
    }

    final wishlistRef = FirebaseFirestore.instance
        .collection('wishlist')
        .doc(user.uid)
        .collection('items');

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: StreamBuilder<QuerySnapshot>(
        stream: wishlistRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Your wishlist is empty"));
          }

          final wishlist = docs
              .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: wishlist.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              mainAxisSpacing: 12,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final item = wishlist[index];

              return _WishlistCard(
                post: item,
                onOpenDetails: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsPage(
                        productName: item.name,
                      ),
                    ),
                  );
                },
                onRemove: () {
                  wishlistRef.doc(item.name).delete();
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _WishlistCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onOpenDetails;
  final VoidCallback? onRemove;

  const _WishlistCard({
    required this.post,
    this.onOpenDetails,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpenDetails,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.red, size: 14),
                    SizedBox(width: 3),
                    Text("Wishlist"),
                  ],
                ),
                GestureDetector(
                  onTap: onRemove,
                  child: const Icon(Icons.close, size: 18, color: Colors.grey),
                )
              ],
            ),

            const SizedBox(height: 10),

            // image placeholder
            Container(
              height: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.laptop_mac, size: 34, color: Colors.red),
            ),

            const SizedBox(height: 10),

            Text(post.name,
                maxLines: 2,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),

            Text(
              post.specification,
              maxLines: 1,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                SizedBox(width: 4),
                Text(post.rating),
              ],
            ),

            const Spacer(),

            Text(
              "\$${post.price}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
