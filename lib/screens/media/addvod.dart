import 'package:devotionals/firebase/dbs/video.dart';
import 'package:devotionals/utils/models/vid.dart';
import 'package:devotionals/utils/widgets/default.dart';
import 'package:devotionals/utils/widgets/loading.dart';
import 'package:devotionals/utils/widgets/textfields.dart';
import 'package:flutter/material.dart';

class AddVideo extends StatefulWidget {
  const AddVideo({super.key});

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {

  final id = TextEditingController();
  final tag = TextEditingController();
  final cat = TextEditingController();
  final serie = TextEditingController();
  final part = TextEditingController();

  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(),
   

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: LoadingIndicator(
          loading: loading,
          child: Column(
            children: [
              SingleLineField(
                'Youtube ID',
                controller: id,
              ), 
              
              SizedBox(height: 15,),
              
              SingleLineField(
                'separate tags with comma',
                headerText: 'Tags',
                controller: tag,
              ), 
              
              SizedBox(height: 15,),
              
              SingleLineField(
                'Category',
                controller: cat,
              ), 
              
              SizedBox(height: 15,),
        
              SingleLineField(
                'optional',
                controller: serie,
                headerText: 'Series',
              ), 
              
              SizedBox(height: 15,),
        
              SingleLineField(
                'optional',
                controller: part,
                headerText: 'part in the series',
              ), 
              
              SizedBox(height: 30,),
        
              DefaultButton(
                onTap: ()async{
                  setState(() {
                    loading = true;
                  });
                  final v = VideoData(
                      id: id.text.trim(), 
                      time: DateTime.now(), 
                      tags: tag.text.split(','),
                      category: cat.text,
                      series: serie.text,
                      part: part.text,
                    );

                  await VideoService().addVideoData(
                    v   
                  );

                  setState(() {
                    loading = false;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}