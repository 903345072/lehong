import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterapp2/SharedPreferences/TokenStore.dart';
import 'package:flutterapp2/net/Address.dart';
import 'package:flutterapp2/net/HttpManager.dart';
import 'package:flutterapp2/net/ResultData.dart';
import 'package:flutterapp2/pages/IndexPage.dart';
import 'package:flutterapp2/pages/Mine.dart';
import 'package:flutterapp2/pages/pay.dart';
import 'package:flutterapp2/utils/JumpAnimation.dart';
import 'package:flutterapp2/utils/Rute.dart';
import 'package:flutterapp2/utils/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'package:tobias/tobias.dart' as tobias;


class recharge extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Login_();
  }
}

class Login_ extends State<recharge> {
  String old_pwd;
  String new_pwd;
  String re_pwd;

  bool check = false;
  double give_money =0;
  FocusNode _commentFocus;
  bool is_show = true;
  int yj ;
  int pay_type = 1;
  double rate = 0.05;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getrate();
  }

  getrate() async{
    ResultData result = await HttpManager.getInstance().get("getrate",withLoading: false);
    setState(() {
      rate = double.parse(result.data["data"])/100;

    });
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 417, height: 867)..init(context);

    // TODO: implement build
    return FlutterEasyLoading(
      child: Scaffold(
        appBar: AppBar(

          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(
            size: 25.0,
            color: Colors.white, //????????????
          ),
          backgroundColor: Color(0xfffa2020),
          title: Text("??????",style: TextStyle(fontSize: ScreenUtil().setSp(18)),),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text("??????????????????"),
                      ),
                      Container(
                        color: Colors.white,
                        child: Wrap(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Container(
                              width: ScreenUtil().setWidth(399),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Image.asset("img/alipay.jpg",fit: BoxFit.fill,width: ScreenUtil().setWidth(100),),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("?????????????????????"),
                                          Text("???????????????,????????????",style: TextStyle(color: Colors.grey),),
                                        ],
                                      )
                                    ],
                                  ),
                                  Radio(
                                    value:1,
                                    groupValue:this.pay_type,
                                    onChanged:(v){
                                      setState(() {
                                        this.pay_type = v;
                                      });
                                    },
                                  ),

                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: ScreenUtil().setWidth(399),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Image.asset("img/wxpay.jpg",fit: BoxFit.fill,width: ScreenUtil().setWidth(100),),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("??????????????????"),
                                          Text("????????????,????????????",style: TextStyle(color: Colors.grey),),
                                        ],
                                      )
                                    ],
                                  ),
                                  Radio(
                                    value:2,
                                    groupValue:this.pay_type,
                                    onChanged:(v){
                                      setState(() {
                                        this.pay_type = v;
                                      });
                                    },
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text("?????????????????????(???)"),
                      ),
                      Expanded(
                        child: TextField(
                          //??????2??????],//?????????????????????
                          onChanged: (e) {

                            setState(() {
                              is_show = true;
                             yj = int.parse(e);
                             int w = DateTime.now().weekday;

                             give_money = yj*rate;
                            });

                          },
                          controller: TextEditingController.fromValue(
                              TextEditingValue(
                                  text:
                                  '${this.yj == null ? "" : this.yj}',
                                  selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity:
                                          TextAffinity.downstream,
                                          offset: '${this.yj}'.length)))),
                          keyboardType: TextInputType.number,
                          //???????????????????????????

                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            hintText: "",
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(0))),
                          ),
                        ),
                      ),
                      Divider()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10,top: 10),
                  child: Text("????????????:"+give_money.toStringAsFixed(2)+"???",style: TextStyle(color: Colors.red),),
                ),
                Container(
                  alignment: Alignment.center,
                  child: MaterialButton(
                    disabledColor: Colors.grey,
                    minWidth: ScreenUtil().setWidth(390),
                    color: Colors.red,
                    onPressed: is_show?() async {


                      if(yj != null){
                        if(yj<1){
                          Toast.toast(context,msg: "?????????????????????");
                          return;
                        }

                      }else{
                        Toast.toast(context,msg: "?????????????????????");
                        return;
                      }

                      setState(() {
                        is_show = false;
                      });

                      ResultData res = await HttpManager.getInstance().post("recharge/wechat",params: {"price":yj,"type":pay_type,"from":"weixinh5"},withLoading: false);

                      Map data = jsonDecode(res.data["data"]);
                      int type_ = data["type"];

                         JumpAnimation().jump(pay(data), context);

//                      if(data["code"] == 200){
//                        if(type_ == 1){
//                          Future s=   tobias.aliPay(data['url']) ;
//                        }else{
//                          JumpAnimation().jump(pay(data["data"]), context);
//                        }
//
//                      }else{
//                        sleep(Duration(seconds: 1));
//                        Toast.toast(context,msg: data["data"],showTime: 2000);
//                      }
                    }:null,
                    child: Text("????????????",style: TextStyle(color: Colors.white),),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text("??????:?????????????????????????????????1???"),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10,bottom: 10),
                  alignment: Alignment.center,
                  child: Text("???????????????",style: TextStyle(color: Colors.orangeAccent),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,bottom: 10),
                  child: Text("1??????????????????????????????????????????????????????100%??????????????????",style: TextStyle(fontSize: 12),),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text("2??????????????????????????????????????????????????????1-2????????????????????????QQ470274859",style: TextStyle(fontSize: 12),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text("3??????????????????????????????????????????????????????????????????",style: TextStyle(fontSize: 12),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text("4????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????",style: TextStyle(fontSize: 12),),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
