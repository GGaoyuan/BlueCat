[TOC]
-------

-------

-------

-------

-------


# InterView

## 编译流程

`Objective C/C/C++` 使用的编译器前端是**Clang**，Swift是**swift**，后端都是**LLVM**.

1. 源文件 
2. 预处理阶段：宏的展开，头文件的导入
3. 编译阶段 ①词法分析 ②语法分析（抽象语法树AST ） ③静态分析 (AST -> IR) ④生成中间代码IR
4. 生成汇编代码
5. 生成目标文件 （机器代码）mach-o 
6. 运行时链接 ： 链接需要的动态和静态库，生成可执行文件
7. 绑定：Bind 可执行文件 （针对不同架构，生成对应的可执行文件）



2、3为编译器前端处理



## 静态库 && 动态库

静态库：链接时，静态库会被完整地复制到可执行文件中，被多次使用就有多份冗余拷贝

系统动态库：链接时不复制，程序运行时由系统动态加载到内存，供程序调用，系统只加载一次，多个程序共用，节省内存

## 底层原理

### OC对象

一个NSObject对象占用多少内存？

```
系统分配了16个字节给NSObject对象（通过malloc_size函数获得） 但NSObject对象内部只使用了8个字节的空间（64bit环境下，可以通过class_getInstanceSize函数获得）
```

对象的isa指针指向哪里？

```
 instance对象的isa指向class对象 class对象的isa指向meta-class对象 meta-class对象的isa指向基类的meta-class对象
```

OC的类信息存放在哪里？ 

```
对象方法、属性、成员变量、协议信息，存放在class对象中 类方法，存放在meta-class对象中 成员变量的具体值，存放在instance对象
```

class_rw_t 与 class_ro_t 区别

```
class_rw_t结构体内有一个指向class_ro_t结构体的指针.
class_ro_t存放的是编译期间就确定的；而class_rw_t是在runtime时才确定，它会先将class_ro_t的内容拷贝过去，然后再将当前类的分类的这些属性、方法等拷贝到其中。所以可以说class_rw_t是class_ro_t的超集

当然实际访问类的方法、属性等也都是访问的class_rw_t中的内容
属性(property)存放在class_rw_t中，实例变量(ivar)存放在class_ro_t中。
```

msg_send 消息转发

```objective-c
分为三个阶段
1、动态方法解析 

  + (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(run)) {
        return NO;//返回 NO， 才会执行第二步
    }
    return [super resolveInstanceMethod:sel];
	}
	
2、快速转发 
  
  - (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(run)) {
//        return  [Dog new]; //替换其他消息接受者
        return nil; //返回nil 则会走到第3阶段，完全消息转发机制（慢速转发）
    }
    return  [super forwardingTargetForSelector:aSelector];
	}
  
3、完全消息转发
  
  3.1方法签名
  - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(run)) {
        Dog *dog = [Dog new];
        return [dog methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
	}
	3.2 消息转发
    - (void)forwardInvocation:(NSInvocation *)anInvocation {
    Dog *dog = [Dog new];
    if ([dog respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:dog];
    } else {
        [super forwardInvocation:anInvocation];
    }
	}
```

