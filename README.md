# codePush-ios
##EJUCheckVersionSDK
###使用方法
* 在工程中导入```EJUCheckVersionSDK.framework```,确保在工程设置的```Build Phases```-->```Link Binary with Libraries```下有导入的SDK库。
* 在需要做更新的地方，添加```<EJUCheckVersionSDK/EJUCheckVersion.h>```头文件，并做如下操作：

```
[[EJUCheckVersion sharedInstance] checkVersion:(NSString *)appleID];

- appleID : app对应的appStore的ID，指定哪个app检测更新请求
```
######说明:通过比对当前版本和服务器版本号，如有更新则跳转到appStore下载，如不更新则留在当前页。

* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

###EJUHotUpdateSDK使用方法
* 在工程中导入```EJUHotUpdateSDK.framework```,确保在工程设置的```Build Phases```-->```Link Binary with Libraries```下有导入的SDK库，以及libz.dylib动态依赖库(参考底部链接)。
* 在需要做更新的地方，添加```<EJUHotUpdateSDK/EJUHotUpdateServe.h>```头文件

```
    // 启动服务
    EJUHotUpdateServe *upDateServe = [EJUHotUpdateServe sharedInstance];
    upDateServe startServeWithHost:(NSString *)
                          filePath:(NSString *)
                           appName:(NSString *)
                         h5Version:(NSNumber *)];
```
* ```host```:要检查的服务器版本号的链接host（包括端口号） 例如：172.29.108.138:10086
* ```filePath```:本地h5资源的存放路径
* ```appName```:工程名称
* ```h5Version```:当前工程本地h5版本号

####检查服务器端h5版本号
##### * 此方法已包含在```启动服务```中,也可单独调用
```
[upDateServe checkVersionWithHost:(NSString *)host
 						 filePath:(NSString *)filePath
  						  appName:(NSString *)appName
  					    h5Version:(NSNumber *)h5Version
  					 successBlock:(successBlock)success];
```
* ```success```:请求后的回调block，返回值为服务器端最新的h5资源版本号。

####更新说明
* SDK会在应用每次启动后，调用此更新服务，将会下载最新的资源文件，解压并保存在本地路径下，再根据服务器的返回值```forceUpdate```来决定是否要立即更新，如果是，弹窗提示更新；否则，应用在下一次启动的时候把保存在本地的资源替换本地h5资源，执行文件内容。

####添加依赖库
- [添加依赖库 .dylib](http://www.jianshu.com/p/0795416593d4)
