[toc]
## iOS
### Objective-C
##### @synthesize和@dynamic
@synthesize的语义是如果你没有手动实现setter方法和getter方法，那么编译器会自动为你加上这两个方法
@dynamic告诉编译器：属性的setter与getter方法由用户自己实现，不自动生成（当然对于readonly的属性只需提供getter即可）
假如一个属性被声明为@dynamic var，然后你没有提供@setter方法和@getter方法，编译的时候没问题，但是当程序运行到instance.var = someVar，由于缺setter方法会导致程序崩溃；或者当运行到 someVar = instance.var时，由于缺getter方法同样会导致崩溃。编译时没问题，运行时才执行相应的方法，这就是所谓的动态绑定
##### union
和结构体类似，但是结构体是每一个变量一片内存
Union允许装入该“联合”所定义的任何一种数据，这些数据共享同一段内存，以达到节省空间的目的。union变量所占用的内存长度等于最长的成员的内存长度
##### isKindOfClass 与 isMemberOfClass

##### iOS开发中的加密方式
对称加密： DES(不安全)、3DES、AES
非对称加密:RSA加密
哈希算法加密：MD5加密、.SHA加密、HMAC加密
##### Objective-C如何实现多继承
协议+组合
##### 一个NSObject对象占用多少内存
32位下，只使用了4字节
64位下一个NSObject对象都会分配16byte(字节)的内存空间。
但是实际会只使用了8字节
系统是按16的倍数来分配对象的内存大小的，比如一个对象占用40字节，系统会分配给他48字节
iOS近期的系统中，基于A7和A8处理器的系统，物理内存按照4KB分页，虚拟内存按照16KB分页。基于A9处理器的系统，物理和虚拟内存都是以16KB进行分页。系统将内存页分为三种状态。
##### OC中的timer有哪几种，哪种timer是精确的
![](/images/timer01.png)
CADisplayLink>Dispatch>NSTimer
CADisplayLink：和iOS界面刷新效率同步执行，可以在1s内执行60次，执行效率最高。这里注意一下，刷新频率和是否卡顿并没有关系，毕竟CADisplayLink还能用来做简单的帧率检测
DispatchTimer：GCD的timer是根据系统内核来的，比较准
NSTimer：和CADisplayLink都是依赖于Runloop，但是他是最不准的。一旦遇到runloop\mainThread处理任务阻塞了，那么可能某一次runloop的回调就会放弃，所以不是很准确
##### iOS一个对象占用多少空间
分别调用class_getInstanceSize和malloc_size方法
```
@interface Person : NSObject {
    int _age;
    int _number;
    int _sex;
}
@end
struct Person_IMPL {
    struct NSObject_IMPL NSObject_IVARS;
    int _age;
    int _number;
    int _sex;
};
@end
```
1个结构体指针 (8字节)
1个 int _age (4字节)
1个 int _number (4字节)
1个 int _sex (4字节)
8 + 4 + 4 + 4 = 20 字节
根据结构体内存对齐的原则，结构体实际需要的内存大小应该是8的整数倍，也就是24个字节
但是系统给对象实际分配的内存大小是32字节
具体原因是Apple系统中的malloc函数分配内存空间时，内存是根据一个bucket的大小来分配的. bucket的大小是16，32，48，64，80 ...，可以看出系统是按16的倍数来分配对象的内存大小的
##### 字典注意事项：setvalue和setobject的区别
setObject:ForKey：是NSMutableDictionary特有的。
setValue:ForKey：是KVC的主要方法。
setobject中的key和value可以为nil以外的任何对象。
setValue中的key只能为字符串，value可以为nil也可以为空对象[NSNull null]以及全部对象
******************************************************************************
### Swift
##### 内联函数和普通函数的区别
内联函数是指用inline关键字修饰的函数。内联函数不是在调用时发生控制转移，而是在编译时将函数体嵌入在每一个调用处。编译时，类似宏替换，使用函数体替换调用处的函数名。
内联函数类似一个宏，不是真正的函数
inline函数要注意
1、你可以使用inline函数完全取代表达式形式的宏定义。
2、内联函数一般只会用在函数内容非常简单的时候，这是因为，内联函数的代码会在任何调用它的地方展开，如果函数太复杂，代码膨胀带来的恶果很可能会大于效率的提高带来的益处。
3、在内联函数内不允许用循环语句和递归。如果内联函数有这些语句，则编译将该函数视同普通函数那样产生函数调用代码。内联函数只适合于只有1～5行的小函数。对一个含有许多语句的大函数，函数调用和返回的开销相对来说微不足道，所以也没有必要用内联函数实现

##### 闭包和逃逸闭包
？？？
##### unowned和weak
？？？
##### 深拷贝和浅拷贝
？？？

