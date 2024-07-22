
import 'package:assignbot/component/dimension.dart';
import 'package:assignbot/pages/login_pages/login_page.dart';
import 'package:assignbot/pages/login_pages/signup_page.dart';
import 'package:assignbot/widgets/custom_button.dart';
import 'package:flutter/material.dart';


class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFF60205),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                child: Image.asset('assets/1.png'),
              ),
              Text('AssignBot',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [

            SizedBox(height: SC.fromHeight(10),),
            Container(
              // decoration: BoxDecoration(border: Border.all()),
              width: SC.fromWidth(20),
              height: SC.fromHeight(2.3),
              child: Image.asset('assets/1.png'),
            ),

            Center(
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Color(0xFFF60205), Color(0xFFFFDE59)], // Gradient colors
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: RichText(
                  text: TextSpan(
                    text: '    Welcome to\n', // First part of the text
                    style: TextStyle(
                      fontSize: SC.fromWidth(11), // Smaller font size for "Welcome to"
                      fontWeight: FontWeight.w500, // Regular weight
                      color: Colors.white, // Text color (not used in gradient)
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' SatyaKabir Chat', // Second part of the text
                        style: TextStyle(
                          fontSize: SC.fromWidth(12), // Larger font size for "AssignBot"
                          fontWeight: FontWeight.w500, // Regular weight
                          color: Colors.white, // Text color (not used in gradient)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: SC.fromHeight(25),),

            CustomButton(text: 'LOGIN', onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
            },
            ),
            SizedBox(height: SC.fromHeight(45),),
            CustomButton(
              text: 'SIGN UP', onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupPage()),
              );
            },
            ),

          ],
        ),
      ),
    );
  }
}
