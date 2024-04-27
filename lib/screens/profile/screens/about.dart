// Welcome to Charismatic Renaissance Int'l Church Inc (Next Generation Church).

// At Charismatic we recognize the Lordship of Jesus Christ and the leading of the Holy Spirit in everything we do before, during and after services. In our services we create experiences where people hear the word of God, encounter the love of God and are refreshed by the power of God’s Spirit in an atmosphere of inspiration and excellence.




// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/constants/colors.dart';

class AboutWidget extends StatelessWidget {


  const AboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light
        ),
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: BoxDecoration(
              gradient: SweepGradient(
                colors: [
                  cricColor.shade300,
                  cricColor.shade200,
                  cricColor.shade300,
                  cricColor.shade200,
                  cricColor.shade300,
                  cricColor.shade200,
                  cricColor.shade300,
                  cricColor.shade200,
                  cricColor.shade300,
                  cricColor.shade200,
                  cricColor.shade300,
                  cricColor.shade200
                ]
              )
            ),
          ),
        ),

        title: Text(
          'About CRIC'
        ),

      ),


      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                """Apostle David Wale Feso began God’s Ultimate Young Soldiers(GUYS) a campus fellowship on November 15th 1997 on the grounds of Christian Faith University (CFU) now known as Benson Idahosa University (BIU) Ugbor, Benin City, Edo State with about eighty students from the University and the Bible School (All Nations for Christ Bible Institute) in attendance. The meeting was characterized with the demonstrations of the Spirit and the gifts of the Spirit in manifestation.
Other Campus Fellowships was pioneered in the United States, Delta State University, Niger Delta University etc.
Six years after GUYS was started, it became a church on the 6th of April 2013 known as NLCC situated at former Emotan Hotel along Commercial Avenue, Benin City Edo State, and Forty four (44) persons were in attendance. Wings of Healing the first healing crusade of the ministry was held in the Peniel Chapel of Al Nations For Christ Bible Institute on the 24th of January 2004. People got healed by the Power of the Holy Spirit and so many inspiring testimonies, as deaf ears were unstopped, bones were mended, and the unsaved received salvation , it was an amazing meeting which marked the beginning of the ministry’s healing crusades.
In March 2004, Wings of Healing was held in Warri, Delta State at the Main auditorium of the NNPC Junior Staff Club in DDPA Housing Estate. God also did special miracles by the hands of Apostle David Wale Feso. Immediately after this healing crusade, a Church was started in Warri.
On Sunday January 31st 2005, based on the broader vision of the ministry given to Apostle David Wale Feso. “To take the Love of God, The Word of God, and the Healing Power of God, To every individual, To every home, To every city, To every State, To every nation, To every continent, Every day, through every available means.”The name of the ministry became New Life International Christian Centre.”
On July 11th 2005, Apostle David Wale Feso moved from Benin City to Yenagoa, Bayelsa State based on God’s instruction and the rhema given to him from Matthew 4:16,”The people that sat in darkness saw a great light, to them that sat in the region and shadow of death, light is sprung up.”      
A fresh work was started by Apostle David Wale Feso in Agudama, Yenagoa, Bayelsa State. Before the end of the year 2005, the church had grown to having about a hundred members.
Today, the Church has a Radio ministry called “Sound Dynamics” based on Romans 10:17, 18 which started in 2004 in Benin City, Edo State. Sound Dynamics is aired on five Radio stations in Bayelsa State.""",

                style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 2),
              
              ),


              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}