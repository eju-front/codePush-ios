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
