import 'package:bharatapp/helper/data.dart';
import 'package:bharatapp/helper/news.dart';
import 'package:bharatapp/models/article_model.dart';
import 'package:bharatapp/models/category_model.dart';
import 'package:bharatapp/views/article_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'category_news.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoryModel> categories=new List<CategoryModel>();
  List<ArticleModel>  articles=new List<ArticleModel>();
  bool _loading=true;

  @override
  void initState() {
    super.initState();
    categories=getCategories();
    getNews();
  }

  getNews() async{
    News newsClass= News();
    await newsClass.getNews();
    articles=newsClass.news;
    setState(() {
      _loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Bharat"),
            Text("News",style: TextStyle(color: Colors.blue),)
          ],
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ):
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                ///Categories
                Container(
                  height: 100,
                  child: ListView.builder(
                      itemCount: categories.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context , index){
                        return CategoryTile(
                          imageUrl: categories[index].imageUrl,
                          categoryName: categories[index].categoryName,
                        );
                      },
                  ),
                ),
                ///Blogs
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: articles.length,
                      itemBuilder: (context,index){
                        return BlogTile(
                          imageUrl: articles[index].urlToImage,
                          title:articles[index].title ,
                          desc: articles[index].description,
                          url: articles[index].url,
                        );
                      }
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}

///CategoryTile

class CategoryTile extends StatelessWidget {
  final String imageUrl,categoryName;
  CategoryTile({this.imageUrl,this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
         Navigator.push(context,MaterialPageRoute(
           builder: (context)=> CategoryNews(
             category:categoryName.toLowerCase(),
           )
         ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,width: 140,height: 90, fit: BoxFit.cover,
                )
            ),
            Container(
              alignment: Alignment.center,
              width: 140,height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(categoryName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// BlogTile
class BlogTile extends StatelessWidget {
  final String imageUrl,title,desc,url;
  BlogTile({@required this.imageUrl,@required this.title,@required this.desc,@required this.url});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(
          builder: (context)=> ArticleView(
             blogUrl: url,
          )
        ));
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              Image.network(imageUrl),
              SizedBox(
                height: 10,
              ),
              Text(title,style: TextStyle(
                fontSize: 17,
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(
                height: 9,
              ),
              Text(desc,style: TextStyle(
                color: Colors.black54,
                fontSize: 14
              ),)
            ],
          ),
        ),
      ),
    );
  }
}


