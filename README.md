SimpleMVC是什么？
===============
一个轻量级的，可扩展的，工具化自动化的，具有（或将具有）丰富的易于使用的模块功能（通过扩展机制扩展）的ActionScript 3.0框架。
支持以其开发具有MVCS结构的Flex、纯AS3及AIR桌面或移用项目。

SimpleMVC框架代码设计细则：
======================
1. 不使用this关键字，除非在return关键字之后
2. 接口不另继承接口
3. 构造器留空，以static create(...)方法代替
4. 不使用属性存取器（setter/getter）
5. 不使用接口作为参数变量、成员变量的类型
6. 在接口的方法定义中，如果返回自身，则使用Object类型
7. 以功能“分类”决定包路径
8. 事件名称在所用之类中定义，注释中注明参数，在项目中充许重复定义
9. 不使用getXXX/setXXX方法
10. 不在变量前使用下划线
11. 不使用private关键字
12. 参数名称使用动名式
13. 将“标签”属性印在类名上，常见的类后缀有Object,Util，Controller，View，Service，Manager，Model，Module等。常用的前缀有I（代表是接口）等
14. 除了在外观模式类中，不使用不定参数
15. 不要使用组合模式实现接口，接口在SimpleMVC中只是一种规范
16. 使用外观模式，封装功能API，隐藏开发者无需了解的细节及接口

使用教程：
======================
*  [How to use SocketModule](https://github.com/simplemvc/simplemvc/wiki/SocketModule)