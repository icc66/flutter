import 'dart:convert' as convert;
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'douyin.dart';
import 'httpHeaders.dart';
import 'package:permission_handler/permission_handler.dart';
import 'oplayer.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()));
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String showText = '请输入网址';
  String vurl = '';
  bool hil = false;
  var _username = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
        icon: Icon(Icons.mode_edit),
        hintText: "https://",

    );
    return Scaffold(
        appBar: AppBar(
          title: Text('抖音解析无水印'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'asstes/52377818.png',
                      fit: BoxFit.fill,
                      width: 300,
                      height: 400,
                    )),
                TextField(
                  decoration: inputDecoration,
                  controller: _username,
                ),
                RaisedButton(
                  onPressed: () {
                    _juejin(url: this._username.text);
                    hil = true;
                  },
                  child: Text('解析1'),
                ),
                RaisedButton(
                  onPressed: () {
                    pppo(this._username.text).then((val) {
                      setState(() {
                        if (val == 5) {
                          showText = '解析失败!!!';
                          vurl = '';
                        } else {
                          vurl = val['url'];
                          //print(vurl);
//https://v.douyin.com/JJVsUkT
                          //http://v.douyin.com/xGSE7P
                          showText = '解析完成';
                        }
                      });
                    });
                    hil = true;
                  },
                  child: Text('解析2'),
                ),
                Text(showText),
                //
                vvcc(),
                //Text(showText),
              ],
            ),
          ),
        ));
  }

  vvcc() {
    if (showText == '请输入网址') {
       return Center(
       
      );
    } else if (showText == '解析失败!!!') {
      return Text('1.网络信号差.\n2.输入有误\n3.解析失效');
    } else {
      if (vurl != '') {
        return IconButton(
          onPressed: () {
            //   Navigator.push(
            //       context, MaterialPageRoute(builder: (context) => DYixz(vurl)));
            // },
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DYixz(vurl)));

          },
          icon: Icon(Icons.file_download, size: 46, color: Colors.red),
        );
      }else{return Center(
       child: CircularProgressIndicator(strokeWidth: 2.0),
      );}
    }
  }

  pppo(d) async {
    d = 'http://tool.bbkl.top/dyjx/ajax.php?act=dy&url=$d';
    try {
      var response = await http.get(d);

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        return jsonResponse;
      } else {
        return 5;
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  void _juejin({String url}) {
    //print('开始向极客时间请求数据..................');

    url = 'https://www.ppwit.com/dy/dy.php?url=$url';
    getVideos(url).then((val) {
      setState(() {
        String bbb = '&ratio=720p&line=0';
        if (val == 5) {
          showText = '解析失败!!!';
          vurl = '';
        } else {
          var pp = val.itemList[0].video.playaddr.uri;
          vurl = 'https://aweme.snssdk.com/aweme/v1/play/?video_id=$pp$bbb';
          //http://v.douyin.com/xGSE7P
          showText = '解析完成';
        }
      });
    });
  }

  getVideos(v) async {
    try {
      var response = await http.get(v);

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);

        VideoData videoData = VideoData.fromJson(jsonResponse);
        if (videoData.statusCode == 5) {
          return videoData.statusCode;
        } else {
          return videoData;
        }
      }
    } catch (e) {
      return print(e);
    }
  }

  Future getHttp(url) async {
    try {
      Response response;
      Dio dio = new Dio();
      dio.options.headers = httpHeaders85;
      response = await dio.get(url);
      //print(response.toString());
      return response.data;
    } catch (e) {
      return print(e);
    }
  }
}

//自定义组件
class DYixz extends StatefulWidget {
  final vurl;

  final dpz;

  DYixz(this.vurl, {this.dpz});

  @override
  _DYixzState createState() => _DYixzState();
}

class _DYixzState extends State<DYixz> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  Random numl = Random();
  List numo = [];
  var dpz;
  Color _colord;
  

  void initState() {
    
    _colord = Colors.white;
    numo.add(numl.nextInt(3000));
    numo.add(numl.nextInt(numo[0]));
    numo.add(numl.nextInt(numo[0]));
    dpz = widget.dpz ?? numo;
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
    //Curvedanimation弹性动画.非线性的
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //动画在结束时停止的状态
          controller.reverse(); //颠倒
        } else if (status == AnimationStatus.dismissed) {
          //动画在开始时就停止的状态
          //controller.forward(); //向前
        }
      })
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(child: Oplayer(url: widget.vurl)),
      ScaleTransition(
        alignment: Alignment.center,
        scale: animation,
        child: Align(
            //alignment: Alignment.center,
            widthFactor: 100,
            heightFactor: 100,
            child: Icon(Icons.favorite, size: 200, color: Colors.red[400])),
      ),
      Positioned(
          bottom: 20,
          right: 0,
          child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 15, 120),
              child: Column(children: <Widget>[
                Container(
                    child: Column(children: <Widget>[
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_colord == Colors.white) {
                          _colord = Colors.red;
                          //红心+1

                          controller.forward();
                        } else {
                          _colord = Colors.white;
                        }
                      });
                    },
                    icon: Icon(Icons.favorite, size: 36, color: _colord),
                  ),
                  Text(
                    '点一下',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        decoration: TextDecoration.none),
                  )
                ])),
                SizedBox(height: 10),
                Container(
                  child: Column(children: <Widget>[
                    IconButton(
                      onPressed: () {
                        //downloading(widget.vurl);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Pdownloading(widget.vurl)));
                       
                      },
                      icon: Icon(Icons.file_download, size: 36, color: _colord),
                    ),
                    Text(
                      'down',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                  ]),
                ),
                SizedBox(height: 10),
                Container(
                    child: Column(children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    icon: Icon(Icons.near_me, size: 36, color: _colord),
                  ),
                  Text(
                    '返回',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        decoration: TextDecoration.none),
                  ),
                ])),
              ])))
    ]));
  }
}

