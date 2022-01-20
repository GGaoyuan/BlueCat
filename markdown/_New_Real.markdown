[toc]
##### GCD实现多读单写
```
@implementation KCPerson
- (instancetype)init
{
    if (self = [super init]) {
       _concurrentQueue = dispatch_queue_create("com.kc_person.syncQueue", DISPATCH_QUEUE_CONCURRENT);
       _dic = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)kc_setSafeObject:(id)object forKey:(NSString *)key{
    key = [key copy];
    dispatch_barrier_async(_concurrentQueue, ^{
       [_dic setObject:object key:key];
    });
}

- (id)kc_safeObjectForKey：:(NSString *)key{
    __block NSString *temp;
    dispatch_sync(_concurrentQueue, ^{
        temp =[_dic objectForKey：key];
    });
    return temp;
}
@end
```
首先我们要维系一个GCD 队列，最好不用全局队列，毕竟大家都知道全局队列遇到栅栏函数是有坑点的，这里就不分析了！

因为考虑性能 死锁 堵塞的因素不考虑串行队列，用的是自定义的并发队列！_concurrentQueue = dispatch_queue_create("com.kc_person.syncQueue", DISPATCH_QUEUE_CONCURRENT);

首先我们来看看读操作:kc_safeObjectForKey 我们考虑到多线程影响是不能用异步函数的！说明：

线程2 获取：name 线程3 获取 age
如果因为异步并发，导致混乱 本来读的是name 结果读到了age
我们允许多个任务同时进去! 但是读操作需要同步返回，所以我们选择:同步函数 （读读并发）
我们再来看看写操作，在写操作的时候对key进行了copy, 关于此处的解释，插入一段来自参考文献的引用:

函数调用者可以自由传递一个NSMutableString的key，并且能够在函数返回后修改它。因此我们必须对传入的字符串使用copy操作以确保函数能够正确地工作。如果传入的字符串不是可变的（也就是正常的NSString类型），调用copy基本上是个空操作。
这里我们选择 dispatch_barrier_async, 为什么是栅栏函数而不是异步函数或者同步函数，下面分析：

栅栏函数任务：之前所有的任务执行完毕，并且在它后面的任务开始之前，期间不会有其他的任务执行，这样比较好的促使 写操作一个接一个写 （写写互斥），不会乱！

为什么不是异步函数？应该很容易分析，毕竟会产生混乱！

为什么不用同步函数？如果读写都操作了，那么用同步函数，就有可能存在：我写需要等待读操作回来才能执行，显然这里是不合理！

##### 什么是中间人攻击？如何避免？
中间人攻击就是截获到客户端的请求以及服务器的响应，比如Charles抓取HTTPS的包就属于中间人攻击。
避免的方式：客户端可以预埋证书在本地，然后进行证书的比较是否是匹配的

##### App网络层有哪些优化策略
优化DNS解析和缓存
对传输的数据进行压缩，减少传输的数据
使用缓存手段减少请求的发起次数
使用策略来减少请求的发起次数，比如在上一个请求未着地之前，不进行新的请求
避免网络抖动，提供重发机制

##### isKindOf和isMenberOf
```
BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
BOOL res3 = [(id)[TestObject class] isKindOfClass:[TestObject class]];
BOOL res4 = [(id)[TestObject class] isMemberOfClass:[TestObject class]];
```
除了第一个是YES，其他三个都是NO。
**isKindOfClass:**
returns YES if the receiver is an instance of the specified class or an instance of any class that inherits from the specified class.
方法调用者是传入的类的实例对象，或者调用者是传入类的继承者链中的类的实例对象，则返回YES。
**isMemberOfClass:**
returns YES if the receiver is an instance of the specified class.
方法调用者必须是传入的类的实例对象才返回YES。

##### 线程池原理
使用线程执行任务的时候，需要到线程池中去取线程进行任务分配。首先判断线程池大小是否小于核心线程池大小，
如果当前线程池大小小于的话，创建新的线程执行任务；
如果当前线程池大小大于了核心线程池大小，然后开始判断工作队列是否已满，如果没满，将任务提交到工作队列。
如果工作队列已满，判断线程池的线程是否都在工作，如果有空闲线程没有在工作，就交给它去执行任务。
如果线程池中的线程都在工作，那么就交给饱和策略去执行。
饱和策略分为下面四种：
AbortPolicy 直接抛出RejectedExecutionExeception 异常来阻止系统正常运行；
CallerRunsPolicy 将任务回退到调用者；
DisOldestPolicy 丢掉等待最久的任务‘；
DisCardPolicy 直接丢弃任务

##### WebSocket与TCP Socket的区别
Socket是抽象层，并不是一个协议，是为了方便使用TCP或UDP而抽象出来的一层，是位于应用层和传输层(TCP/UDP)之间的一组接口。

WebSocket和HTTP一样，都是应用层协议，是基于TCP 连接实现的双向通信协议，替代HTTP轮询的一种技术方案。是全双工通信协议，HTTP是单向的，注意WebSocket和Socket是完全不同的两个概念。

##### 事件传递和响应机制
在iOS中只有继承了UIResponder的对象才能接受并处理事件。

事件传递：事件的传递是从上到下（父控件到子控件）

产生触摸事件A后，触摸事件会被添加到由UIApplication管理的事件队列中(首先接收到事件的是UIApplication)。

UIApplication会从事件队列中取出最前面的事件(此处假设为触摸事件A)，将事件对象由上往下传递(UIApplication-keyWindow-父控件-子控件)，查找最合适的控件处理事件

只要事件传递给控件，就会调用自身的hitTest:withEvent:方法，寻找能够响应事件最合适的view(其内部会调用pointInside:withEvent:判断触摸点是否在自己身上)。

##### 能否向编译后得到的类中增加实例变量？能否向运行时创建的类中添加实例变量？为什么？
1.不能向编译后得到的类中增加实例变量。

2.可以向运行时创建的类中添加实例变量。

3.因为编译后的类已经注册在 runtime 中，类结构体中的 objc_ivar_list实例变量的链表和 instance_size 实例变量的内存大小已经确定，同时runtime会调用 class_setIvarLayout或class_setWeakIvarLayout来处理 strong、weak引用，所以不能向存在的类中添加实例变量

##### Block的内存模型
全局Block(_NSConcreteGlobalBlock)：当我们声明一个block时，如果这个block没有捕获外部的变量，那么这个block就位于全局区(已初始化数据(.data)区)。

栈Block(_NSConcreteStackBlock)：

1). ARC环境下，当我们声明并且定义了一个block，系统默认使用__strong修饰符，如果该Block捕获了外部变量，实质上是从__NSStackBlock__转变到__NSMallocBlock__的过程，只不过是系统帮我们完成了copy操作，将栈区的block迁移到堆区，延长了Block的生命周期。对于栈block而言，变量作用域结束，空间被回收。

2). ARC的环境下，如果我们在声明一个block的时候，使用了__weak或者__unsafe__unretained的修饰符，那么系统就不会做copy的操作，也就不会将其迁移到堆区。

堆Block(_NSConcreteMallocBlock)：

1). 在MRC环境下，我们需要手动调用copy方法才可以将block迁移到堆区

2). 而在ARC环境下，__strong修饰的（默认）block捕获了外部变量就会位于堆区，NSMallocBlock支持retain、release，会对其引用计数＋1或 -1。

只有局部变量 - 和定义的属性 才会拷贝到堆区