![](https://tva1.sinaimg.cn/large/008eGmZEly1gn3kd0skfkj30lq0cb3z6.jpg)

iOS用什么方式实现对一个对象的KVO？(KVO的本质是什么？) 

```
利用RuntimeAPI动态生成一个子类，并且让instance对象的isa指向这个全新的子类 当修改instance对象的属性时，会调用Foundation的_NSSetXXXValueAndNotify函数 willChangeValueForKey: 父类原来的setter didChangeValueForKey: 内部会触发监听器（Oberser）的监听方法( observeValueForKeyPath:ofObject:change:context:）
```

IMP、SEL、Method的区别

```
SEL是方法编号，也是方法名
IMP是函数实现指针，找IMP就是找函数实现的过程
Method就是具体的实现
SEL和IMP的关系就可以解释为：
SEL就相当于书本的⽬录标题
IMP就是书本的⻚码
Method就是具体页码对应的内容
SEL是在dyld加载镜像到内存时，通过_read_image方法加载到内存的表中了
```



## 其他原理

### 关联对象

```cpp
AssociationsManager类 管理了着一个锁还有一个全局的哈希键值对表.
// 初始化一个AssociationsManager实例对象的时候，会获取一个分配了内存的锁，并且调用它的assocations()方法来懒加载获取哈希表
  AssociationsHashMap
  	ObjectAssociationMap
  		ObjectAssociation
```



### 单例

@**synchronized**

```
使用@synchronized虽然解决了多线程的问题，但是并不完美。因为只有在single未创建时，我们加锁才是有必要的。如果single已经创建.这时候锁不仅没有好处，而且还会影响到程序执行的性能（多个线程执行@synchronized中的代码时，只有一个线程执行，其他线程需要等待）。

@synchronized是一把支持多线程递归的互斥锁

objc_sync_enter跟objc_sync_exit
```

**dispatch_once**

```
当onceToken= 0时，线程执行dispatch_once的block中代码 当onceToken= -1时，线程跳过dispatch_once的block中代码不执行 当onceToken为其他值时，线程被阻塞，等待onceToken值改变
```

### 通知 

[通知实现原理参考](https://www.jianshu.com/p/4a44b9a15fe9?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation)

```
发送通知所在的线程就是接收通知所在的线程
两张表 Named Table NotificationName作为表的key， nameless table 没有传入NotificationName wildcard

1、传入了NotificationName，则会以NotificationName为key去查找对应的Value，若找到value，则取出对应的value；若未找到对应的value，则新建一个table，然后将这个table以NotificationName为key添加到Named Table中。
2、如果没有传入NotificationName，直接根据对应的 object 为key去找对应的链表而已。
3、如果既没有传入NotificationName也没有传入object，则这个观察者会添加到wildcard链表中。

```



### copy

#### **copy 与 strong** 

使用 copy 的目的是为了让本对象的属性不受外界影响,使用 copy 无论给我传入是一个可变对象还是不可对象,我本身持有的就是一个不可变的副本.

如果我们使用 strong ,那么这个属性就有可能指向一个可变对象,如果这个可变对象在外部被修改了,那么会影响该属性.

```objective-c
		NSMutableString *string = [[NSMutableString alloc] initWithString:@"0"];
    
    NSString *copyString = [string mutableCopy];
    NSString *strongString = string;
    
    [string appendString:@"1"];
    
    NSLog(@"copyString = %@", copyString);
    NSLog(@"strongString = %@", strongString);
```



##### copy 与 mutableCopy

不可变对象 copy 指针拷贝  浅拷贝 仅此一种情况

|            |        copy         | mutableCopy |
| :--------: | :-----------------: | :---------: |
| 不可变对象 | 浅拷贝 （指针拷贝） |   深拷贝    |
|  可变对象  |       深拷贝        |   深拷贝    |





### weak

weak表其实是一个hash表，key 是所指对象的地址，value 是 weak 指针的地址数组，

sideTable是一个结构体，内部主要有引用计数表和弱引用表两个成员，内存存储的其实都是对象的地址、引用计数和weak变量的地址，而不是对象本身的数据





### alloc init new 

- 对象的开辟内存交由 `alloc` 方法封装
- `init` 只是一种工厂设计方案，为了方便子类重写：自定义实现，提供一些初始化就伴随的东西
- `new` 封装了 `alloc 和init`





### dealloc

1、**_objc_rootDealloc**

```c++
	if (fastpath(isa.nonpointer  &&   //无指针指向
             !isa.weakly_referenced  &&  //无弱引用
             !isa.has_assoc  &&  //无关联对象
             !isa.has_cxx_dtor  &&  //无cxx析构函数
             !isa.has_sidetable_rc)) //无散列表引用计数
{
    assert(!sidetable_present());
    free(this); //直接释放
} 
else {
    object_dispose((id)this);//则做其他操作
}
```
2、**dispose**

```
objc_destructInstance

​			是否有c++析构函数

​			是否存在关联对象

​			obj->clearDeallocating();

free
```



​	

### UIImage 解码

1、转成 cgImage 

2、创建上下文对象 contextRef (位图信息bitmapInfo)

3、将cgimage 画在 上下文上

4、得到新的 cgImage

5、uiimage *newImage = CGBitMapContextCreateImage( cgImage);



## Block

block的原理是什么 本质是什么

```
本质是一个 oc 对象， 内部也有一个 isa 指针
内部封装了 block 执行逻辑的函数
```

### Block 的本质 

**结构体对象**

```objective-c
int age = 20;
void (^block) (void) = ^ {
	NSLog(@"age is %d", age);
};
```

变量自动捕获👇  

```c++
struct __main_block_impl_0 {
	struct __block_impl impl; //impl 结构体见👇
	struct __main_block_desc_0* Desc;
	int age;// 自动变量捕获
}
```

```c++
struct __block_impl {
	void *isa;
	int Flags;
	int Reserved;
	void *FuncPtr; //指向 block 内部实现的函数地址 (见👇)
}
```

```c++
// 封装了 block 执行逻辑的函数
static void __main_block_func_0 () {
	//TODO
}
```

### 变量捕获

auto 值传递

static 指针传递

全局变量 不捕获 直接访问

局部变量需要捕获是因为需要`跨函数`访问

### Block 类型

`继承自NSBlock类型`

 ```
 globleBlock 没有访问 auto 变量 （访问 static 和 全局变量仍让是 globelBlock）

​ stackBlock 访问了 auto 变量 (MRC 下能打印出来, ARC下会自动调动 copy ---> mallocBlock)

​ stackBlock  ----> mallocBlock 调用了 copy （栈 --- > 堆上）  
 ```

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gpa566gvbtj31fc0togtn.jpg)



### __block的作用

```
__block 可解决 block 内部无法修改 auto 变量的问题 
```

```
编译器会将__block变量包装成一个对象 __Block_byref_xxx_0 结构体
```

基本数据类型 `int age = 0;` 编译器会将 age 包装成 `__Block_byref_age_0` 结构体



![](https://tva1.sinaimg.cn/large/008eGmZEly1gng930adqfj30ec06c0tl.jpg)

```
1.__main_block_impl_0 结构体内持有  __Block_byref_age_0
2.__Block_byref_age_0 内部持有 __forwarding 指针指向自己
```



<img src="https://tva1.sinaimg.cn/large/008eGmZEly1gng939naeuj30mk07676r.jpg" style="zoom:67%;" />



<img src="https://tva1.sinaimg.cn/large/008eGmZEly1gng92mq03kj30li09smyv.jpg" style="zoom: 67%;" />

### Block 内存管理

当 block 被 copy 到堆上时，会调用block内部的 copy 函数，copy 函数会调用 `__Block_object_assign`

## 

## Runtime

## Runloop

https://blog.csdn.net/u014600626/article/details/50864172 

### 面试题

#### Runloop 内部实现逻辑

#### Runloop 和线程的关系

```
一个运行着的程序就是一个进程或者一个任务。每个进程至少有一个线程，线程就是程序的执行流。创建好一个进程的同时，一个线程便同时开始运行，也就是主线程。每个进程有自己独立的虚拟内存空间，线程之间共用进程的内存空间。有些线程执行的任务是一条直线，起点到终点；在 iOS 中，圆型的线程就是通过run loop不停的循环实现的。
1.每个线程包括主线程都有与之对应的 runloop 对象，线程和 runloop 对象是一一对应的；
2.Runloop 保存在一个全局字典中，线程为key, runloop为value CFDictionaryGetValue
3.主线程会默认开启 runloop , 子线程默认不会开启，需要手动开启
4.runloop 在第一次获取时创建，在线程结束时销毁
```

#### timer 和 Runloop 的关系

#### Runloop 是怎么相应用户操作的，具体操作流程是什么

```
首先由Source1捕捉系统事件，然后包装成eventqueue，传递给Source0处理触摸事件
```

#### Runloop的几种状态

```
Entry ： 
beforeTimers ： 
beforeSources
beforeWaiting
afterWaiting
exit
```

#### Runloop 原理

1. 通知 observers：RunLoop 要开始进入 loop 了，(<u>kCFRunLoopEntry</u>) 

2. 开启一个 do while 来保活线程，通知 observers ：

   - runloop 会触发 timers， source0 回调，(<u>kCFRunLoopBeforeTimers</u>  <u>kCFRunLoopBeforeSources</u>)
   - 接着执行加入的 block
   - 接下来触发 Source0 回调，如果有 Source1是 ready 状态的话，就会跳到 handle_msg 去处理消息，

3. 通知 Observers：RunLoop 的线程将进入休眠（sleep）状态  （<u>kCFRunLoopBeforeWaiting</u>）

4. 进入休眠后，会等待 mach_port的消息，以再次唤醒；只有在下面四个事件 

   - 基于 port 的 source 事件
   - timer 时间到
   - runloop 超时
   - 被调用者唤醒

5. 唤醒时，通知 Observer: Runloop 的线程刚刚被唤醒了 （<u>kCFRunLoopAfterWaiting</u>）

6. 被唤醒后，开始处理消息

   - 如果是 Timer 时间到的话，就触发 Timer 的回调；

   - 如果是 dispatch 的话，就执行 block；

   - 如果是 source1 事件的话，就处理这个事件。

     消息执行完后，就执行到loop里的block

7. 根据当前runloop的状态来判断是否需要走下一个 loop。当被外部强制停止或loop 超时，就不继续下一个loop了，否则继续走下一个loop

#### Runloop 的mode作用是什么

```
mode作用是用来隔离, 将不同组的Source0、Source1、timer、Observer 隔离开来，互不影响
主要有 
defaultMode : app的默认 mode，通常主线程在这个mode下运行
UITrackingMode : 界面追踪 mode, 用于scrollview追踪触摸滑动，保证界面滑动时不受其他 Mode 影响
```

#### Runloop 在实际开发中的作用

控制线程生命周期（线程保活）

检测应用卡顿

性能优化

#### Runloop 休眠的实现原理

用户态和内核态之间的相互切换

mach_msg()

用户态 ----> 内核态 （等待消息）

内核态 ---->用户态 （处理消息）

```
内核态：
等待消息
没有消息就让线程休眠
有消息就唤醒线程
```

### other

`viewDidLoad`和`viewWillAppear`在同一个RunLoop循环中

UIApplicationMain 启动了 runloop

## AutoReleasePool



[详解autoreleasepool]: http://www.cocoachina.com/cms/wap.php?action=article&amp;id=87115

#### AutoreleasePool的实现原理

@autoreleasePool  =   **__AtAutoreleasePool**   __autoreleasePool

```
__AtAutoreleasePool 结构体
```



AutoreleasePool 是 oc 的一种内存回收机制，正常情况下变量在超出作用域的时候 release，但是如果将变量加入到 pool 中，那么release 将延迟执行

```
AutoreleasePool 并没有单独的结构，而是由若干个 AutoreleasePoolPage 以**双向链表**形式组成

1. PAGE_MAX_SIZE ：4KB，虚拟内存每个扇区的大小，内存对齐
2. 内部 thread ，page 当前所在的线程，AutoreleasePool是按线程一一对应的
3. 本身的成员变量占用56字节，剩下的内存存储了调用 autorelease 的变量的对象的地址，同时将一个哨兵插入page中
4. pool_boundry 哨兵标记，哨兵其实就是一个空地址，用来区分每一个page 的边界
5. 当一个Page被占满后，会新建一个page，并插入哨兵标记
```

单个自动释放池的执行过程就是`objc_autoreleasePoolPush()` —> `[object autorelease]` —> `objc_autoreleasePoolPop(void *)`

具体实现如下：

```c++
void *objc_autoreleasePoolPush(void) {
    return AutoreleasePoolPage::push();
}

void objc_autoreleasePoolPop(void *ctxt) {
    AutoreleasePoolPage::pop(ctxt);
}
```

内部实际上是对 AutoreleasePoolPage 的调用

##### objc_autoreleasePoolPush

每当自动释放池调用 objc_autoreleasePoolPush 时，都会把边界对象放进栈顶，然后返回边界对象，用于释放。

`AutoreleasePoolPage::push();`  调用👇

```c++
static inline void *push() {
   return autoreleaseFast(POOL_BOUNDARY);
}
```

`autoreleaseFast`👇

```c++
static inline id *autoreleaseFast(id obj)
{
   AutoreleasePoolPage *page = hotPage();
   if (page && !page->full()) {
       return page->add(obj);
   } else if (page) {
       return autoreleaseFullPage(obj, page);
   } else {
       return autoreleaseNoPage(obj);
   }
}
```

👆上述方法分三种情况选择不同的代码执行：

```
- 有 hotPage 并且当前 page 不满，调用 page->add(obj) 方法将对象添加至 AutoreleasePoolPage 的栈中
- 有 hotPage 并且当前 page 已满，调用 autoreleaseFullPage 初始化一个新的页，调用 page->add(obj) 方法将对象添加至 AutoreleasePoolPage 的栈中
- 无 hotPage，调用 autoreleaseNoPage 创建一个 hotPage，调用 page->add(obj) 方法将对象添加至 AutoreleasePoolPage 的栈中

最后的都会调用 page->add(obj) 将对象添加到自动释放池中。 hotPage 可以理解为当前正在使用的 AutoreleasePoolPage。
```



#### AutoreleasePoolPage

```objective-c
是以栈的形式存在，并且内部对象通过进栈、出栈对应着 objc_autoreleasePoolPush 和 objc_autoreleasePoolPop
  
当我们对一个对象发送一条 autorelease 消息时，实际上是将这个对象地址加入到 autoreleasePoolPage 的栈顶 next 指针的指向的位置
```



## 	Runloop 与 Autorelease

iOS 在主线程注册了两个 observer

__第一个observer __

监听了 kCFRunloopEntry, 会调用 objc_autoreleasePool_push()

__第二个 observer__

监听了 kCFRunloopBeforeWaiting 会调用 objc_autoreleasePool_pop() 、objc_autoreleasePool_push()

监听了 kCFRunloopExit 事件，会调用 objc_autoreleasePool_pop()

## 多线程

### 线程与队列

同步、异步 Dispatch_async 和 dispatch_sync 决定了是否开启新的线程

并发、串行 concurrent 、serial 队列的类型决定了任务的执行方式

### 死锁

使用 sync 向**当前串行队列**中添加任务，会卡住当前的串行队列（产生死锁）

### 锁

#### OSSpinLock （自旋锁）

High-level lock

自旋锁不再安全 等待锁的线程会处于**忙等**状态，一直占用着CPU的资源

可能会出现优先级反转的问题

#### os_unfair_lock

从底层调用来看，等待 os_unfair_lock 锁的线程处于**休眠**状态，并非忙等

#### pthread_mutex （互斥锁）

需要销毁

##### 互斥锁 normal  

##### 递归锁 

![](https://tva1.sinaimg.cn/large/e6c9d24ely1go3mu4x8hnj20ys0aq0wk.jpg)

##### 条件锁

```objective-c
pthread_cond_t

pthread_cond_wait

pthread_cond_signal
```

#### NSLock

对 pthread_mutex 默认封装

#### NSRecursiveLock

#### NSCondition

对 NSConditionLock 和 NSCondition的封装

wait 

signal

#### SerialQueue

gcd 串行队列

#### Semphore



#### @synthronized

互斥递归锁

```
@synthronized(obj)  obj 传递进去 syncData（hashmap）一个 obj 对应一把锁 （pmutext_lock） 
obj对应的递归锁，然后进行加锁、解锁操作

进入SyncData的定义，是一个结构体，主要用来表示一个线程data，类似于链表结构，有next指向，且封装了recursive_mutex_t属性，可以确认@synchronized确实是一个递归互斥锁
```

#### 自旋锁和互斥锁区别

```
自旋锁 （不休眠）
预计线程等待锁的时间很短
CPU资源不紧张

互斥锁
预计等待锁的时间较长
有IO操作
CPU资源紧张
```

### 读写安全

atomic 读写加锁 但是  release 不加锁

### 多读单写

pthread_rwlock : 读写锁

```
等待的锁 会进入休眠
```

<img src="https://tva1.sinaimg.cn/large/e6c9d24ely1go73qnpv6tj20oi06uq4g.jpg" style="zoom:67%;" />

dispatch_barrier_async：异步栅栏函数

```
queue 必须是自己手动创建的并发队列
```

<img src="https://tva1.sinaimg.cn/large/e6c9d24ely1go7o8nzh8yj21hq0ioalx.jpg" style="zoom:40%;" />



### 定时器

NSProxy 没有 init 方法

如果调用 nsproxy 发送消息，他会直接调用



## 内存布局

### 保留区 

- 预留给系统处理nil等 
- **`0x00400000`**开始

### 代码段 

- 编译之后的代码

### 数据段 

- 字符串变量 
- 全局变量 
- 静态变量

### 堆

- alloc

``` 
访问堆区内存时，一般是先通过对象读取到对象所在的栈区的指针地址，然后通过指针地址访问堆区
```

### 栈

- 局部变量
- 函数参数

```
内存从高到底分配 内存是连续的
```

### 内核区

- 系统用来进行内核处理操作的区域

**具体内存布局👇**

<img src="https://tva1.sinaimg.cn/large/008eGmZEly1go88t2nr4rj31ig0totvh.jpg" style="zoom:67%;" />



## 内存管理方案

### ARC

### MRC



### Tagged Pointer

- 小对象是不会进行retain和release操作的   因此不用担心过度释放问题

- 专门用来`处理小对象`，例如NSNumber、NSDate、小NSString等

- `NSTaggedPointerString类型`，存在`常量区`

- 1.`NSTaggedPointerString`：标签指针，是苹果在`64位`环境下对`NSString、NSNumber`等对象做的`优化`。对于NSString对象来说
- - 当`字符串是由数字、英文字母组合且长度小于等于9`时，会自动成为`NSTaggedPointerString`类型，存储在`常量区`
  - 当有`中文或者其他特殊符号`时，会直接成为`__NSCFString`类型，存储在`堆区`
- 2.`__NSCFString`：是在`运行时`创建的`NSString子类`，创建后`引用计数会加1`，`存储在堆上`
- 3.`__NSCFConstantString`：`字符串常量`，是一种`编译时常量`，`retainCount值很大`，对其操作，`不会引起引用计数变化，存储在字符串常量区`



```
从64bit开始，iOS引入了Tagged Pointer技术，用于优化NSNumber、NSDate、NSString等小对象的存储

在没有使用Tagged Pointer之前， NSNumber等对象需要动态分配内存、维护引用计数等，NSNumber指针存储的是堆中NSNumber对象的地址值

使用Tagged Pointer之后，NSNumber指针里面存储的数据变成了：Tag + Data，也就是将数据直接存储在了指针中

当指针不够存储数据时，才会使用动态分配内存的方式来存储数据

objc_msgSend能识别Tagged Pointer，比如NSNumber的intValue方法，直接从指针提取数据，节省了以前的调用开销

如何判断一个指针是否为Tagged Pointer？
iOS平台，最高有效位是1（第64bit）  16进制转为2进制

isTaggerPointer 

pointer & 1

Mac平台，最低有效位是1
```



DEMO



<img src="https://tva1.sinaimg.cn/large/008eGmZEly1goge7ptb12j30n10icjua.jpg" style="zoom:67%;" />

崩溃原因是`多条线程`对`同一个对象`进行`释放`，导致`对象过度释放`，所以才会崩溃。

### nonpointer_isa

- 非指针类型的isa，主要是用来`优化64位地址`

### SideTables

- 散列表，在散列表中主要有`两个表`，分别是`引用计数表`、`弱引用表`

## 组件化

## 组件化通信

### ？Beehive

### ？Bifrost

### ？Aspect

### ?  fishhook

### 

## ？设计模式

## ？插件化

Charles 是如何抓包的

## 算法

### 链表

### 二叉树

### ？二分查找

## 性能优化

### 卡顿监测

#### YYFPSLabel

![](https://tva1.sinaimg.cn/large/008eGmZEly1goi1oedz0oj31ca0ridu5.jpg)



#### Runloop 监测

微信卡顿三方`matrix`

创建一个 **CFRunLoopObserverContext** 观察者，将创建好的观察者 observer 添加到主线程runloop 的 common 模式下观察。然后创建一个持续的子线程专门用来监控主线程的runloop 状态。

```objective-c
CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities,YES,0,&runLoopObserverCallBack,&context);
```

一旦发现进入休眠前的 beforeSources 状态，或者唤醒后的状态 afterWaiting ，在设置的时间（阈值）内一直没有变化，即可判定为卡顿

### 离屏渲染

定义：在当前屏幕缓冲区外开辟一个缓冲区进行渲染操作

**离屏渲染消耗性能的原因**

```
1、需要创建新的缓冲区
2、离屏渲染的过程中，需要多次切换上下文环境，先是从当前屏幕切换到离屏；等到离屏渲染完毕后，将离屏缓冲区的渲染结果显示到屏幕上，又需要将上下文环境从离屏切换到当前屏幕
```

离屏渲染产生的原因

```
1、光栅化 layer.shouldRasterize = YES;
2、遮罩 layer.mask
3、圆角 可使用 coreGraphic 绘制圆角解决
4、阴影 layer.shadowxxx  如果设置了 path 就不会触发离屏渲染
```

### 渲染原理

1、CPU 

**计算要显示的内容，包括以下几个方面：**👇

- 视图创建
- 布局计算
- 视图绘制
- 图像解码

```
 当 runloop 在 beforewaiting 和 exit 时通知注册的监听，然后对图层进行打包。然后将打包数据发给专门负责渲染的独立进程 render server
```



2、Render server

- 图层树：反序列化后得到图层树
- 渲染树：图层树转化后得到渲染树
- GPU：渲染树通过 openGL接口提供给GPU，六大阶段

### 界面优化

##### CPU方面

- tableview 提前计算cell 高度
- 图片预解码 sdwebimage 创建上下文环境（CGBitmapContext），从 bitmap 直接得到图片
- 文本的处理 coretext
- 尽量避免使用透明 view 

##### GPU 方面

- 尽量`减少在短时间内大量图片的显示`
- 图片纹理尺寸4096 *4096 （当图片超过这个尺寸时，会先由`CPU`进行预处理，然后再提交给`GPU`处理，导致额外`CPU`资源消耗）
- 避免离屏渲染
- 视图层级



### 冷启动

1. dyld
2. 动态库加载
3. runtime
4. 加载分类
5. main

## 源码

AFN

https://juejin.cn/post/6939068933685116965

SD



## 面试

#### Flutter

1. flutter 是怎么渲染UI的
2. Flutter 的视图结构的抽象分为三部分

- widget   
- element 
- renderObject

```
在渲染阶段，控件树（widget）会转换成对应的渲染对象（RenderObject）树，在 Rendering 层进行布局和绘制
```

2.Relayout Boundary

```
为了防止因子节点发生变化而导致的整个控件树重绘，Flutter 加入了一个机制 relayout boundry
flutter使用边界标记需要重新绘制和重新布局的节点，这样就可以避免其他节点被污染或者触发重建。
就是控件大小不会影响其他控件时，就没必要重新布局整个控件树。有了这个机制后，无论子树发生什么样的变化，处理范围都只在子树上。
```

3.布局的计算

在布局时 Flutter 深度优先遍历**渲染对象树**。数据流的传递方式是从上到下传递约束，从下到上传递大小。也就是说，父节点会将自己的约束传递给子节点，子节点根据接收到的约束来计算自己的大小，然后将自己的尺寸返回给父节点。





### 什么是隐式动画

显式动画是指用户自己通过beginAnimations:context:和commitAnimations创建的动画。CABasicAnimation

隐式动画是指通过UIView的animateWithDuration:animations:方法创建的动画。

隐式动画是ios4之后引入sdk的，之前只有显式动画。从官方的介绍来看，两者并没有什么差别，甚至苹果还推荐使用隐式动画，但是这里面有一个问题，就是使用隐式动画后，View会暂时不能接收用户的触摸、滑动等手势。这就造成了当一个列表滚动时，如果对其中的view使用了隐式动画，就会感觉滚动无法主动停止下来，必须等动画结束了才能停止。

关键帧动画 CAKeyframeAnimation



### ?Tableview 复用原理



20210314 字节一面

1. isEqual &&  hash

   参考 https://www.jianshu.com/p/915356e280fc

   ```
   ==运算符 与 isEqual
   ==运算符只是简单地判断是否是同一个对象, 而isEqual方法可以判断对象是否相同
   ```

   > hash方法只在对象被添加至NSSet和设置为NSDictionary的key时会调用

2. 成员变量和 setter 方法

3. hook 实例 例子： KVO 

4. id  instancetype 

   1. id 在编译时不能判断对象的真实类型  instancetype 可以判断
   2. 如果init方法的返回值是instancetype,那么将返回值赋值给一个其它的对象会报一个警告
   3. id可以用来定义变量, 可以作为返回值, 可以作为形参；instancetype只能用于作为返回值

5. 内存布局

6. tcp 和 UDP 

   1. 基于连接与无连接；
   2. 对系统资源的要求（TCP较多，UDP少）；
   3. UDP程序结构较简单；
   4. 流模式与数据报模式 ；
   5. TCP保证数据正确性，UDP可能丢包，TCP保证数据顺序，UDP不保证。

7. mvc 和 mvvm 

8. git  rebase  git merge 区别

   1. git pull  = git fetch + git merge 
   2. git merge 与 git rebase 结果上没有本质区别 只是生成的节点不同 （rebase 一条线）

9. 算法：全排列