class Pdownloading extends StatefulWidget {
  final cvv;
  Pdownloading(this.cvv);
  @override
  _PdownloadingState createState() => _PdownloadingState();
}

class _PdownloadingState extends State<Pdownloading> {
  Random numl = Random();
  double currentProgress = 0.0;

  ///下载文件的网络路径

  var nu;

  String vvvd;
  @override
  void initState() {
    super.initState();
    nu = numl.nextInt(300000000)..toString();
    applyPermission();
  }

  //_requestPermissions();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
            body: Container(
                alignment: Alignment.center,
                child: (currentProgress == 0.0)
                    ? Container(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                        Text('正在初始化...'),
                        RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));
                           
                          },
                          child: Text('取消'),
                        ),
                        Text('如果下载不成功,\n1请检查网络状态\2软件权限不足,\n请打开手机设置中的应用管理,\n权限管理,\n允许软件读写权限\n然后重启本软件,即可下载保存\n视频默认保存路径在Download中')
                      ]))
                    : Container(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                        Text('正在下载'),
                        Text(vvvd),
                        RaisedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return HomePage();
                            }), (route) => false);
                          },
                          child: Text('完成'),
                        ),
                        Text('如果下载不成功,\n1请检查网络状态\2软件权限不足,\n请打开手机设置中的应用管理,\n权限管理,\n允许软件读写权限\n然后重启本软件,即可下载保存\n视频默认保存路径在Download中')
                      ])))));
  }

//动态申请权限
Future applyPermission(
      {String atcUrl, String atcName, BuildContext context}) async {
//    只有当用户同时点选了拒绝开启权限和不再提醒后才会true
    bool isSHow = await PermissionHandler()
        .shouldShowRequestPermissionRationale(PermissionGroup.storage);
    // 申请结果  权限检测
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
 
    if (permission != PermissionStatus.granted) {
      //权限没允许
      //如果弹框不在出现了，那就跳转到设置页。
      //如果弹框还能出现，那就不用管了，申请权限就行了
      if (!isSHow) {
        await PermissionHandler().openAppSettings();
      } else {
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
        //此时要在检测一遍，如果允许了就下载。
        //没允许就就提示。
        PermissionStatus pp = await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.storage);
        if (pp == PermissionStatus.granted) {
          //去下载吧
          downApkFunction();
        } else {
          // 参数1：提示消息// 参数2：提示消息多久后自动隐藏// 参数3：位置
          Fluttertoast.showToast(
        msg: "请允许存储权限，并重试！",
        toastLength: Toast.LENGTH_SHORT,
        webBgColor: "#e74c3c",
        timeInSecForIosWeb: 5,
        );
 
         
        }
      }
    } else {
      //权限允许了，那就下载吧、
      downApkFunction();
    }
  }


  ///使用dio 下载文件
  void downApkFunction() async {
    /// 申请写文件权限

    ///创建DIO
    Dio dio = new Dio();
    //设置连接超时时间
    dio.options.connectTimeout = 500000;
    //设置数据接收超时时间
    dio.options.receiveTimeout = 500000;

    ///参数一 文件的网络URL
    ///参数二 下载的本地目录文件
    ///参数三 下载监听
   try{ Response response = await dio
        .download(widget.cvv, "/storage/emulated/0/Download/$nu.mp4",
            onReceiveProgress: (received, total) {
      if (total != -1) {
        ///当前下载的百分比例
        
        setState(() {
          vvvd = (received / total * 100).toStringAsFixed(0) + "%";
        // CircularProgressIndicator(value: currentProgress,) 进度 0-1
        currentProgress = received / total;
        });
      }
    });
    if (response.statusCode == 200) {
      print('正在下载...');
    }}catch(e){
      Response response = await dio
        .download(widget.cvv, "$nu.mp4",
            onReceiveProgress: (received, total) {
      if (total != -1) {
        ///当前下载的百分比例
        
        setState(() {
          vvvd = (received / total * 100).toStringAsFixed(0) + "%";
        // CircularProgressIndicator(value: currentProgress,) 进度 0-1
        currentProgress = received / total;
        });
      }
    });
    if (response.statusCode == 200) {
      print('正在下载...');
    }
  }

  ///获取手机的存储目录路径
  ///getExternalStorageDirectory() 获取的是  android 的外部存储 （External Storage）
  ///  getApplicationDocumentsDirectory 获取的是 ios 的Documents` or `Downloads` 目录

}
//http://v.douyin.com/xGSE7P
}