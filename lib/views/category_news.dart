import 'package:bharatapp/helper/news.dart';
import 'package:bharatapp/models/article_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'article_view.dart';
class CategoryNews extends StatefulWidget {
  
  final String category;
  CategoryNews({this.category});
  
  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  
  List<ArticleModel> articles=new List<ArticleModel>();
  bool _loading=true;
  
  @override
  void initState() {
    super.initState();
    getCategoryNews();
  }

  getCategoryNews() async{
    CategoryNewsClass newsClass= CategoryNewsClass();
    await newsClass.getNews(widget.category);
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
            Text(widget.category.toUpperCase(),style: TextStyle(color: Colors.blue),),
          ],
        ),
        actions: <Widget>[
          Opacity(
            opacity: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.share),
            ),
          )
        ],
        elevation: 0,
        centerTitle: true,
      ),
      body:  _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ):
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
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
