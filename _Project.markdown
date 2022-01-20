[toc]

### 性能优化：
#### 业务优化
电子书优化：
- 逐词高亮
- 绘图
- 缓存（只有内存，磁盘太慢太慢了）
- 异步渲染
#### 内存优化：
- 在需要New大量对象的时候使用AutoreleasePool
- 内存泄漏
- 有一年WWDC说的DirtyMemory，还有ClearnMemory，忘记了
- DrawRect
- 图片的分辨率
- 少用单例，多用局部变量
- imageName
#### TableView优化
**CoreGraphic是CPU渲染，OpenGL是GPU渲染**
卡顿掉帧的表现:
- FPS降低
- CPU占用率很高
- 主线程Runloop执行了很久
卡顿原因：
- CPU计算量过大（图片绘制与解码，各种计算）
- 死锁（崩溃）
- 写入大量数据（绘本缓存）
- 大量的UI绘制，图文混排
- 离屏渲染（GPU重开缓冲区，上下文切换）
- GPU的视图的混合

优化方案：
- 离屏渲染数量才是大杀器
- cornerRadio+Mask换成贝塞尔曲线画遮罩
- 大量计算放子线程，但是注意子线程的膨胀
  - 计算缓存高度，预排版，图片解码
  - 这里可以利用Prefetching
- 不用相应事件的可以用CALayer替换UIView, CATextLayer替换UILabel
- CALayer异步渲染
- Runloop的performDelay（后者监听Runloop，吧滑动的时候的那些渲染任务都搜集起来，然后在快要Beforewaiting的时候，再加载，按需加载）
- 减少视图层级

https://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/
#### 网络优化
对传输的数据进行压缩，减少传输的数据
使用缓存手段减少请求的发起次数（本地缓存+modify）
使用策略来减少请求的发起次数，比如在上一个请求未着地之前，不进行新的请求
避免网络抖动，提供重发机制（失败容灾）
优化DNS解析和缓存（HTTPDNS）
#### 图片优化

*************
#### 图像显示原理
CPU进行计算frame，绘制，解码，生成位图
GPU进行渲染，将结果放到缓冲区
显示
##### 卡顿掉帧的表现
FPS降低
CPU占用率很高
主线程Runloop执行了很久


Cocos:
内存泄漏
杀死进程


SD/YYImage预解码问题

