# teahouse清竹茶馆

一个flutter项目，关于清竹茶馆，关于有故事的茶馆。

## 目录架构

```
feapp/
  |
  ├──lib/                     * flutter代码主目录
  │   │
  │   │──config/              * api地址管理
  │   │ 
  │   │──pages/               * 页面目录
  │   │ 
  │   │──provides/            * 状态管理
  │   │ 
  │   │──service/             * 网络请服务
  │   │ 
  │   └──main.dart            * flutter入口文件
  │
  ├──android/                 * android打包配置
  │
  ├──ios/                     * ios打包配置
  │
  ├──test/                    * 测试
  │
  │──.metadata                * meta data
  │
  │──.gitignore               * Git忽略文件配置
  │
  │──pubspec.lock             * 包信息
  │
  │──pubspec.yaml             * 包信息
  │
  └──README.md                * readme

```
## 环境配置
- [安装flutter](https://flutterchina.club/get-started/install/)
- [配置编辑器](https://flutterchina.club/get-started/editor/#vscode)
- [初始化](https://flutterchina.club/get-started/test-drive/#terminal)

## 本地开发
```
flutter doctor  // 检查环境是否搭配好
```
```
flutter packages get // 安装依赖包
```

然后启动虚拟机，或者使用真机连接电脑

```
flutter run // 本地开发测试
```
使用r键热加载，使用R重新加载。

## 打包
引用应用程序中的keystore
创建一个名为```<app dir>/android/key.properties```的文件，其中包含对密钥库的引用：
```
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=key
storeFile=<location of the key store file, e.g. /Users/<user name>/key.jks>
```

```
cd <app dir>
flutter build apk // 打包好的apk位于<app dir>/build/app/outputs/apk/app-release.apk
```

打包文档请查阅

- [发布Android版APP](https://flutterchina.club/android-release/)
- [发布的IOS版APP](https://flutterchina.club/ios-release/)