******************************************************************************
### 内存 && Runtime && Runloop
#### 内存与属性
##### iOS中内存泄漏的场景
NSTimer
Block
代理
通知
try/catch:出现异常用@throw可能会出现内存泄漏的情况，通常不是那种致命错误，用返回nil或者NSError，如果非要用try/catch那么要注意在final里释放资源（比如数据库）
##### 如何理解NSCopying
对象想要拷贝必须实现NSCopying协议，如果是想要深拷贝是实现NSMutableCopying协议，默认的拷贝都是浅拷贝
copywithzone方法里的zone参数是历史遗留问题，不必理会
##### 用assign修饰对象会怎样
会崩溃
assign和weak修饰类似，weak对应的关键修饰符是__weak，assign是__unsafe_unretained，俩的差别就是__weak释放后会置nil，assign会出现野指针，而用他们俩修饰，简单的allocinit编译后带代码是会发送消息让对象直接释放
##### 理解属性这一概念
实例变量，加上get/set方法
@dynamic告诉编译器不要自动创建set/get方法，还有实例变量
@synthesize可以指定实例变量的名字（这个最好少用，不然代码让人看不懂）
默认情况下属性是atomic，是自动加了一个同步锁(synchronized)，这个历史遗留问题iOS同步锁的开销很大，而且atomic也不一定能保证线程安全，所以大部分都是nonatomic，再用其他的锁保证线程安全
##### 类对象的能否继承，重写
可以
##### 如何检测项目中的野指针（BAD_ACCESS）
开启僵尸对象模式
开启僵尸对象调试后，原本要被系统回收的对象系统就不会将他们回收，而是转化成僵尸对象，所占用的内存也不会被复写，当他们收到消息的时候，就会抛出异常。
僵尸对象的生成类似KVO，当设置了僵尸对象，系统会在dealloc的时候swizzle，new出来的新的僵尸Object，并指向原本的Object，原本的Object不会释放，当僵尸对象收到消息，就能找到原本将收到消息的对象了并抛出异常
##### nil，Nil，Null，NSNull
nil：指向oc中对象的空指针
Nil：指向oc中类的空指针
NULL：指向其他类型的空指针，如一个c类型的内存指针
NSNull：在集合对象中，表示空值的对象
##### 向一个nill对象发送消息会发生什么？
什么都不会发生，send_msg的时候回判断如果对象是nil则return
##### 理解引用计数ARC
？？？
##### ARC下的retain和release的优化（这个答案不确定对不对）
？？？会对引用计数的溢出做处理，里面有一个extra_rc，如果溢出这个变量会有值
##### 内存管理方案
1.taggedPointer:由于NSNumber、NSDate一类的变量本身的值需要占用的内存大小常常不需要8个字节，所以将一个对象的指针拆成两部分，一部分直接保存数据，另一部分作为特殊标记，表示这是一个特别的指针，不指向任何一个地址，将值直接存储到了指针本身里。但是TaggedPointer因为并不是真正的对象，而是一个伪对象，所以你如果完全把它当成对象来使，可能会让它露马脚。所有对象都有 isa指针，而TaggedPointer其实是没有的具体的
![](/images/taggedpointer.png)
2.NONPOINTER_ISA--(非指针型的 isa) -> 感觉很像taggedPointer
3.SideTables
https://www.jianshu.com/p/c9089494fb6c
##### <span id="Autoreleasepool_jump">Autoreleasepool实现原理</span>
autoReleasepool的两个核心方法：objc_autoreleasePoolPush和objc_autoreleasePoolPop
自动释放池的释放过程大概就是objc_autoreleasePoolPush-> [objct autorelease] -> objc_autoreleasePoolPop
再往里面看，每次AutoreleasePoolPush/pop就是调用Page的push/pop
![](/images/autoreleasepool01.png)
从图片里可以看出AutoreleasePool是一个双向链表，每个节点就是栈指针，里面有对象和一个Page，大小是一页虚拟内存的大小(4KB)
```
AutoReleasePool的官方注释
/***********************************************************************
   Autorelease pool implementation

   A thread's autorelease pool is a stack of pointers. 
   Each pointer is either an object to release, or POOL_SENTINEL which is 
     an autorelease pool boundary.
   A pool token is a pointer to the POOL_SENTINEL for that pool. When 
     the pool is popped, every object hotter than the sentinel is released.
   The stack is divided into a doubly-linked list of pages. Pages are added 
     and deleted as necessary. 
   Thread-local storage points to the hot page, where newly autoreleased 
     objects are stored. 
**********************************************************************/
```
一个线程的autoreleasepool就是一个指针栈。
栈中存放的指针指向加入需要release的对象或者POOL_SENTINEL(哨兵对象，用于分隔autoreleasepool）。
栈中指向POOL_SENTINEL的指针就是autoreleasepool的一个标记。当autoreleasepool进行出栈操作，每一个比这个哨兵对象后进栈的对象都会release。
##### weak的实现原理？SideTable的结构是什么样的
weak 的实现原理可以概括一下三步：
- 初始化时：runtime会调用objc_initWeak函数，初始化一个新的weak指针指向对象的地址。
- 添加引用时：objc_initWeak函数会调用objc_storeWeak()函数，objc_storeWeak()的作用是更新指针指向，创建对应的弱引用表。
- 释放时，调用clearDeallocating函数。clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录。
```
id objc_initWeak(id *location, id newObj) {
// 查看对象实例是否有效
// 无效对象直接导致指针释放
    if (!newObj) {
        *location = nil;
        return nil;
    }
    // 这里传递了三个 bool 数值
    // 使用 template 进行常量参数传递是为了优化性能
    return storeWeakfalse/*old*/, true/*new*/, true/*crash*/>
    (location, (objc_object*)newObj);
}
```
http://www.cocoachina.com/articles/18962（weak的实现原理）
weak苹果是用的一个引用计数表进行管理
weak的管理表和引用计数表都是通过SideTables进行管理，SideTables全局的哈希表，由多个SideTable结构体组成，一共有64个以对应的内存地址作为Key去查表
![](/images/sideTables01.jpeg)
SideTable有三个元素：
自旋锁：苹果用了分离锁技术，自旋锁速度快，引用计数访问很频繁，只对单个SideTable加锁，而不对整个SideTables一起加锁
RecountMap:C++的Map，存放对象真正的引用计数。对象通过内存地址Hash进入SideTable，再通过RecountMap的Hash进入最终的技术表，两次hash更小的碰撞，查找更快
weak_table_t:一个结构体，里面两个元素，一个是存放对象引用计数和指向那个对象的对象的引用计数结构体的数组（有点拗口，就是一个数组，里面装的结构体，结构体里是weak对象的指针，还有一个元素是引用了这个weak对象的对象地址的数组），还有是这个数组的最大长度。为了扩容，扩容策略和cache_t一样。但是cache_t是哈希表，这个是数组，所以cache_t每次扩容会清除原有的数据
https://www.jianshu.com/p/ef6d9bf8fe59
##### weak属性如何自动置nil的
请回顾对象的释放过程，dealloc的实现机制
objc_rootdealooc
rootdealloc
objct_dispose
objc_destructInstance
    object_cxxDestruct:判断有没有关联Cpp的东西，删除掉
    _object_remove_assocations:去除和这个对象assocate的对象
    objc_clear_deallocating
就是这个objc_clear_deallocing，会去查找sideTables里对应存储的表，并且清除对象
##### 访问__weak修饰的变量，是否已经被注册在了@autoreleasePool中?为什么?
会扔到autoreleasepool中，不然创建之后也就会销毁（之前做过assign的demo，生成之后就被释放），为了延长它的生命周期，必须注册到 @autoreleasePool中，以延缓释放。
##### 简述一下Dealloc的实现机制
1.调用objc_rootdealloc()
2.rootdealloc()
3.object_dispose()  //dispose翻译是处理
4.objc_destructInstance()
    4.1:object_cxxDestruct:判断有没有关联Cpp的东西，删除掉
    4.2:_object_remove_assocations:去除和这个对象assocate的对象
    4.3:objc_clear_deallocating:清空引用计数表并清除弱引用表，将所有weak引用指nil（这也就是weak变量能安全置空的所在）
5.C的free()
##### BAD_ACCESS在什么情况下出现
就是野指针呗，访问一个已经被销毁的内存空间就会出现，调试方法用僵尸对象
##### atomic是线程安全的吗
不是
首先atomic只是在get/set方法上加了@synchronized(self)
苹果开发文档已经明确指出：Atomic不能保证对象多线程的安全。它只是能保证你访问的时候给你返回一个完好无损的Value而已，线程安全需要开发者自己来保证。举个例子：
假设有一个 atomic 的属性 "name"，如果线程 A 调[self setName:@"A"]，线程 B 调[self setName:@"B"]，线程 C 调[self name]，那么所有这些不同线程上的操作都将依次顺序执行——也就是说，如果一个线程正在执行 getter/setter，其他线程就得等待。因此，属性 name 是读/写安全的。
但是，如果有另一个线程 D 同时在调[name release]，那可能就会crash，因为 release 不受 getter/setter 操作的限制。也就是说，这个属性只能说是读/写安全的，但并不是线程安全的，因为别的线程还能进行读写之外的其他操作。线程安全需要开发者自己来保证
另外，UI的atomic更没必要写，毕竟UI都是在主线程里
https://blog.csdn.net/u012903898/article/details/82984959

-------------
#### Runtime与内存
##### id的实质(联系block为什么是一个OC对象)
```
//id为一个objc_object结构体的指针类型
typedef struct objc_object {
    Class isa;
} *id;

//Class为objc_class结构体的指针类型
typedef struct objc_class *Class;
struct objc_class {
    Class isa;
};
```
而block的结构体
```
struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
}
```
一个普通对象
```
struct TestObject {
    Class isa;
    int val0;
    int val1;
}
```
id是一个一个指向objc_object结构体的指针
##### IMP、SEL、Method的区别
SEL是方法编号，也是方法名
IMP是函数实现指针，找IMP就是找函数实现的过程
Method就是具体的实现
SEL和IMP的关系就可以解释为：
SEL就相当于书本的⽬录标题
IMP就是书本的⻚码
Method就是具体页码对应的内容
SEL是在dyld加载镜像到内存时，通过_read_image方法加载到内存的表中了
##### runtime的内存模型（isa、对象、类、metaclass、结构体的存储信息等）
![](/images/objc_class01.png)
```
struct objc_object {
    isa_t isa;
}
union isa_t {
    Class cls;
    uintptr_t bits;
    struct {
        uintptr_t nonpointer : 1;   //0代表普通指针，1表示优化过的
        uintptr_t has_assoc : 1;    //是否有关联对象
        uintptr_t has_cxx_dtor : 1; //是否有c++析构函数
        uintptr_t shiftcls : 33; // 内存地址信息MACH_VM_MAX_ADDRESS 0x1000000000
        uintptr_t magic : 6;    //调试
        uintptr_t weakly_referenced : 1;    //是否有鶸引用指向
        uintptr_t deallocating : 1; //是否正在释放
        uintptr_t has_sidetable_rc : 1;     //是否引用计数过大无法存在isa中
        uintptr_t extra_rc  : 8;    //有8位，2^7-1，引用计数过大这里会有值
    };
    ... //乱七八糟的信息
}
typedef struct objc_class *Class;
struct objc_class : objc_object {
    Class superclass;
    cache_t cache;             // formerly cache pointer and vtable
    class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
    class_rw_t *data() {  
        return bits.data();
    }
    struct class_rw_t {  
        uint32_t flags;
        uint32_t version;
 
        const class_ro_t *ro;   //存储了当前类在编译期就已经确定的属性、方法以及遵循的协议
 
        method_array_t methods;
        property_array_t properties;
        protocol_array_t protocols;
 
        Class firstSubclass;
        Class nextSiblingClass;
    };
}
struct cache_t {
    struct bucket_t *_buckets;  //bucket_t则是存放着imp和key
    mask_t _mask;       //mask是缓存池的最大容量
    mask_t _occupied;   //occupied是缓存池缓存的方法数量
    struct bucket_t *buckets();
    mask_t mask();
    mask_t occupied();
    mask_t capacity();  //容量
    bool canBeFreed();
    void expand();
    ........
}

```
![](/images/rw_ro.png)
##### 为什么要设计metaclass
万物皆对象，类对象也能使用消息机制
每个类都有自己的metaclass有利于单一职责，不然就全写在NSObjct的Metaclass了，不好
##### runtime的API里class_copyIvarList & class_copyPropertyList区别
```
{
    NSString *str;
}
@property NSString *property;

//class_copyIvarList
str
_property
//class_copyPropertyList
property
```
class_copyIvarList能够获取所有属性以及大括号中声明的成员变量，能获取属性的成员变量
class_copyPropertyList:只能获取由property声明的属性，获取的属性名称不带下划线。
所以OC中没有真正的私有属性，因为不管写在.h还是.m都能被捕获
##### 在方法调用的时候，方法查询-> 动态解析-> 消息转发 之前做了什么
这个问题其实是问一个对象，调用他的方法是什么步骤
首先是看rw_t里的cache是否有对应的方法([cache_t如何存储方法](#cache_t_jump))，如果找到就调用，没找到会往cache里加方法（这里涉及到cache的缓存），然后从methodlist里找，找不到再往父方法里面找，还不行就开始走转发流程（转发三部曲）
检查selector是否需要忽略，比如retain和release这样的函数
检查target是不是为nil，如果是nil的话msg_send就会被忽略掉
之后就是在缓冲中找有没有方法，没有就去对象的method_list找，还没有就去父类中去找，还没找到就会到_objc_msgForward消息转发，还不行还有最后的一次机会包装NSInvocation给开发，还不行就崩溃了
##### <span id="cache_t_jump">方法cache表是如何存储方法的（缓存策略）得好好用笔模拟下</span>
```
struct cache_t {
    struct bucket_t *_buckets;  //bucket_t则是存放着imp和key，用来缓存方法的散列/哈希表
    mask_t _mask;       //mask是缓存池的最大容量， 这个值=散列表长度 - 1
    mask_t _occupied;   //occupied是缓存池缓存的方法数量
    struct bucket_t *buckets();
    mask_t mask();
    mask_t occupied();
    mask_t capacity();  //容量
    bool canBeFreed();
    void expand();
    ........
}
struct bucket_t {
private:
    cache_key_t _key;
    IMP _imp;
}
```
这里简要介绍一下散列表。首先散列表本质上就是一个数组
在往散列表里面添加成员的时候，首先需要借助key计算出一个index，也就是cache_hash函数，然后再将元素插入散列表的index位置
根据key计算出index值的这个算法称作散列算法，这个算法可以由你自己设计，总之目的就是尽可能减少不同的key得出相同index的情况出现，这种情况被称作哈希碰撞，同时还要保证得出的index值在合理的范围。index越大，意味着对应的散列表的长度越长，这是需要占用实际物理空间的，而我们的内存是有限的。散列表是一种通过牺牲一定空间，来换取时间效率的设计思想。
我们通过key计算出的index大小是随机的，无顺序的，因此在方法缓存的过程中，插入的顺序也是无顺序的
而且可以预见的是，散列表里面再实际使用中会有很多位置是空着的，比如散列表长度为16，最终值存储了10个方法，散列表长度为64，最终可能只会存储40个方法，有一部分空间终究是要被浪费的。但是却提高查找的效率。这既是所谓的空间换时间。
进入正题：
再介绍一下苹果这里所采用的散列算法，其实很简单，如下
index = @selector(XXXX) & mask
根据&运算的特点，可以得知最终index <= mask，而mask = 散列表长度 - 1，也就是说 0 <= index <= 散列表长度 - 1，这实际上覆盖了散列表的索引范围。
而刚刚我们还提到过一个问题——哈希碰撞，也就是不同的key得到相同的index，这个问题处理就是find方法
find查找大概就是将index-1,从index开始，遍历一遍查找，当走过一圈之后，如果没有找到则返回0（bucket->key() == 0），就说明该位置上是空的，没有缓存过方法，是一个unused slot(未使用的槽口)，因此可以进行插入操作bucket->set(key, imp);，也就是将方法缓存到这个位置上
开辟方法不仅仅是在老缓存池基础上进行扩容，开辟新的buckets，释放老的buckets，因为苹果是通过哈希表进行缓存，并且散列算法是index = @selector(XXXX) & mask，扩容后mask发生了变化，所以里面缓存方法的index也都要发生变化，为了提高缓存效率，创建了新的buckets，老的buckets就会被释放掉，所以当容量达到最大值的3/4时，开始2倍扩容，扩容时会完全抹除旧的buckets，并且创建新的buckets代替，之后把最近一次临界的imp和key缓存进来
这里面有详细的源码
https://www.jianshu.com/p/fcf8d17121e3

##### 消息转发机制objc_msgSend
objc_msgSend会查找当前对象的methodList，如果没有，会往自己的父类中去查找，如果都查不到会进行消息转发。当找到了对应的方法后，会吧方法缓存到一个表中，下一次再访问的时候就从缓存中查找，这样速度更快
消息转发分为两个阶段：
1.动态方法解析：先查询接受者，看有没有动态添    -=——）加方法处理这个消息
2.完整的消息转发机制：这时候第一步已经执行完，运行时系统不会再动态添加方法，也不会再去查找动态添加的方法，这时系统会看有没有其他的消息接收对象，如果有就转发消息给备用对象，如果没有，系统会把消息封装在NSInvocation对象，给接受者最后一次机会处理消息
![](images/msg_send.jpeg)
##### Runtime的内存优化
1.类数据结构变化
当类被Runtime加载之后，类的结构会发生一些变化，
CleanMemory加载后不会发生更改的内存块，class_ro_t属于Clean Memory，因为它是只读的
DirtyMemory运行时会进行更改的内存块，类一旦被加载，就会变成Dirty Memory，例如，我们可以在 Runtime 给类动态的添加方法
在介绍优化方法之前，我们先来看一下，在类加载之后类的结构变化：
在类加载到Runtime中后会被分配用于读取/写入数据的结构体class_rw_t
Tips：class_ro_t是只读的，存放的是编译期间就确定的字段信息；而class_rw_t是在 runtime 时才创建的，它会先将class_ro_t的内容拷贝一份，再将类的分类的属性、方法、协议等信息添加进去，之所以要这么设计是因为 Objective-C 是动态语言，你可以在运行时更改它们方法，属性等，并且分类可以在不改变类设计的前提下，将新方法添加到类中
优化可以吧rw里很多不会改变的方法放在一个新建的rw_ext里，rw_ext再指向ro，让一部分DirtyMemory变成CleanMemory
https://halfrost.com/objc_runtime_isa_class/

-------------
#### Runloop
##### NSThread、NSRunLoop 和 AutoreleasePool
苹果不允许直接创建RunLoop，但是可以获取Main和CurrentRunloop
线程和Runloop是一一对应的，保存在一个全局的Dictionary中。
子线程默认是没有开启runloop的，需要自己手动run。当线程结束的时候，runloop被回收，可以通过runloop线程保活。
线程会对应一个runloop，autoreleasepage里有对应的线程字段属性
线程在RunloopPage可以得知会对应一个autoreleasepool
##### 循环的细节
![](/images/runloop_001.png)
```
{
    /// 1. 通知Observers，即将进入RunLoop
    /// 此处有Observer会创建AutoreleasePool: _objc_autoreleasePoolPush();
    __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopEntry);
    do {

        /// 2. 通知 Observers: 即将触发 Timer 回调。
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeTimers);
        /// 3. 通知 Observers: 即将触发 Source (非基于port的,Source0) 回调。
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeSources);
        /// 主线程的调用
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__(block); 

        /// 4. 触发 Source0 (非基于port的) 回调。
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__(source0);
        /// 主线程的调用
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__(block);

        /// 6. 通知Observers，即将进入休眠
        /// 此处有Observer释放并新建AutoreleasePool: _objc_autoreleasePoolPop(); _objc_autoreleasePoolPush();
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeWaiting);

        /// 7. sleep to wait msg.
        mach_msg() -> mach_msg_trap();


        /// 8. 通知Observers，线程被唤醒
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopAfterWaiting);

        /// 9. 如果是被Timer唤醒的，回调Timer
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__(timer);

        /// 9. 如果是被dispatch唤醒的，执行所有调用 dispatch_async 等方法放入main queue 的 block
        __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(dispatched_block);

        /// 9. 如果如果Runloop是被 Source1 (基于port的) 的事件唤醒了，处理这个事件
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__(source1);


    } while (...);

    /// 10. 通知Observers，即将退出RunLoop
    /// 此处有Observer释放AutoreleasePool: _objc_autoreleasePoolPop();
    __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopExit);
}


int32_t __CFRunLoopRun()
{
    //通知即将进入runloop
    __CFRunLoopDoObservers(KCFRunLoopEntry);
     
    do
    {
        // 通知将要处理timer和source
        __CFRunLoopDoObservers(kCFRunLoopBeforeTimers);         
        __CFRunLoopDoObservers(kCFRunLoopBeforeSources);
         
        __CFRunLoopDoBlocks();  //处理非延迟的主线程调用
        __CFRunLoopDoSource0(); //处理UIEvent事件
         
        //GCD dispatch main queue
        CheckIfExistMessagesInMainDispatchQueue();
         
        // 即将进入休眠
        __CFRunLoopDoObservers(kCFRunLoopBeforeWaiting);
         
        // 等待内核mach_msg事件
        mach_port_t wakeUpPort = SleepAndWaitForWakingUpPorts();
         
        // Zzz...
         
        // 从等待中醒来
        __CFRunLoopDoObservers(kCFRunLoopAfterWaiting);
         
        // 处理因timer的唤醒
        if (wakeUpPort == timerPort)
            __CFRunLoopDoTimers();
         
        // 处理异步方法唤醒,如dispatch_async
        else if (wakeUpPort == mainDispatchQueuePort)
            __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__()
             
        // UI刷新,动画显示
        else
            __CFRunLoopDoSource1();
         
        // 再次确保是否有同步的方法需要调用
        __CFRunLoopDoBlocks();
         
    } while (!stop && !timeout);
     
    //通知即将退出runloop
    __CFRunLoopDoObservers(CFRunLoopExit);
}
```
##### runloop有几个mode
runloop内部有几个mode,而mode里有timer，source，observer(？？？都是数组，一个mode能有好几个timer，source，observer？？？)
timer:下面的都是这个的timer封装
```
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;
- (void)performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay;
+ (CADisplayLink *)displayLinkWithTarget:(id)target selector:(SEL)sel;
- (void)addToRunLoop:(NSRunLoop *)runloop forMode:(NSRunLoopMode)mode;
```
关于时间的封装几乎都和runloop有关
source:runloop执行的输入源（一个protcol）
只要符合protocol就可以随便跑(几乎不可能遇到)
runloop自己定义了俩，就叫source0和source1
source0:处理App内部事件，比如touch事件，socket
source1:由runloop和内核管理，machport驱动，如CFMachPort,CFMessagePort。（machport用在KVO线程通信）
observer:告诉当前的runloop是设么状态，在干嘛
```
typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    kCFRunLoopEntry         = (1UL << 0), // 即将进入Loop
    kCFRunLoopBeforeTimers  = (1UL << 1), // 即将处理 Timer
    kCFRunLoopBeforeSources = (1UL << 2), // 即将处理 Source
    kCFRunLoopBeforeWaiting = (1UL << 5), // 即将进入休眠
    kCFRunLoopAfterWaiting  = (1UL << 6), // 刚从休眠中唤醒
    kCFRunLoopExit          = (1UL << 7), // 即将退出Loop
};
```
比如CAAnimation，会在kCFRunLoopBeforeWaiting || kCFRunLoopAfterWaiting后调用。runloop会搜集这一次runloop循环里的所有动画，然后再一块执行
**runloopobserver和autorelease的关系**
**在UITouch里dealloc加个断点，点击后进入断点可以看到，在runloop的一个observercallout后会走调用autoreleasepophandler，之后就是池的pop，具体的释放时间是在一个runloop结束了后sleep然后再继续跑，释放时间就是在两次的sleep的时间之间**

每次更换mode的时候要停下当前mode，再重启loop，同一时间只能执行一个
```
NSDefaultRunLoopMode    //默认的，空闲状态
UITrankingRunloopMode   //滑动scrollView
NSRunLoopCommonModes    //上面俩的集合，俩的都能跑
//还有个私有的，在启动的时候，不会用到
```
一般Timer都在default里，滑动的时候成了UITranking，所以timer不走了。要timer走得让timer用commonmodes

这里说一句，gcd的timer是系统内核实现，由runloop回调，gcdtimer的实现和runloop无关
##### 和runloop有关的东西(孙源)
NSTimer：完全依赖runloop
UIEvent：事件的产生到分发给相应的事件处理函数都通过 runloop (souece0)
Autorelease
NSObject中关于时间的方法，比如performDelay，performcancel，performOnMainThread等等
CADisplayLink:每画一帧给一个回调
CAAnimation(kCFRunLoopAfterWaiting之后，收集了所有的动画后再执行)
CATransition
dispatch_get_main_queue
NSURLConnection
AFN
##### runloop实践(孙源)
AFN中的runloop和NSMachPort一起实现线程常驻
tableView因为下载图片变卡，可以用performdelay:0 mode:default来做，当tableView彻底停下之后再下载图片
Crash时候收到Signal后会杀死runloop，手动开启runloop让app回光返照
##### 线程保活的时候，用RunloopMode的时候能用CommonMode吗
不可以
我记得源码里有写，如果是commonMode会return掉，只能用default（7月18/19逻辑教育讲MachPort有源码，里面有说这个)
##### AutoReleasePool什么时候释放?
entry监听回调里会有_objc_autoreleasePoolPush() 创建自动释放池，且优先级最高，保证创建释放池发生在其他所有回调之前。
BeforeWaiting(准备进入休眠)时调用_objc_autoreleasePoolPop()和_objc_autoreleasePoolPush()释放旧的池并创建新池
Exit(即将退出Loop)时调用_objc_autoreleasePoolPop()来释放自动释放池。这个Observer优先级最低，保证其释放池子发生在其他所有回调之后
孙源的Runloop分享里说过，在当前runloop结束之后和下一次runloop结束之前调用drain方法
##### 解释下事件响应过程
硬件的监听器发现有硬件的事件发生后（触摸，摇晃，锁屏，触摸等等），由IOKit生成一个IOEvent事件然后由MachPort转发给对应的App进程，然后source1会接受这个事件，调用ApplicationHandleEventQueue进行内部分发，然后将IOEvent包装成UIEvent进行处理分发，比如UIButton的点击，touchBegin等等
##### 解释一下手势识别的过程/事件响应过程
硬件监听器发现有硬件的事件发生后（触摸，摇晃，点击等等），由IOKit生成一个IOHIDEvent事件然后由MachPort转发给对应的App进程，触发source1触发回调，然后通过ApplicationHandleEventQueue分发。
ApplicationHandleEventQueue会把IOHIDEvent处理并包装成UIEvent进行处理或分发，其中包括识别UIGesture/处理屏幕旋转/发送给UIWindow等。
通常事件比如 UIButton 点击、touchesBegin/Move/End/Cancel 事件都是在这个回调中完成的。
手势识别：
当上面的 _UIApplicationHandleEventQueue() 识别了一个手势时，其首先会调用 Cancel 将当前的 touchesBegin/Move/End 系列回调打断（如何打断呢？）。随后系统将对应的 UIGestureRecognizer 标记为待处理。苹果注册了一个 Observer 监测 BeforeWaiting (Loop即将进入休眠) 事件，这个Observer的回调函数是 _UIGestureRecognizerUpdateObserver()，其内部会获取所有刚被标记为待处理的 GestureRecognizer，并执行GestureRecognizer的回调。当有 UIGestureRecognizer 的变化(创建/销毁/状态改变)时，这个回调都会进行相应处理。
##### 解释一下页面的渲染的过程
渲染过程，包括像动画效果，我们项目中的inMainThread（这里是因为mainThread的runloopCallOut是在Pop和Push之间，应该也是在Beforwaiting的时候），都是在beforewaiting(即将休眠的时候)的时候被系统捕获这些被打了标记的对象，然后统一作出处理。
layer会调用[CALyer display]，进入到真正的绘制过程。接下来就是通过判断看是否是异步绘制代理方法func display(_ layer: CALayer)，如果有异步绘制的代理方法，则走异步绘制func display(_ layer: CALayer)方法
如果没有的话走系统绘制方法。
系统绘制：
layer会创建backingStore获取上下文CGContextRef,
接下来判断是否有layer.delegate代理
如果有：
调用layer.delegate drawLayer:inContext:，
接着返回UIVew drawRect回调，让我们在系统绘制的基础上，再做一些其他的事情
如果没有：CALayer drawInContext
走完后，CALayer上传backingStore给GPU，结束
异步绘制：
直接走func display(_ layer: CALayer)方法，里面dispatchAsyncGlobal，然后再dispatch到Main的过程中吧异步生成的东西赋值给layer.contents，结束

#### Category
##### Category的实现原理
```
typedef struct category_t {
    const char *name;//类的名字 主类名字
    classref_t cls;//类
    struct method_list_t *instanceMethods;//实例方法的列表
    struct method_list_t *classMethods;//类方法的列表
    struct protocol_list_t *protocols;//所有协议的列表
    struct property_list_t *instanceProperties;//添加的所有属性
} category_t;
```
在编译时期，会将分类中实现的方法生成一个结构体 method_list_t 、将声明的属性生成一个结构体 property_list_t ，然后通过这些结构体生成一个结构体 category_t 。
然后将结构体 category_t 保存下来
在运行时期，Runtime 会拿到编译时期我们保存下来的结构体 category_t
然后将结构体 category_t 中的实例方法列表、协议列表、属性列表添加到主类中
将结构体 category_t 中的类方法列表、协议列表添加到主类的 metaClass 中

##### Category如何被加载的
在_objc_init->map_images->_read_images，然后将category的方法和类方法添加到对应的类里面。回顾[App启动过程](#AppLaunch_jump)，里面有写
##### 两个category的load方法的加载顺序，两个category的同名方法的加载顺序呢，initialize,在继承关系中他们有什么区别
load在main前调用方法不管对象用不用都会调用，先调用父类，再调用子类
category的load是按照编译顺序来的，先编译的先调用，后编译的后调用
category的initialize是按照编译顺序来的，所有的initialize只调用一次，也就是最后编译的那个category中的initialize方法
##### category & extension区别，能给NSObject添加Extension吗，结果如何
category:
运行时添加分类属性/协议/方法
分类添加的方法会“覆盖”原类方法，因为方法查找的话是从头至尾，一旦查找到了就停止了
同名分类方法谁生效取决于编译顺序，读取的信息是倒叙的，所以编译越靠后的越先读入
extension:
编译时决议
只有.h文件，只以声明的形式存在，所以不能为系统类添加扩展
这东西就是用来访问自己写的类的私有方法的
##### Category能添加成员变量吗?
不能。只能通过关联对象(objc_setAssociatedObject)来模拟实现成员变量，但其实质是关联内容，所有对象的关联内容都放在同一个全局容器哈希表中:AssociationsHashMap,由 AssociationsManager统一管理。
##### 如果工程里有两个CategoryA和B，两个Category中有一个同名的方法，哪个方法最终生效?
取决于谁在后面被编译，最后编译的生效，她会覆盖之前的方法。这个覆盖并不是真正的覆盖，之前编译的方法都在只是访问不到。因为category动态编译的方法是倒叙遍历，所以最后编译的方法在最上层能被调用到（回顾[App启动过程](#AppLaunch_jump)）

*************
### Block
##### 理解Block
Block就是带有局部变量的匿名函数(RB.P80)
匿名函数：不带名称的函数。虽然说函数指针也是可以替换掉函数的，但是函数指针在赋值的时候也是需要知道函数名的
```
int (*funcptr)(int) = &func;
int result = (*funcptr)(10); 
```
##### blcok的实质
当一个block被转换为C代码后是这样的
```
//Block
void(^blk)(void) = ^{
    printf("Block\n");
};
blk();
//转化后是这样
struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
}
//接下来是几个名叫__main_block_xxx_0的结构体和方法
//这里用impl代替原本的__main_block_impl_0
//这里用func代替原本的__main_block_func_0
//这里用desc代替原本的__main_block_desc_0
struct impl0 {
    struct __block_impl impl;
    struct desc *Desc;
    //block的一个构造方法
    impl0(void *fp ... ...) {
        impl.isa = &StackBlock;
        impl.FuncPtr = fp;
    }
}

static void func0(struct impl *__cself) {
    printf("Block\n");
}

static struct desc0 {    //这个里边就是关于版本，大小的数据
    unsigned long reserved;
    unsigned long Block_size;
}
//block的最终生成函数
void(^blk)(void) = (void (*)(void)) &imp0((void *)func0 ... ...)
//blk();转化
(*blk->imp.FuncPtr)(blk);
```
(以下分别省去__main_block_0这个前缀和后缀)
从源代码中就可以看出，其实Block内部最终的方法就是func里的内容。从这个方法的参数，又能联系到impl0这个结构体，在这个结构体里又有__block_impl这个结构体和desc这个结构体。
然后看最后的block生成函数，一个block就是调用结构体的impl0的构造函数初始化一个impl0的struct，传入代表源block内部方法的func0，impl0里的impl又有关于impl0需要的信息和函数指针。由此看出impl0结构体，实际上就是我们的block。
因为OC对象的实质就是个有isa指针的结构体，所以Block也可以看做一个OC对象(RB.P97~P99，这里有详细介绍id,即void *是什么个东西)
最后使用Block的代码blk()转换后就是简单的函数调用
##### blcok如何截获局部变量
如代码所示，block是会截取局部变量的
```
void blockFunc() {
    int val = 10;
    void (^blk)(void) = ^{
        printf("val in block = %d\n", val);
    };
    val = 20;
    printf("now the val = %d\n", val);
    blk();
}
```
最后打印的结果是
```
now the val = 20
val in block = 10
Program ended with exit code: 0
```
因为block会捕获局部变量的瞬间值，所以在block捕获之后，val的值改变成多少，都和block捕获的变量无关

```
//Block
int dmy = 20;
int val = 10;
const char *fmt = "val = %d\n";
void(^blk)(void) = ^{
    printf(fmt, val);
};
blk();
//转化后代码合上面的block实质这部分差不多，不过下面这里不同
struct impl0 {
    struct __block_impl impl;
    struct desc *Desc;
    int val;
    const char *fmt;
    //block的一个构造方法
    impl0(void *fp , int _val, char *_fmt ... ...) {
        impl.isa = &StackBlock;
        impl.FuncPtr = fp;
    }
}
static void func0(struct impl *__cself) {
    const char *fmt = __cself->fmt;
    int val = __cself->val;
    printf(fmt, val);
}
```
从源码中可知，局部变量fmt和val会被作为impl0这个结构体的成员变量，但是dmy这个变量block没有使用，所以他是不会被追加进去的。
```
struct impl0 {
    struct __block_impl impl;
    struct desc *Desc;
    int val;
    const char *fmt;
}
```
由此我们可以看出block是如何截取变量的。即使在Block内部使用了被截取的变量，也不会对原来的对象有影响
所以所谓的截取成员变量，就是将成员变量值被保存到block的实例中（即impl0这个机构体之中）
##### __block
__block其实是和static将变量存在静态区，auto存在栈区等说明符一样，是指将变量放入某个特定的内存区域
```
__block int val = 10;
void(^blk)(void) = ^{
    val = 1;
};
```
```
__block int val = 10;
//编译后
struct __Block_byref_val_0 {
    void *__isa;
    __Block_byref_val_0 *__forwarding;
    int __flags;
    int __size;
    int val;
};
```
可以见得val加了__block之后成为了一个结构体，可以将它看成一个objc对象。其中，val就是真正的int val，而__forwarding是一个指向自己的指针,他存在的原因是因为->block都有哪几种类型的Block
这个结构体可以用在几个block中。
```
struct impl0 {
    struct __block_impl impl;
    struct desc *Desc;
    __Block_byref_val_0 *val;
    //block的一个构造方法
    impl0(void *fp, __Block_byref_val_0 *_val : val(val->__forwarding) ... ...) {
        impl.isa = &StackBlock;
        impl.FuncPtr = fp;
    }
}

static void func0(struct impl *__cself) {
    __Block_byref_val_0 *val = __cself->val;
    val->__forwarding->val = 1;
}
```
在这个func0中，我们可以看到，实际上，我们可以通过拿到当前Block结构体(即impl0)中的val，然后再通过val这个结构体(即__block编译出的结构体)找到最终的那个__block int val并赋值;
##### block都有哪几种类型的Block，__block的变量存储域
有Stack,Malloc,Global(数据区)
在block初始化的时候结构体__block_impl的isa指针会指向对应的block类型
```
//NSConcreteGlobalBlock
void(^blk)(void) = ^{printf("Global Block");};
int main() {
    //
}
//注意，全局Block是不能使用局部变量的
```
```
//NSConcreteStackBlock
int main() {
    void(^blk)(void) = ^{printf("Stack Block");};
}
```
GlobalBlock，任何地方都能访问，但是全局Block是不能使用局部变量的
StackBlock在ARC下其实已经没有了，一生成就会被编译器自动copy到堆上成为堆Block。通过编译后的代码可以看出一个StackBlock会初始化后将自己copy到堆上，然后加入到autoreleasepool中。
对于堆block，来说，是为了保证Block超出了作用域还能使用而存在的。如果一个Block是栈block，但是如果他需要在超过了作用域还需要存在，编译器会自动将他从栈复制到堆中。这个也是为啥Block的属性需要用copy，当然用strong也没什么问题，strong对应retain，block的retain实际上是由copy来实现。（苹果的原文copying block里说了，需要在作用域外使用block，copying block到heap）
然鹅有时候会因为编译器在特殊情况下是无法识别Block是否需要被copy，这时候得手动调用copy方法。反正对于block来说，调用copy就行，准没错
对于__block来说，当在栈上的时候，blk0和blk1使用它，如果blk0或blk1被复制到了堆上，那么__block这个被修饰的变量(即objc的对象)则会被一同复制过去的block持有，一个block持有引用计数+1，俩就+2。（因为__block的变量是对象）
对于__block里的__forwarding正是为了解决copy到堆上的问题。当被copy到堆上之后，新的__forwarding还是指向自己，但是老的__forwarding会指向新的，这样就能永远只访问同一个变量
##### block里面使用实例变量会造成循环引用吗
看实例变量是否被是否被强引用，看block是都被其他对象强引用
```
Person *person = [[Person alloc]init];
person.age = 20;
person.block = ^{
    NSLog(@"age is %d",person.age);
};
//编译后
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  Person *__strong person; // 对 person 产生了强引用
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, Person *__strong _person, int flags=0) : person(_person) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
```
由此看出，block里使用了person，那么block会持有person这个对象。但是person对象又持有了Block，那么就会循环引用
解决的办法有三个，__weak,_unsafe_unretain,还有__block
而__block的代码是：
```
Person *person = [[Person alloc]init];
__block Person *weakPerson = person;
person.age = 20;
person.block = ^{
    NSLog(@"my age is %d",weakPerson.age);
    //在 block 内部,把 person 对象置为nil
    weakPerson = nil;
};
person.block();
```
##### block为啥要用copy
文档说想要超过作用域使用，就要copy或者retain这个block，将他copying到heap中，这个是文档原文说的。所以Block和strong都可以，这个是MRC遗留下来的问题
然鹅有时候会因为编译器在特殊情况下是无法识别Block是否需要被copy，这时候得手动调用copy方法。反正对于block来说，调用copy就行，准没错

*************
### KVO，KVC
KVO的实现
https://juejin.im/post/6844903747680731150#heading-4
##### KVC能否触发KVO
KVC能触发KVO，KVC在赋值的时候会会进行方法的调用，首先调用（_setKey,setKey方法），如果没有set方法，责直接内部自己调用设置属性（key，_key）,内部就会监听到值的改变。
##### 如何手动调用KVO
手动调用willChangeValueForKey和didChangeValueForKey方法
被观察的属性会被重写，举个栗子：
```
 - (void)setNow:(NSDate *)aDate {
    [self willChangeValueForKey:@"now"];    //记录旧的值
    [super setValue:aDate forKey:@"now"];   //将新值赋值给旧值
    [self didChangeValueForKey:@"now"];     //判断willChangeValueForKey，如果有再调用observeValueForKeyPath
}
```
只调用didChangeValueForKey方法不可以触发KVO方法，因为willChangeValueForKey记录旧的值，如果不记录旧的值，那就没有改变一说了
##### 如何手动取消KVO
实现automaticallyNotifiesObservers方法就行，实现了之后就只能手动调用KVO
##### KVC的的取值过程，原理是什么
EOC中有写
假如是改name值：[setValue:@"111" forKey:@"name"]
1.首先调用setName方法（就是setter)
2.如果没有找到setName方法，就去调用+(BOOL)accessInstanceVariablesDirectly，这个方法默认是返回YES。然后接着去找类似的变量_name，_isName，name，isName这样的顺序 
但是如果重写让他返回NO，就直接setValue:forUndefinedKey然后崩溃（一般没人这个做）
找的过程中就不管是公有方法还是私有方法了，所以会出现KVC被拒的情况。。。。因为用了苹果私有API
3.如果前面都没找到，就掉setValue:forUndefinedKey抛异常

##### valueForKey:@"name"的底层机制
和set类似，找getName，如果没有的话就按照_name，_isName，name，isName这样的顺序继续找，找不到就抛出异常
还会调用一些countOfName,enumaratorOfName之类的方法，记不清了

##### objectForKey和valueForKey区别
objectForKey文档上说The value associated with aKey, or nil if no value is associated with aKey
valueForKey文档上说The value for the property identified by key
也就是说
(id)valueForKey:(NSString *)key是KVC（key-value coding）的，如果没有找到对应的key会调用-(id)valueForUndefinedKey:(NSString )key从而抛出NSUndefinedKeyException异常，而objectForKey一般会返回一个nil
所以在使用NSDictionary取值时，尽量使用objectForKey

##### 通过直接赋值成员变量会触发KVO吗，KVC会触发KVO吗
不会。
因为kvo是通过isa-swizzling来实现的，被观察对象被runtimeNew一个出来，然后通过swizzling在seter方法上加上一个通知实现的
即使是用setter方法，也会触发KVO（看代码）
使用KVC也会，KVC也会调用setter方法
```
- (void)setName:(NSString *)name {
    _NSSetObjectValueAndNotify();
}
void _NSSetObjectValueAndNotify() {
    [self willChangeValue:"xxx"];
    [super setValue:value];
    [self didChangeValue:"xxx"];    //在这个didChange里面发送的通知
}
```
通过代码可以知道，其实要手动触发的话也得用willChangeValueForKey和didChangeValueForKey方法才行

##### KVO于多线程
KVO多线程问题可以使用MachPort接受异步线程发送的消息

******************************************************************************

### 多线程与锁
#### 多线程
##### 进程和线程
进程：
进程是一个程序执行的过程，一个程序至少有一个进程，
进程是操作系统资源分配的基本单位
进程是一个独立单位，进程有自己的内存空间，拥有独立运行所需的全部资源
线程：
程序执行流的最小单元，线程是进程中的一个实体.
一个进程要想执行任务,必须至少有一条线程.应用程序启动的时候，系统会默认开启一条线程,也就是主线程
进程和线程的关系：
线程是进程的执行单元，进程的所有任务都在线程中执行
线程是CPU分配资源和调度的最小单位
一个程序有多个进程，一个进程有多个线程
同一个进程内的线程共享进程资源

##### 任务和队列
同步任务sync:
阻塞当前线程，不具备开启新线程的能力
异步任务async:
不阻塞当前线程，具备开启新线程的能力(并不一定开启新线程)。如果不是添加到主队列上，异步会在子线程中执行任务

串行队列(Serial):FIFO，同一时间一个队列的任务只能执行一个，完事了之后才能执行下一个
并发队列(Concurrent):FIFO同时允许多个任务并发执行。(可以开启多个线程，并且同时执行任务)。并发队列的并发功能只有在异步任务(dispatch_async)函数下才有效
两者区别：执行顺序不同，以及开启线程数不同。

系统获得队列的方式有三个：
mainQueue:主线程串行队列
globalQueue:系统提供的全局并发队列，存在着高、中、低三种优先级
自定义队列:dispatch_queue_create

##### GCD对比NSOprationQueue
GCD是C语言，NSOprationQueue是GCD的OC封装
NSOperationQueue因为面向对象，所以支持KVO，可以监测正在执行(isExecuted)、是否结束(isFinished)、是否取消(isCanceld)
相比GCD，NSOperationQueue的粒度更细腻，支持更复杂的操作。但是iOS开发中大部分都只会遇到异步操作，不会有很复杂的线程管理，所以GCD更轻量便捷，但是如果考虑复杂的线程操作，那么GCD代码量会暴增，NSOperationQueue会更简便一些
NSOperation主要是重写start和main方法，一个是针对串行，一个是针对并行。Operation的cacel，并不是真正的停止，线程只要开始就不会停掉，只是不给你回调而已

##### 多线程容易出现的问题，怎么解决
多线程容易出现资源同步问题，加锁解决
有时候可能会出现线程爆炸（tableView的优化，prefetching中使用子线程）
内存泄漏：线程常驻的时候自动加入autoreleasepool，因为线程一直存活，所以不会释放，注意释放，很多有线程常驻的三方库都会有这样的逻辑

#### 锁
##### 自旋锁与互斥锁（mutex）的区别
自旋锁和互斥锁的区别在于
1:自旋锁时候忙等，就是说上一个线程被锁后，当前线程不会休眠，而是不停的去检查锁是否可用，当上一个线程完事后当前线程立即执行
2:互斥锁是上一个线程被锁住后当前线程休眠，此时CPU会去执行其他任务。当上一个线程完成后，当前线程再被唤醒执行
优缺点：
自旋锁不会引起休眠，所以没有线程调度所以速度快，但是因为当前线程会不停检查是否解锁所以会占用CPU资源，所以自旋锁适合于那种很短时间的操作（sideTable,atomic），而不适合那种时间较长的锁。互斥锁正好反着
自旋锁：gcd信号量（semp）,OSSpinLock，属性的atomic原来用的是spinlock_t（自旋锁），后来YY大神文章说了，苹果说自旋锁有bug，改成os_unfair_lock（互斥锁）
互斥锁：@syncoized,pthread_mutex,os_unfair_lock，NSLock,NSConditoin,NSConditionLock，NSRecursiveLock（递归锁，在调用 lock 之前，NSLock 必须先调用 unlock。但正如名字所暗示的那样， NSRecursiveLock 允许在被解锁前锁定多次。如果解锁的次数与锁定的次数相匹配，则 认为锁被释放）

##### 线程可以取消吗
只能取消未执行的，不能取消正在执行的
##### 那子线程中的autorelease变量什么时候释放？
每一个线程创建的时候就会有一个Autoreleasepool的创建，并且在线程退出的时候，清空整个Autoreleasepool。（ps:如果在子线程中设置一个循环，autorelease对象确实无法释放，所以在一些线程常驻的库里面注意加一个autoreleasepool）这里可以参考[Autoreleasepool实现原理](#Autoreleasepool_jump)。里面是有pthread的，这个是最底层的thread。
每一个线程创建的时候就会有一个autorelease pool的创建，并且在线程退出的时候，触发清空整个autoreleasepool
##### 子线程里面，需要加autoreleasepool吗
不用，会自动创建，但是可以自己加，在微信的Matrix框架里ping主线程，他们就加了pool
##### 线程常驻
Runloop加Machport
##### Notification和多线程
接收通知处理代码线程 由发出通知的线程决定
如果发送线程是在异步，则接收的线程也是在异步
这里有一个NotificationQueue的东西，没有用过，但是写的是一个双向链表，用于管理通知发送时机(异步发送)，比如runloop空闲发送，尽快发送，立刻发送。Queue依赖runloop，子线程的话得要run.runloop,最终还是通过NSNotificationCenter进行发送通知。所谓异步，指的是非实时发送而是在合适的时机发送，并没有开启异步线程
##### 线程死锁的四个条件，怎么避免
产生死锁的四个必要条件：
（1） 互斥条件：一个资源每次只能被一个进程使用。
（2） 请求与保持条件：一个进程因请求资源而阻塞时，对已获得的资源保持不放。
（3） 不剥夺条件:进程已获得的资源，在末使用完之前，不能强行剥夺。
（4） 循环等待条件:若干进程之间形成一种头尾相接的循环等待资源关系。
只要四个同事满足，就会出现死锁
避免：
1.只要上面的有一个条件满足，就不会有死锁
2.用异步就肯定不会
3.银行家算法：(银行->操作系统，客户->线程，资金->资源，申请贷款->加锁)
******************************************************************************

### 持久化
##### iOS中的持久化方案有哪些
？？？
##### 你们的App是如何处理本地数据安全的(比如用户名的密码)
MD5加盐
1、压缩性：任意长度的数据，算出的MD5值长度都是固定的。
2、容易计算：从原数据计算出MD5值很容易。
3、抗修改性：对原数据进行任何改动，哪怕只修改1个字节，所得到的MD5值都有很大区别。
4、弱抗碰撞：已知原数据和其MD5值，想找到一个具有相同MD5值的数据（即伪造数据）是非常困难的。
5、强抗碰撞：想找到两个不同的数据，使它们具有相同的MD5值，是非常困难的。
6、MD5加密是不可解密的，但是网上有一些解析MD5的，那个相当于一个大型的数据库，通过匹配MD5去找到原密码。所以，只要在要加密的字符串前面加上一些字母数字符号或者多次MD5加密，这样出来的结果一般是解析不出来的
##### 事务的特征
数据库操作序列，这些操作要么全部执行,要么全部不执行，是一个不可分割的工作单位

******************************************************************************

### UI和优化
#### UI部分
##### Frame和Bounse
一个是按照父视图，一个是按照自己，就算bondse的x和y不为0，最后也是0，但是这是bonse的size会以圆点改变大小
##### 一张图片的内存占用大小是由什么决定的
分辨率，x*y*4，为什么是4
##### 图片内存大小为什么是分辨率*4 
每个像素32位4个字节
##### Images.xcassets和直接用图片有什么不一样
sets里叫aaa，实际上可以改名叫bbb
不用再为多像素的图片命名。什么2x，3x不用管
##### 图像显示原理
- CPU提交位图
    1.Layout: UI 布局，文本计算 
    2.Display: 绘制
    3.Prepare: 图片解码 
    4.Commit:提交位图
- GPU图层渲染，纹理合成，把结果放到帧缓冲区(frame buffer)中
- 再由视频控制器根据 vsync 信号在指定时间之前去提取帧缓冲区的屏幕显示内容
- 显示到屏幕上

iOS设备的硬件时钟会发出Vsync(垂直同步信号)
然后App的CPU会去计算屏幕要显示的内容，
之后将计算好的内容提交到GPU去渲染。
随后GPU将渲染结果提交到帧缓冲区，等到下一个VSync到来时将缓冲区的帧显示到屏幕上。
也就是说，一帧的显示是由CPU和GPU共同决定的。
YY的博客里有说过这个东西
##### 卡顿掉帧的表现
FPS降低
CPU占用率很高
主线程Runloop执行了很久
##### UI卡顿掉帧原因
一帧的显示是由CPU和GPU共同决定的。页面滑动流畅是60fps，也就是1s有60帧更新，如果CPU和GPU共同处理的时间超过了1/60秒，就会感受到卡顿
死锁：主线程拿到锁 A，需要获得锁 B，而同时某个子线程拿了锁 B，需要锁 A，这样相互等待就死锁了。
抢锁：主线程需要访问 DB，而此时某个子线程往 DB 插入大量数据。通常抢锁的体验是偶尔卡一阵子，过会就恢复了。
主线程大量 IO：主线程为了方便直接写入大量数据，会导致界面卡顿。
主线程大量计算：算法不合理，导致主线程某个函数占用大量 CPU。
大量的 UI 绘制：复杂的 UI、图文混排等，带来大量的 UI 绘制。
##### 滑动优化方案
CPU：
可以吧这些东西放到子线程中：
1.耗时对象的创建与销毁，耗时操作都放在子线程
2.对一些计算，排版进行预处理（tableView的缓存高度）
3.预渲染，异步绘制（文本的异步绘制，图片的异步解码，CoreGraphic是线程安全，CALayer和UIView不是）
4.用轻量级的控件，比如CALayer替换UIView

GPU:
是否受到CPU或者GPU的限制? 
是否有不必要的CPU渲染? 
是否有太多的离屏渲染操作? 
是否有太多的图层混合操作? 
是否有奇怪的图片格式或者尺寸? 
是否涉及到昂贵的view或者效果? 
view的层次结构是否合理?
文本渲染：屏幕上能看到的所有文本内容控件，包括UIWebView，在底层都是通过CoreText排版、绘制为位图显示的。常见的文本控件，其排版与绘制都是在主线程进行的，显示大量文本是，CPU压力很大。对此解决方案唯一就是自定义文本控件，用CoreText对文本异步绘制。（很麻烦，开发成本高）
当用UIImage或CGImageSource创建图片时，图片数据并不会立刻解码。图片设置到UIImageView或CALayer.contents中去，并且CALayer被提交到GPU前，CGImage中的数据才会得到解码。这一步是发生在主线程的，并且不可避免。SD_WebImage处理方式：在后台线程先把图片绘制到CGBitmapContext中，然后从Bitmap直接创建图片。
图像绘制：图像的绘制通常是指用那些以CG开头的方法把图像绘制到画布中，然后从画布创建图片并显示的一个过程。CoreGraphics方法是线程安全的，可以异步绘制，主线程回调。
##### iOS从磁盘加载一张图片，使用UIImageVIew显示在屏幕上，需要经过步骤
1.从磁盘拷贝数据到内核缓冲区
2.从内核缓冲区复制数据到用户空间
3.生成UIImageView，把图像数据赋值给UIImageView。如果图像数据为未解码的PNG/JPG，解码为位图数据（这里有从DataBuffer变ImageBuffer的过程，具体见[优化部分](#youhua01_jump)）
4.CATransaction捕获到UIImageView layer树的变化
5.主线程Runloop提交CATransaction，开始进行图像渲染
6.1 如果数据没有字节对齐，Core Animation会再拷贝一份数据，进行字节对齐。
6.2 GPU处理位图数据，进行渲染。
##### UI绘制原理
1.当我们调用[UIView setNeedsDisplay]这个方法时，其实并没有立即进行绘制工作，系统会立即调用CALayer的同名方法，并且在当前layer上打上一个标记，然后会在当前runloop将要结束(beforewaiting)的时候调用[CALayer display]这个方法，然后进入视图的真正绘制过程
2.在[CALayer display]这个方法的内部实现中会判断这个layer的delegate是否响应displaylayer这个方法，如果不响应这个方法，就回到系统绘制流程中，如果响应这个方法，那么就会为我们提供异步绘制的入口
[self.layer.delegate displayLayer: ]
##### 异步绘制的实现
1、假如我们在某一时机调用了[view setNeedsDisplay]这个方法，系统会在当前runloop将要结束的时候调用[CALayer display]方法，然后如果我们这个layer代理实现了displaylayer这个方法
2、然后切换到子线程去做位图的绘制，主线程可以去做其他的操作
3、在自吸纳成中创建一个位图的上下文，然后通过CoregraphIC API可以做当前UI控件的一些绘制工作，最后再通过CGBitmapContextCreateImage()函数来生成一直CGImage图片
4、最后回到主线程来提交这个位图，设置layer的contents 属性，这样就完成了一个UI控件的异步绘制
具体做法：
先创建一个CALayer子类，重写display方法，添加displayAsync方法。这样只要外部创建添加了该layer后调用setNeedsDisplay方法，就会运行display方法。
在displayAsync方法中，我们创建了一个串行队列，添加了一个异步任务来画图片
##### 什么是离屏渲染
GPU渲染的结果要放到FrameBuffer中，但是如果因为某些原因**不能存到FrameBuffer中而是存到了其他地方，之后再写入framebuffer，就是离屏渲染**
另外，如果我们在UIView中实现了drawRect方法，就算它的函数体内部实际没有代码，系统也会为这个view申请一块内存区域（backingStore），等待CoreGraphics可能的绘画操作，因为像素数据是暂时存入了CGContext，而不是直接到了frame buffer，但是这个并不是离屏渲染。另一个证据是，如果你的view实现了drawRect，此时打开Xcode调试的“Color offscreen rendered yellow”开关，你会发现这片区域不会被标记为黄色，说明Xcode并不认为这属于离屏渲染。
**其实通过CPU渲染就是俗称的“软件渲染”，而真正的离屏渲染发生在GPU。**
WWDC说主要的渲染操作都是由CoreAnimation的Render Server模块完成，Render Server会遵循“画家算法”，按次序输出到frame buffer，后一层覆盖前一层，就能得到最终的显示结果。然而有些场景并没有那么简单。作为“画家”的GPU虽然可以一层一层往画布上进行输出，但是无法在某一层渲染完成之后，再回过头来擦除/改变其中的某个部分。所以对于某些显示数据，就不得不另开一块内存，借助这个临时中转区域来完成一些更复杂的、多次的修改/剪裁操作。
2018WWDC最佳图片使用：https://juejin.im/post/6844903618429059086
##### 离屏渲染
当前屏幕渲染：GPU的渲染操作是在用于当前屏幕显示的缓冲区进行的
离屏渲染：在当前缓冲区外开辟一个新的缓冲区进行渲染（这个是要尽量避免的）
离屏渲染代价高昂的原因：
1.开辟新的缓冲区
2.切换渲染的上下文。因为要从当前屏和离屏之间切换，涉及到上下文切换，这一部分很消耗时间，会消耗大量GPU资源，有可能会导致CPU+GPU处理时间超过1/60秒导致掉帧
离屏渲染触发条件：
1.设置layer.cornerRadius和masksToBounds
2.设置遮罩layer.mask
3.设置layer.opacity
4.设置layer.shadow
5.shouldRasterize（光栅化）
优化方案：
使用贝塞尔曲线UIBezierPath和Core Graphics框架画出一个圆角
UI流畅和优化相关的文章看YY的文章http://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/#6
##### UIButton的继承链
UIButton -> UIControl -> UIView -> UIResponder -> NSObject

##### 图层混合
当两个不完全透明的视图叠加在一起的时候(当alpha在0和1之间的时候)，GPU会做大量的计算，这种操作越多，那么消耗的性能越大。当alpha为1的时候，GPU会直接把最上层的渲染出来，不用换下面的图层

##### opaque的坑（opaque不透明）
opaque在苹果文档里有说明，如果opaque设置为YES，绘图系统会将view看为完全不透明，这样绘图系统就可以优化一些绘制操作以提升性能。如果设置为NO，那么绘图系统结合其它内容来处理view。默认情况下，这个属性是YES。
这个东西和图层混合的道理差不多，如果为NO（他是透明），那么系统会以为他盖住的layer也要展示，会做很多计算所以可以将opaque设置为YES
UIView是默认的YES，UIButton是NO
##### 光栅化
位图：图像没有被栅格化之前任意放大，都不会失帧。而栅格化化之后如果随着放大的倍数在增加，失帧会随着倍数的增加而增加。故：栅格化本身就是生成一个固定像素的图像。

光栅化概念：将图转化为一个个栅格组成的图象（就是位图，又称栅格图或点阵图）。
shouldRasterize = YES在其他属性触发离屏渲染的同时，会将光栅化后的内容缓存起来，如果对应的layer及其sublayers没有发生改变，在下一帧的时候可以直接复用。shouldRasterize = YES，这将隐式的创建一个位图，各种阴影遮罩等效果也会保存到位图中并缓存起来，从而减少渲染的频度
比如某个页面卡，可以开启光栅化。让位图缓存复用，如果能成功复用，就会有性能提升。性能的提升取决于多少被复用了。具体的复用在xcode的debug->viewDebuging里instrument看“Color Hits Green and Misses Red”
因此栅格化仅适用于较复杂的、静态的效果，别再TableView里用，离屏渲染过多性能消耗会得不偿失，而且有时候使用光栅化经常出现未命中缓存的情况

##### <span id="yibuhuizhi_jump">什么是异步绘制</span>
layer会创建backingStore获取上下文CGContextRef,
接下来判断是否有代理
如果有：
调用layer.delegate drawLayer:inContext:，
接着返回UIVew drawRect回调，让我们在系统绘制的基础上，再做一些其他的事情
如果没有：CALayer drawInContext
走完后，CALayer上传backingStore给GPU，结束

##### <span id="drawRect01_jump">drawRect为什么会出现内存暴增</span>
CALayer其实也只是iOS当中一个普通的类，它也并不能直接渲染到屏幕上，因为屏幕上你所看到的东西，其实都是一张张图片。而为什么我们能看到CALayer的内容呢，是因为CALayer内部有一个contents属性。contents默认可以传一个id类型的对象，但是只有你传CGImage的时候，它才能够正常显示在屏幕上。 所以最终我们的图形渲染落点落在contents身上如图
![](/images/drawRect01.png)
contents除了给它赋值CGImage之外，我们也可以直接对它进行绘制，实现drawRect方法即可自定义绘制。drawRect方法没有默认的实现，因为对UIView来说，contents并不是必须的，UIView不关心绘制的内容。
如果UIView检测到drawRect方法被调用了，它就会为视图分配一个content(寄宿图)这个寄宿图的像素尺寸等于视图大小乘以contentsScale(这个属性与屏幕分辨率有关，我们的画板程序在不同模拟器下呈现的内存用量不同也是因为它)的值。
因为重写了drawRect方法，drawRect方法就会自动调用。生成一张寄宿图后，方法里面的代码利用CoreGraphics去绘制，然后内容就会缓存起来，等待下次你调用-setNeedsDisplay时再进行更新。
视图的drawRect:方法的背后实际上都是底层的CALayer进行了重绘和保存中间产生的图片，CALayer的delegate属性默认实现了CALayerDelegate协议，当它需要内容信息的时候会调用协议中的方法来拿。当画板视图重绘时，因为它的支持图层CALayer的代理就是画板视图本身，所以支持图层会请求画板视图给它一个寄宿图来显示，它此刻会调用：(这部分可以看看[异步绘制](#yibuhuizhi_jump)，很像)
```
- (void)displayLayer:(CALayer *)layer;
```
如果画板视图实现了这个方法，就可以拿到layer来直接设置contents寄宿图，如果这个方法没有实现，支持图层CALayer会尝试调用：
```
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
```
(其实这一部分就是异步绘制的步骤)
这个方法调用之前，CALayer创建了一个合适尺寸的空寄宿图（尺寸由bounds和contentsScale决定）和一个Core Graphics的绘制上下文环境，为绘制寄宿图做准备，它作为ctx参数传入。在这一步生成的空寄宿图内存是相当巨大的，它就是本次内存问题的关键，一旦你实现了CALayerDelegate协议中的-drawLayer:inContext:方法或者UIView中的-drawRect:方法（其实就是前者的包装方法），图层就创建了一个绘制上下文，这个上下文需要的内存可从这个公式得出：图层宽*图层高*4 字节，宽高的单位均为像素。图层每次重绘的时候都需要重新抹掉内存然后重新分配。它就是我们画板程序内存暴增的真正原因。
https://blog.csdn.net/shihuboke/article/details/75195524
**解决办法：**
最合理的办法处理类似于画板这样画线条的需求直接用专有图层CAShapeLayer。
CAShapeLayer是一个通过矢量图形而不是bitmap来绘制的图层子类。用CGPath来定义想要绘制的图形，CAShapeLayer会自动渲染。它可以完美替代我们的直接使用Core Graphics绘制layer，对比之下使用CAShapeLayer有以下优点
- 渲染快速。CAShapeLayer 使用了硬件加速，绘制同一图形会比用 Core Graphics 快很多。
- 高效使用内存。一个 CAShapeLayer 不需要像普通 CALayer 一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
- 不会被图层边界剪裁掉。
- 不会出现像素化。

**总结一下绘制性能优化原则：**
- 绘制图形性能的优化最好的办法就是不去绘制。
- 利用专有图层代替绘图需求。
- 不得不用到绘图尽量缩小视图面积，并且尽量降低重绘频率。
- 异步绘制，推测内容，提前在其他线程绘制图片，在主线程中直接设置图片。
******************************************************************************
#### 性能优化
##### 如何高性能的画一个圆角
视图和圆角的大小对帧率并没有什么卵影响，数量才是伤害的核心输出
如果能够只用cornerRadius解决问题，就不用优化。
如果必须设置masksToBounds，可以参考圆角视图的数量，如果数量较少(一页只有几个)也可以考虑不用优化
最后可以用贝塞尔曲线画圆角CoreGraphics
##### 如何对代码进行性能优化
静态分析Analyze
debug->View Debuging里可以看离屏渲染，图层混合等等
还有在Instrument里找对应的需要优化的选项CoreAnimation里看CPU/GPU的使用率，帧数等等，Leak看泄露，僵尸对象
##### TableView的优化
*一个页面展示的会耗时的部分：
UIImage->DataBuffer->ImageBuffer->UIImageView->Render
DataBuffer到ImageBuffer的这个过程，就是Decode过程。DataBuffer代表了图片文件在内存中的表示，是图片的元数据，不同格式的图片文件有不同的编码格式，而ImageBuffer代表了图片在内存中的表示，每个元素代表一个像素点的颜色，ImageBuffer大小与图像大小成正比。而Decode是一个CPU密集的操作，而且大小和图片原始大小有关，和View无关，所以，优化的思路就是在Decode部分
所以可以在异步线程里进行图片缩减，这样可以大大的减少内存的消耗，提高运算速度。鉴于页面是CollectionView来实现，可以实现一个prefetching这个代理，实现他的代理方法。在这个方法里，异步使用压缩，再将原来的那个图片切图里的GraphicsBeginImageContext改成苹果推荐的GraphicsImageRender。在Prefetching里使用异步方法一定要用串行队列，因为滑动的快，并行队列会疯狂加线程，速度反而会下降。在prefetching其实还可以干很多事，他的设计思想就是在里面处理各种麻烦的数据
1.CPU对视图进行Frame等的各种计算
2.提交给GPU进行渲染
3.图片的解码等
4.打包图层并将它们发送到RenderServer
优化也是随着这几个展开
1.预排班，网络请求数据回来后在子线程中对布局的frame进行计算
2.预解码：
针对的是图片加载。图片从磁盘加载过来是由DataBuffer(通过压缩算法得到的二进制数据，比如jpeg,png)，然后decode解码到像素缓冲区ImageBuffer。这个decode可能会很耗时，可以放到异步线程中去(电子书那个加圆角问题)
3.按需加载：
通过runloop，孙源的分享里有提到过，监听runloop的状态，因为滑动会切换mode，当runloop到了beforwaiting的时候，再开始加载。不过这个方法有个坑爹的效果就是快速滑动的时候会有很多的空白（应该是setModel在performdelay里设置）
4.减少图层层级：
（上面三个都难以解决的时候，可以用这个）
CPU在计算的时候会很慢。可以吧这个东西画成一张图
5.异步渲染
##### UIImage加载图片性能问题
imageNamed系统会缓存，imageWithContentsOfFile不会，所以小图可以用imageName,如果大图还用会内存长得快

不要在UIImageView使用的时候去缩放图片，你应保证图片的大小和UIImageView的大小相同，在ScrollView搞这个东西非常耗性能，如果一个图片需要缩放，最好在子线程中缩放好了再给他放到UIImageView里（绘本优化的时候遇到过）
##### 如何检测应用是否卡顿
```
while (YES) {   
    // 有信号的话 就查询当前runloop的状态
    // 假定连续5次超时50ms认为卡顿(当然也包含了单次超时250ms)
    // 因为下面 runloop 状态改变回调方法runLoopObserverCallBack中会将信号量递增 1,所以每次 runloop 状态改变后,下面的语句都会执行一次
    // dispatch_semaphore_wait:Returns zero on success, or non-zero if the timeout occurred.        
    long st = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
    ....
```
开启一个子线程，通过信号量每50ms就会ping一次主线程的状态。当主线程状态没变的时候，连续几次都是，那么就是卡顿了
##### 容错处理你们一般是注意哪些？
？？？
##### 如何防止拦截潜在的崩溃？
runtime消息转发？？？
不需要拦截
##### 内存告急的处理
释放缓存，image的问题，节约内存

#### 内存优化
##### 内存优化
https://juejin.im/post/6844903621276991502#heading-19
drawRect内存暴增优化，可以使用CAShapeLayer（[drawRect内存问题](#drawRect01_jump)）
使用autoReleasepool
收到内存警告的时候清除不必要的内存
不要用imageNamed，用contentFile
后台的图片最好越小越好，这个和图片分辨率有关
注意循环引用，内存泄漏

#### 启动优化


##### 二进制重排
一些理论基础：
cpu寻址过程
引入虚拟内存后,cpu在通过虚拟内存地址访问数据的过程如下:
1.通过虚拟内存地址,找到对应进程的映射表.
2.通过映射表找到其对应的真实物理地址,进而找到数据.
这个过程被称为地址翻译,这个过程是由操作系统以及cpu上集成的一个硬件单元MMU协同来完成的 
虚拟内存和物理内存通过映射表进行映射，但是这个映射并不可能是一一对应的，那样就太过浪费内存了，为了解决效率问题，实际上真实物理内存是分页的，而映射表同样是以页为单位的
iOS近期的系统中，基于A7和A8处理器的系统，物理内存按照4KB分页，虚拟内存按照16KB分页。基于A9处理器的系统，物理和虚拟内存都是以16KB进行分页。系统将内存页分为三种状态。
当应用被加载到内存中时，并不会将整个应用加载到内存中，只会放用到的那一部分，也就是懒加载的概念，换句话说就是应用使用多少，实际物理内存就实际存储多少，
当应用访问到某个地址，映射表中为，也就是说并没有被加载到物理内存中时，系统就会立刻阻塞整个进程，触发一个我们所熟知的缺页中断 - Page Fault .
当一个缺页中断被触发，操作系统会从磁盘中重新读取这页数据到物理内存上，然后将映射表中虚拟内存指向对应
二进制重排：
App启动的时候会加载很多的类，分类，库等等到内存中，所以Page Fault越多，那么耗时就越大。举个栗子：
Page1:              Page2:
Method1             Method5
Method2             Method6
Method3             Method7
Method4             Method8
比如在启动的时候需要Method1和Method8，那么分别在两个不同Page上的，现在已经加载了Page1，需要Page2的Method8，从而触发1次中断
实际项目中的做法是将启动时需要调用的函数放到一起(比如前10页中)以尽可能减少page fault, 达到优化目的.而这个做法就叫做:二进制重排
查看中断可以在Instrument的System Trace里看
重排方法：
我们可以通过这个参数配置一个.order类型的文件，把要重排的数据放里面，xcode里有配置可以使用这个.order文件
不能用hook Objc_msgSend。因为hook无法捕捉c++,block，还有swift，得用clang插桩来获取符号表
获取启动加载所有函数的符号(clang插桩覆盖)：
先解释Clang插桩：Clang是轻量级编译器，插桩是在保证被测程序原有逻辑完整性的基础上在程序中插入一些代码段（比较像hook，加入一些自己东西）
静态插桩实际上是在编译期就在每一个函数内部二进制源数据添加hook代码(我们添加的__sanitizer_cov_trace_pc_guard函数)来实现全局的方法hook的效果，从而获取启动时的函数
根据代码的注释，大概意思是：
函数执行前会将下一个要执行的函数地址保存到寄存器中，拿到函数的返回地址，   然后通过动态库拿到句柄，通过句柄拿到函数的内存地址，通过函数内存地址拿到函数。靠这样拿到最后启动时候函数的符号表
clang静态插桩坑点:
1.多线程的问题,可能会影响最后函数的搜集，可以用苹果的原子队列<OSAtomic.h>（先进后出，线程安全，只能保存结构体）
2.load方法拿不到
3.去重
其实坑点不少，但是都可以找到对应的方法
swift工程/混编工程问题和纯的OC工程不太一样，swift工程需要单独配置一下
完整的教程，包含了代码
http://www.zyiz.net/tech/detail-127196.html
https://mp.weixin.qq.com/s?__biz=MzA5NzMwODI0MA==&mid=2647766465&idx=1&sn=e9598765d3314a0d17dc98069344b6a2&chksm=8887cefebff047e8c92f8c97e1b517e6fe7521a5efc83bb80d99edbd12ae7dab9fc416961962&scene=21#wechat_redirect
最后二进制重排后的时间还是在pageFault里可以查看



******************************************************************************
### 第三方库
##### MLeaksFinder原理
为基类 NSObject 添加一个方法 -willDealloc 方法，该方法的作用是，先用一个弱指针指向 self，并在一小段时间(3秒)后，通过这个弱指针调用 -assertNotDealloc，而 -assertNotDealloc 主要作用是直接中断言。
```
- (BOOL)willDealloc {
    __weak id weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf assertNotDealloc];
    });
    return YES;
}
- (void)assertNotDealloc {
     NSAssert(NO, @“”);
}
```
##### YYCache和SD缓存策略（设计一个缓存）
磁盘缓存的文件夹是Cache文件夹
YYCache：
通过Memory和Disk来进行缓存
对于缓存内容的增删改查要同步进行（加锁）
查的过程中先查memory再查Disk
接下来就是缓存策略
Memory缓存因为缓存的数据大小有限，所以要注意设置缓存的大小，时间限制，缓存对象的个数等等限制，还要注意监听内存warning
然后就是如何能快速查找，可以使用Dic，在淘汰的时候，使用的是LRU算法进行淘汰
Disk分为File，SQLITE存储，还有MIX，是通过设置的存储对象的大小来判断，这里面没有什么复杂的内容，就是加锁，存，解锁
但是对于数据库的 wal 模式”、“数据库 synchronous 的模式选择与区别”不太明白。只知道是加锁
随后还要设置一个定时的缓存清理，每间隔60s或者一个自定义事件，对比一下自己设置的缓存大小，时限，个数等等，对超过数值的缓存进行清理
SDWebImage:
SDWebImage使用NSCache类来实现内存缓存。
在加载图片的时候，SDWebImage调用SDImageCache先读取内存缓存，如果内存缓存没有，就会使用GCD开启异步线程去读取磁盘缓存，如果找到磁盘缓存，则同步到内存缓存中去，使用GCD在主线程中设置图片，如果都没有，下载后会缓存到内存和磁盘上(可选)。
SDWebImage 默认会有一个对上次加载失败的图片拒绝再次加载的机制。 也就是说，一张图片在本次会话加载失败了，如果再次加载就会直接拒绝。(额外知识)
SDWebImage 会在每次 APP 结束的时候执行清理任务。 清理缓存的规则分两步进行。 第一步先清除掉过期的缓存文件。 如果清除掉过期的缓存之后，空间还不够。 那么就继续按文件时间从早到晚排序，先清除最早的缓存文件，直到剩余空间达到要求。具体点，SDWebImage 是怎么控制哪些缓存过期，以及剩余空间多少才够呢？maxCacheAge是文件缓存的时长,maxCacheAge 的默认值，注释上写的很清楚，缓存一周,SDWebImage 在默认情况下不会对缓存空间maxCacheSize设限制。分别在应用进入后台和结束的时候，遍历所有的缓存文件，如果缓存文件超过 maxCacheAge 中指定的时长，就会被删除掉。(额外知识)

##### SD里在查询磁盘的时候为什么会有一个ioQueue(SD怎么保证查找安全)
一个async(ioQueue)实现，一个串行队列，保证当前只有一个任务操作磁盘

##### SD查找Disk为什么要autoreleasepool
因为查询磁盘差的是NSData，得到一个UIImage，转换的时候会出现大量的临时变量

##### SD如何判断是JPEG，PNG，或者其他格式的？
通过二进制码，在磁盘缓存的时候拿到的是NSData，然后通过前缀0xFF,0x89等待，判断图片的格式

##### SD是怎么做到URL不变，但是图片变化，让图片也变化的？
在完成了拿图片之后，有一个RefreshCache的枚举，里面有提到CacheControl。这个东西可以在ResponseHeader里看到（青花瓷抓包）
cache-control: max-age=31536000
last-modified: Tue, 26 Mar 2019 14:16:09 GMT
这俩就是这个问题的关键
如果last-modified在事件内，是不会请求的，直接用缓存，主要就是设置“If-Modified-Since”
这个字段得要后台支持，因为在Response的Header里

##### SD为什么要重写NSOperation
重写start方法要设置一些ResponseCache里的一些东西，是否要保存responseCache

******************************************************************************
### 编译，链接，App启动
##### +load方法在Mach-O的哪个数据段
![](/images/macho01.png)
Header:
包含该二进制文件的一般信息包含：
- 字节顺序
- 架构类型
- 加载指令的数量等。
```
struct mach_header_64 {
    uint32_t    magic;              /* mach magic 标识符 */
    cpu_type_t    cputype;          /* CPU 类型标识符，同通用二进制格式中的定义 r */
    cpu_subtype_t    cpusubtype;    /*  CPU 子类型标识符，同通用二级制格式中的定义  */
    uint32_t    filetype;           /* 文件类型  */
    uint32_t    ncmds;              /* 加载器中加载命令的条数  */
    uint32_t    sizeofcmds;         /* 加载器中加载命令的总大小 */
    uint32_t    flags;              /* dyld 的标志 */
}
```
Load commands:
一张包含很多内容的表,内容包括:
- 区域的位置
- 符号表（这里解释下符号表：符号表是一种用于语言翻译器（例如编译器和解释器）中的数据结构。在符号表中，程序源代码中的每个标识符都和它的声明或使用信息绑定在一起，比如其数据类型、作用域以及内存地址，如常数表、变量名表、数组名表、过程名表、标号表等等，统称为符号表。）
- 动态符号表等
  
描述了文件中数据的具体组织结构，不同的数据类型使用不同的加载命令表示。
loadCommands中记录了很多信息,包括动态链接器(比如dyld)的位置,程序的入口地址(main),依赖库的信息,代码的位置.符号表的位置等等.
![](/images/macho02.png)

DATA：
Mach-O的Data区域由Segment段和Section节组成。
先来说Segment的组成，
```
#define SEG_PAGEZERO    "__PAGEZERO" /* 当时 MH_EXECUTE 文件时，捕获到空指针 */
#define SEG_TEXT    "__TEXT" /* 代码/只读数据段 */
#define SEG_DATA    "__DATA" /* 数据段 */
#define SEG_OBJC    "__OBJC" /* Objective-C runtime 段 */
#define SEG_LINKEDIT    "__LINKEDIT" /* 包含需要被动态链接器使用的符号和其他表，包括符号表、字符串表等 */
```
Segment（主要指的__TEXT和__DATA可以进一步分解为Section：
```
struct section_64 { 
    char        sectname[16];   /* Section 名字 */
    char        segname[16];    /* Section 所在的 Segment 名称 */
    uint64_t    addr;       /* Section 所在的内存地址 */
    uint64_t    size;       /* Section 的大小 */
    uint32_t    offset;     /* Section 所在的文件偏移 */
    uint32_t    align;      /* Section 的内存对齐边界 (2 的次幂) */
    uint32_t    reloff;     /* 重定位信息的文件偏移 */
    uint32_t    nreloc;     /* 重定位条目的数目 */
    uint32_t    flags;      /* 标志属性 */
    uint32_t    reserved1;  /* 保留字段1 (for offset or index) */
    uint32_t    reserved2;  /* 保留字段2 (for count or sizeof) */
    uint32_t    reserved3;  /* 保留字段3 */
};
```


所以结论应该是在load command里

##### 编译链接的过程
1.预处理：把宏替换，删除注释，展开头文件，产生 .i 文件。
2.编译：把之前的 .i 文件转换成汇编语言，产生 .s文件。
3.汇编：把汇编语言文件转换为机器码文件，产生 .o 文件。
4.链接：在一个文件中可能会到其他文件，因此，还需要将编译生成的目标文件和系统提供的文件组合到一起，这个过程就是链接。经过链接，最后生成可执行文件
##### <span id="AppLaunch_jump">App的启动过程</span>
https://www.cnblogs.com/lxlx1798/p/9256649.html
iOS中用到的所有系统framework都是动态链接的，类比成插头和插排，静态链接的代码在编译后的静态链接过程就将插头和插排一个个插好，运行时直接执行二进制文件；而动态链接需要在程序启动时去完成“插插销”的过程，所以在我们写的代码执行前，动态连接器需要完成准备工作。

1.准备启动，系统调用exec()函数，载入可执行文件Mach-O
2.完成了初始化准备工作后，启动dyld。dyld作用：
    1.从kernel留下的原始调用栈引导和启动自己(调用dyldbootstrap::start()方法)
    2.动态链接库和可执行文件递归载入到内存中（imageLoader）,链接可执行文件
    3.找到main函数，准备参数并调用(返回了main函数地址，填入参数并调用main函数)
![](/images/dyld_01.jpg)
dyld通过ImageLoader开始加载libSystem，可以看到栈中出现了libSystem_initializer的初始化方法。libSystem包含了很多系统级别lib，列几个熟知的：libdispatch(GCD)，libsystem_c(C语言库)
当libSystem_initializer逐步调用到了_objc_init，这里就是objc和runtime的初始化入口。除了runtime环境的初始化外，_objc_init中绑定了新image被加载后的callback
![](/images/dyld_02.jpg)
可见dyld担当了runtime和ImageLoader中间的协调者，当新image加载进来后交由runtime大厨去解析这个二进制文件的符号表和代码。
过程大概就是：
1.dyld开始将程序二进制文件初始化
2.交由ImageLoader读取image，其中包含了我们的类、方法等各种符号
3.由于runtime向dyld绑定了回调，当image加载到内存后，dyld会通知runtime进行处理
4.runtime接手后调用map_images做解析和处理，接下来load_images中调用call_load_methods方法，遍历所有加载进来的Class，按继承层级依次调用Class的load方法和其Category的load方法（load方法，category就是在这个时候加入的）。至此，可执行文件中和动态库所有的符号（Class，Protocol，Selector，IMP，…）都已经按格式成功加载到内存中，被runtime所管理，再这之后，runtime的那些方法（动态添加Class、方法混合等等才能生效）
##### 重载load时需要手动添加@autoreleasepool么
不需要，在runtime调用load方法前后是加了objc_autoreleasePoolPush()和objc_autoreleasePoolPop()的。
*************
### 其他
##### 单例和全局变量的区别
单例整个进程唯一一份，全局变量可以多次初始化
##### 苹果如何实现远程推送的
1.应用服务提供商从服务器端把要发送的消息和设备令牌(Token啊，令牌啥的用户信息)发送给苹果的消息推送服务器 。
2.根据设备令牌在已注册的设备(iPhone、iPad、iTouch、mac 等)查找对应的设备，将消息发送给相 应的设备。 
3.客户端设备接将接收到的消息传递给相应的应用程序，应用程序根据用户设置弹出通知消息。
##### dealloc中用weakSelf的结果是什么
```
- (void)dealloc {
    __weak __typeof(self) weakSelf = self;
    NSLog(@"%p", weakSelf);
}
```
会crash，原因是这么写会在dealloc的时候会调用storeWeak,进行注册弱引用表,此时会判断是否是正在释放阶段并且如果在在释放就crash
源码
```
//weak_register_no_lock方法
if (deallocating) {
        if (crashIfDeallocating) {
            _objc_fatal("Cannot form weak reference to instance (%p) of "
                        "class %s. It is possible that this object was "
                        "over-released, or is in the process of deallocation.",
                        (void*)referent, object_getClassName((id)referent));
        } else {
            return nil;
        }
    }
```
*************


## 一些好的网址
##### runloop完全文章
https://www.jianshu.com/p/215db502b09d
##### APM
https://juejin.im/post/5ef6930fe51d4534a361530a?utm_source=gold_browser_extension#heading-32
##### 大厂面试题
https://www.jianshu.com/p/89978870f49f
##### 一个面试题集
https://www.jianshu.com/p/e709fde38de3