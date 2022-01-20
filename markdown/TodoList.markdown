二进制重排

刷算法题
整理笔记
看一看大师班24期讲解

异步绘制
DP算法
埋点
调用栈收集
卡顿监控
App起死回生（崩溃拦截）
内存泄漏监控

Flag
性能优化-》包含了异步渲染，缓存设计
日志搜集-》崩溃（段国林的日志搜集），调用栈收集，卡顿监控，起死回生
埋点部分

东哥说的参数是json可能会带来攻击

卡顿监控的observer用哪个

界面卡顿是由哪些原因导致的
死锁：主线程拿到锁 A，需要获得锁 B，而同时某个子线程拿了锁 B，需要锁 A，这样相互等待就死锁了。
抢锁：主线程需要访问 DB，而此时某个子线程往 DB 插入大量数据。通常抢锁的体验是偶尔卡一阵子，过会就恢复了。
主线程大量 IO：主线程为了方便直接写入大量数据，会导致界面卡顿。
主线程大量计算：算法不合理，导致主线程某个函数占用大量 CPU。
大量的 UI 绘制：复杂的 UI、图文混排等，带来大量的 UI 绘制。

判断标准

怎么判断主线程是不是发生了卡顿？一般来说，用户感受得到的卡顿大概有三个特征：

FPS 降低
CPU 占用率很高
主线程 Runloop 执行了很久

1、oc中的timer有哪几种，哪种timer是精确的
2、NSTimer为什么不精确


4、说说autoreleasepool的实现原理，autorelease_pool_page结构体中的哨兵指真是什么
5、app启动优化做过吗，有哪些需要优化的地方
6、用machoview打开编译好的二进制文件，+load方法在二进制文件的哪个数据段
7、程序热启动做过哪些优化
8、drawRect方法为什么会使内存升高
9、socket长链接具体怎么实现的，为什么要维持心跳包，没有心跳包为什么链接会断开
10、https的秘钥交换加密过程，htts能防止dns攻击吗，为什么不能，dns解析是在哪一层实现的
11、http三次握手过程描述一下
12、下面的代码执行结果是什么
- (void)dealloc {
    __weak __typeof(self) weakSelf = self;
    NSLog(@"%p", weakSelf);
}
3、对app做过哪些优化
算法：判断一个二叉树是否为平衡二叉树，限定语言C++，Java，PYTHON


二叉树翻转，自己简单撸了一遍，这次碰到的是平衡二叉树

drawRect的事---》内存监控

动画
帧动画
动画组
隐式动画



9月
web和native怎么共享cookie
有动态库打包么，你看过xx ipa(前司app)的结构么
内联函数和普通函数的区别
怎么hook一个C函数
多线程容易出现的问题，怎么解决
死锁产生的条件以及对应的解决方案
category的实现原理
https://www.cnblogs.com/Julday/p/13230427.html

CALayer和UIView的关系





总结一下JL中的亮点可能引出的问题
Cocci总结的MST
https://juejin.im/post/6844903955424608263#heading-1
MSTURL：
https://www.jianshu.com/p/1940ebc0cade
https://www.jianshu.com/p/67021f783410
https://juejin.im/post/6844903955424608263
https://www.jianshu.com/p/473ee4917899
https://www.jianshu.com/p/2f5a1a4a52cf
小专栏