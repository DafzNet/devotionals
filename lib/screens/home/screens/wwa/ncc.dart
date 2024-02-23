import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NewCreationCreed extends StatefulWidget {
  const NewCreationCreed({super.key});

  @override
  State<NewCreationCreed> createState() => _NewCreationCreedState();
}

class _NewCreationCreedState extends State<NewCreationCreed> {
  @override
  Widget build(BuildContext context) {


String beliefs = '''
1. We are committed to teaching and preaching God’s word with Accuracy, Integrity and Authority so that unbelievers may find Christ and believers mature in Him (Acts 2:42, Eph. 4:11-16, Acts 6:2-4).

2. We believe that prayer is vital to Christian ministry. Therefore, the ministry and activities of the church will be characterized by reliance on personal and corporate prayer (Ephesians 6:18-20; 1:6, Acts 6:2, 4:6. Romans 15:30-31, Colossians 4:2-4). we believe that every Christian is called to pray (1Timothy 2:8, Luke 18:1).

3. We believe that all activities and ministry of this Church should be done according to the leading, guidance, direction and leadership of the Holy Spirit (Acts 1:2, 4:19-20, 10:19-20, 13:2-4, 15:28).

4. We believe that primary responsibility of Pastors and Teachers in the Local Church is to prepare God’s people for works of service and to motivate them toward evangelism (Ephesians 4:11-12, 2Corinthians 5:18). Therefore, all members are trained to participate actively in ministry (Ephesians 4:11-16.).

5. We believe that as children of God, it is our responsibility to communicate the love of God to ne another through mutual fellowship, small groups, giving and caring for one another and for those outside the church (Acts 2:44-45, 4:32-37). We believe giving is an expression of our love life. We consider it a part of our calling to lovingly respond to the needs of others. We are called to take the love of God to every individual.

6. We believe in evangelism (Matthew 28:19-20, Mark 16:15, 2Corinthians 15:18, Acts 8:4, Mark 16:20) We also believe it is our sacred responsibility to reach the world with the Word of God. We will actively pursue means, methods and strategies that will enhance and facilitate our effort towards evangelism.

7. We believe that every believer should be a healing minister (Mark 16:17-18) Therefore, we will train them to minister healing to the sick (Matthew 10:1, Mark 3:13-15).

8. We believe in excellence in ministry because we are called to set forth a standard. Thus we will encourage all members to be worthy examples in society and give their best effort to the ministry’s vision and goals.

9. We believe that all we do in the House of God as service to God should be done from the heart and reverence (Acts 2:43, Hebrews 12:28, Colossians 3:22-24, Ephesians 6:5-7, 2Corinthians 8:5).

10. We believe that every member should be actively involved in Public Services (Sunday, Wednesday and Friday), the Cell System (caring networks and life groups) and functional in at least one service department. e.g. Choir, Protocol, Sound, Maintenance and Decoration etc. (Acts 2:46, 20:20, Romans 12:4-11, 1Corinthians 12:7-40). We believe that this is necessary for one’s spiritual health and maturity. It is also a measure of commitment in this ministry.

11. We believe that everyone who professes truth in Christ should be baptized (Mark 16:16, Matthew 28:19). We also believe that all such believers should be raised through a discipleship process.

12. We believe that the goal of the Christian life is to be like Jesus. Therefore, Jesus Christ is the model for all that we do as a Church. All members enjoined to pattern their lives after Christ (Ephesians 4:11-12, 15, Galatians 1:15-16, Ephesians 5:1-2, 1John 4:17).

13. We believe that praise and worship is an integral part of all meetings (Acts 2:47). We believe it opens the heart of men to the influence of God’s Spirit (Acts 13:2-3). It creates an atmosphere for the miraculous (Acts 16:25-26). It is also an avenue to express our appreciation and honour to God.

14. We believe that every believer should excel in their fields of endeavour, therefore, we shall provide information, principles and strategies that will enhance their effectiveness in the post-modern society. (Joshua 1:7-9, Psalm 1:1-3, 3 John 2:4, Isiaiah 48:17)
''';


String ncc = '''
I Belong to the NEW ORDER
God’s NEW RACE the Church
I am a NEW CREATION in Christ Jesus
Who LOVED ME and gave HIMSELF for me
I’ve been DELIVERED from the power of darkness
and translated into the kingdom of God’s dear Son
I am the RIGHTEOUSNESS of God in Christ Jesus
I am FREE from the LAW OF SIN and DEATH,
I have the LOVE OF GOD abounding in MY HEART in a greater measure
The POWER and ABILITY of GOD are at work within me and through me
I have a SOUND MIND, the MIND OF CHRIST
MENTAL SAGACITY that surpasses Human intelligence
ETERNAL LIFE has permeated my being
I live in DIVINE HEALTH for by HIS STRIPES I WAS HEALED
God is causing all GRACE, every FAVOUR and all EARTHLY BLESSINGS to come to me in abundance
I have VICTORY over satan, sin, sickness, weakness , disease, fear, death and hell
I’m a joint heir with Jesus, seated in heavenly places in Christ Jesus
I am God’s point of contact to my world,
Declaring God’s love plan to all men
Persuading them to come and enjoy the benefits of the NEW CREATION life in Christ Jesus.
''';

String declare2024 = '''
This is my Year of Uncommon Wisdom
Christ is my wisdom from God
The Spirit of Wisdom is within me
The Word of God is wisdom available to me
I cannot be disadvantaged
The wisdom of God is working in me
I know what to do
I know where to go
I know whom to meet
By the Wisdom of God I find favor with all people
I guide all my affairs with discretion
By the Wisdom of God I prosper in all that I do
I am full of witty inventions
By the Wisdom of God I am a blessing to my world
I demonstrate the Character and the Charisma of Christ
In Jesus Name,
Amen
''';







   return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
            title: Text('Statements'),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Core Value'),
                Tab(text: 'New Creation Creed'),
                Tab(text: '2024 Confession'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TabBarView(
              children: [    
                SingleChildScrollView(
                  child: Text(
                    beliefs,
                  
                    style: TextStyle(
                      height: 2,
                    ),
                  ),
                ),

                SingleChildScrollView(
                  child: Text(
                    ncc,
                  
                    style: TextStyle(
                      height: 2,
                    ),
                  ),
                ),

                SingleChildScrollView(
                  child: Text(
                    declare2024,
                  
                    style: TextStyle(
                      height: 2,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}