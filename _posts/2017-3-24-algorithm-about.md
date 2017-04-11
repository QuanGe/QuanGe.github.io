---
layout: post
title: iOS装13-之数据结构与算法
---

# 全栈 数据结构与算法

先上图

![搞笑](https://raw.githubusercontent.com/QuanGe/QuanGe.github.io/master/images/just_do_it.png)

看到上图有什么感慨？是不是很冲动。如果只是干，不思考，那我们又与机器有何分别（虽然在老板眼里我等真的只是机器）。

那么数据结构与算法到底有啥用呢？这就好比古代打仗，数据结构就好比我们的兵器，算法就好比是招式，如果你两者都没有就好比普通人没有武功修为。

来来来，古话有云，是骡子是马拉出来溜溜，耍两下瞅瞅。

开始之前先问自己几个问题

1、数组与链表的区别，为什么C++之父本贾尼·斯特劳斯特卢普(Bjarne Stroustrup)说要尽量避免使用链表？

2、你在平常的编程中哪些用到了栈，哪些用到了队列，哪里又用到了二叉树

3、你都知道有哪些排序方法，哪些是稳定的排序，说说各个方法的实现的流程。

4、散列（字典）中查找的时间复杂度是多少


## 链表

数据结构这门课老师第一个将的肯定是链表，而且是与数组对比着来讲的。我也来列举一二

1、创建：一般创建一个数组很简单，比如int[5],这个5就是数据的容量，如果数组满了，还需要增加元素需要扩容。而链表不需要指定容量。但是，数组在占用内存方面要比链表要少哦，因为链表要实现一个结构体，结构体里除了要有一个数据的变量还需要一个next指针。
2、增：在数组中间插入一条数据，后面的要后移。在链表中插入一条数据，要先找到要插入的位置的元素，然后将next的元素交给要插入的元素，然后再将自己的next元素指向要插入的元素
3、删：复杂程度同上
4、改：数组中修改某个值直接修改就好。链表要找到该位置的元素，然后再修改。
5、查：数组直接可以拿到某位置的元素。链表要查找。
6、遍历：由于数组的数据都是存在连续的内存，而链表的数据比较分散，所以在遍历的时候，在CPU的性能来讲，数组更能利用CPU的缓存(一般一级缓存是64k)来进行计算来提高性能。而链表比较分散，很大几率上就会用不上CPU的缓存了。


由上面可见，链表除了在容量方面有可取之处外，没有什么可以可取的了么？同学你难道忘记了双向链表了么？另外你忘记了还有一种数据结构叫做树哦，对于不是二叉树的树，数组是不能满足要求的哦。所以我们要尽量避免使用链表。所以说当你放在容器中的数据之间没有任何关系的时候，最好选择数组。

[C++之父的视频点这里](http://v.youku.com/v_show/id_XNzE0ODM2NzUy.html#0-sqq-1-47421-9737f6f9e09dfaf5d3fd14d775bfee85)

## 栈

栈：先进后出。可以用数组和链表实现.内存是我们程序员接触最频繁的计算机硬件之一（其次就是cpu了）。内存,一部分划分给操作系统使用，一部分给程序使用，说到系统我们必须提到VMA（Virtual Memory Area），操作系统通过给进程空间划分出一个个VMA来管理进程的虚拟空间。 一个进程的虚拟空间基本可以分为四种：栈（stack）VMA、堆（heap）VMA、代码VMA、数据VMA，各部分相关可以参考以下链接

[stackoverflow链接一](http://stackoverflow.com/questions/408670/stack-static-and-heap-in-c)

[stackoverflow链接二](http://stackoverflow.com/questions/79923/what-and-where-are-the-stack-and-heap)

栈VMA 中一般存放 函数参数、函数返回地址、局部变量

堆VMA 中一般存放 new 或者alloc 出来的内存里的内容

数据VMA 一般存放全局变量、静态变量、常量 就是一般不会变化的。

代码VMA 就是代码指令区域 


函数调用是用栈来操作的，我们下面来分析下，增加一下印象。我们用c++写一段代码，然后汇编一下，看汇编的内容。首先，用Xcode来新建一个C++项目。在main.cpp中代码如下

```
#include <iostream>

int quange_add(int i,int j,int k)
{
    i = i +1000;
    j = j +3000;
    k = k + 2000;
    return i+j + k;
}
int main() {
    int a = 5 ;
    int b = 6 ;
    int d = 11;
    int c = quange_add(a,b,d);
    printf("%d",c);
    return 0;
}

```

然后Xcode-》Product-》Perform Action-》Assemble "main.cpp" (注意由于Xcode用的GCC[GNU Compiler Collection]编译器,所以生成的汇编文件是AT&T标准的，与我们大学学的汇编稍微有点不同)，内容如下：

```

.globl  __Z10quange_addiii
    .align  4, 0x90
__Z10quange_addiii:                     ## @_Z10quange_addiii
Lfunc_begin0:
## BB#0:
    pushq   %rbp
Ltmp0:
Ltmp1:
    movq    %rsp, %rbp
Ltmp2:
    movl    %edi, -4(%rbp)
    movl    %esi, -8(%rbp)
    movl    %edx, -12(%rbp)
Ltmp3:
    movl    -4(%rbp), %edx
    addl    $1000, %edx             ## imm = 0x3E8
    movl    %edx, -4(%rbp)
    movl    -8(%rbp), %edx
    addl    $3000, %edx             ## imm = 0xBB8
    movl    %edx, -8(%rbp)
    movl    -12(%rbp), %edx
    addl    $2000, %edx             ## imm = 0x7D0
    movl    %edx, -12(%rbp)
    movl    -4(%rbp), %edx
    addl    -8(%rbp), %edx
    addl    -12(%rbp), %edx
    movl    %edx, %eax
    popq    %rbp
    retq
Ltmp4:
Lfunc_end0:
    .globl  _main
_main:                                  ## @main
Lfunc_begin1:
## BB#0:
    pushq   %rbp
Ltmp5:
Ltmp6:
    movq    %rsp, %rbp
Ltmp7:
    subq    $32, %rsp
    movl    $0, -4(%rbp)
Ltmp8:
    movl    $5, -8(%rbp)
    movl    $6, -12(%rbp)
    movl    $11, -16(%rbp)
    movl    -8(%rbp), %edi
    movl    -12(%rbp), %esi
    movl    -16(%rbp), %edx
    callq   __Z10quange_addiii
    leaq    L_.str(%rip), %rdi
    movl    %eax, -20(%rbp)
    movl    -20(%rbp), %esi
    movb    $0, %al
    callq   _printf
    xorl    %edx, %edx
    movl    %eax, -24(%rbp)         ## 4-byte Spill
    movl    %edx, %eax
    addq    $32, %rsp
    popq    %rbp
    retq
Ltmp9:
Lfunc_end1:
L_.str:                                 ## @.str
    .asciz  "%d"

```

上面代码是我去掉调试信息之后之后的。在讲解代码之前我们要说一下CPU的寄存器。搬一下王爽老师的课本内容吧。

##### CPU寄存器

一个典型的CPU（此处讨论的不是某一具体CPU）由运算器、控制器、寄存器（CPU工作原理）的器件构成，这些器件考内部总线相连。简单地说，在CPU中：运算器进行信息处理，寄存器进行信息存储，控制器控制各种器件进行工作，内部总线连接各种器件，在它们之间进行数据的传送。对于一个汇编程序员来说，CPU中的主要部件是寄存器。寄存器是CPU中程序员可以用指令读写的部件，程序员通过改变各种寄存器中的内容来实现对CPU的控制。常用的寄存器有:

AX:累加器(accumulator) ，加法乘法的缺省寄存器

BX、基地址(base)寄存器，在内存寻址时存放基地址

CX、计数器(counter), 是重复(REP)前缀指令和LOOP指令的内定计数器。

DX、则总是被用来放整数除法产生的余数。

SI、源索引（source index）寄存器，在很多字符串操作指令中,DS:ESI指向源串

DI、目标索引（destination index）寄存器，在很多字符串操作指令中,ES:EDI指向目标串.

SP、栈顶寄存器

BP、栈底寄存器

IP、寄存器存放下一个CPU指令存放的内存地址，当CPU执行完当前的指令后，从IP寄存器中读取下一条指令的内存地址，然后继续执行。

CS、Code segment 

SS、Stack segment

DS、Data segment

ES、Extra segment pointer

##### CPU指令

`mov` CPU的寄存器与内存的数据 交换的指令。可以让寄存器读取内存的内容 也可以讲寄存器的内容写回到内存中
`sub` 减操作
`add` 加操作
`push` 相当于sp-2 和mov 啥 到sp中。即先将栈顶寄存器减2个字节 然后将push的对象的值 放到现在栈顶寄存器的位置 （参考 王爽老师的 汇编语言第三版 p59）
`pop` 与上面相反 栈顶寄存器加操作，将内存的内容 放到pop的对象 中 
`lea` 与mov类似，只不过mov是将值给另外一个，而lea将地址传递。

##### 继续上面代码分析

再来说说函数的参数传递技术，其实函数的参数可以通过三种方式：1、寄存器、2、全局变量、3、栈。

这里主要讨论栈。来看看main函数中，首先执行的是`pushq   %rbp`（这里如果是32位的话是erb），将栈底寄存器的值放入内存的栈中,这里也称为old rbp，意思将原来的erb，放在内存的栈中，等函数执行结束的再pop，保证rbp不变化。

然后是`movq    %rsp, %rbp` 将rsp之前的栈顶指针赋值给当前的栈底指针，注意因为之前已经保存rbp的值，所以这里的rbp可以随便弄喽，给它赋个值。为啥要这样做呢？举个例子函数A调用B是先将B函数用的参数压入栈，然后通过`call B`将B的返回地址压入栈。在B中如果计算需要知道B的参数的值如果通过pop的操作，则必须要先pop 函数B的返回地址，这样B的返回地址就丢失了，于是程序采用另外一种技术通过rsp的位移操作来获取函数B的参数，而rsp可能后续还会操作，所以先赋值给rbp。这样就可以通过rbp的位移来获取参数。一般`-4(%rbp)`指的就是压入栈的第一个值 `-8(%rbp)`指的是压入栈的第二值。

然后是`subq    $32, %rsp`是将rsp寄存器减去32个byte。一般栈从高地址向低地址的。所以减去32byte相当于划了32个byte给栈使用。注意这里为啥要sub，因为我们下面不是push pop 来交换数据，所以就要手动的来操作rsp。如果不进行如此操作，进入__Z10quange_addiii函数后又不是用push pop，就会造成污染。所以必须移动一下rsp。以保证再调用函数的时候数据不会污染。


然后是`movl    $0, -4(%rbp)` 因为rbp是栈底，所以-4(%rbp)是压入的第一值，这里将0压入栈

`movl    $5, -8(%rbp)`将5压入栈

`movl    $6, -12(%rbp)`将6压入栈

`movl    $11, -12(%rbp)`将11压入栈

`movl    -8(%rbp), %edi`将第二个压入栈的值赋值给edi寄存器

`movl    -12(%rbp), %esi`将第三个压入栈的值赋值给esi寄存器

`movl    -16(%rbp), %edx`将第四个压入栈的值赋值给edx寄存器

`callq   __Z10quange_addiii`调用函数quange_add

进入quange_add继续看

仍然是`pushq   %rbp` 现保存之前的rbp，然后 `movq    %rsp, %rbp`将rsp赋值给rbp，因为上面已经将rsp后移了，所以这里rbp，也是后移32之后。这样下面再通过rbp移位操作时不会有冲突。

`movl    %edi, -4(%rbp)`将上面main中的%edi的寄存器中的值赋值给-4(%rbp) 

`movl    %esi, -8(%rbp)`将%esi的寄存器中的值赋值给-8(%rbp) 

`movl    %edx, -12(%rbp)`将%edx的寄存器中的值赋值给-12(%rbp)

`movl    -4(%rbp), %edx`将-4(%rbp)的值即edi的值赋值给edx


`addl    $1000, %edx`将edx的内容加1000，即将edi的值+1000.即5+1000

`movl    %edx, -4(%rbp)`将edx的内容赋值给-4(%rbp)即，栈中第一个值为1005

`movl    -8(%rbp), %edx`将-8(%rbp) 即esi 赋值给edx

`addl    $3000, %edx `将edx的值+3000，即esi 6+3000

`movl    %edx, -8(%rbp)`将edx的值再赋值给-8(%rbp)即，栈中第二个值为3006

`movl    -12(%rbp), %edx`将-12(%rbp)即11 赋值给edx

`addl    $2000, %edx  `将edx中的值+2000 即11+2000=2011

`movl    %edx, -12(%rbp)`将edx中的值赋值给-12(%rbp)，即栈中第三个值为2011

`movl    -4(%rbp), %edx`将栈中第一个值再赋值给edx，利用edx来进行加值操作

`addl    -8(%rbp), %edx`将edx中的值加上栈中第二个值

`addl    -12(%rbp), %edx`将edx中的值加上栈中第三个值，此时edx为三个数的和。

`movl    %edx, %eax` 将edx的值赋值给eax，一般来讲我们用eax来做返回值的寄存器

`popq    %rbp` 弹出rbp。将rbp恢复原来的值。即main中的rbp的值。

`retq`跳出函数，这里返回到main中了。

`leaq    L_.str(%rip), %rdi` 将L_.str的地址赋值给rdi

`movl    %eax, -20(%rbp)`将上面__Z10quange_addiii返回的内容压入栈中

`movl    -20(%rbp), %esi`将刚才压入栈中的值赋给esi

`movb    $0, %al` al = 0

`callq   _printf` 调用printf 函数，参数通过esi传入

`xorl    %edx, %edx`通过异或运算清零edx

`movl    %eax, -24(%rbp) `将eax压入栈

`movl    %edx, %eax` 返回值eax 赋值为edx即0

`addq    $32, %rsp` rsp寄存器+32 ，与前面减呼应。复位rsp

`popq    %rbp` 将内存栈中之前压入的rbp的值 弹出到rbp

`retq` 跳出函数 结束

好了，所有汇编代码都分析完了，累死了。参考《汇编语言》《程序员的自我修养 --链接、装载与库》《Professional Assembly Language》


另外栈还有一个用处 四则运算表达式求值

## 队列

我这没啥要说的啊 就跟排队打饭似的，排在前面的先给呗

## 二叉树 

应该说二叉树在数据结构中是应用最广的了，如果你连二叉树都不知道那就呵呵了。

二叉树（Binary Tree）：每个结点最多有两颗子树，左子树和右子树是有顺序的，即使只有一棵树也要区分是左子树还是右子树

满二叉树：所有分支结点都存在左子树和右子树，并且所有叶子都在同一层上。

完全二叉树： 心中默默给每个结点按照满二叉树的结构逐层顺序编号，如果编号出现空档则不是完全二叉树，否则就是。

二叉排序树（二叉查找树）：若他的左子树不为空，则左子树上的所有结点的值均小于它的根结点的值；若右子树不为空，则右子树上的所有结点的值均大于它的根结点的值；它的左右子树叶分别满足上述条件。注意，构造一棵二叉排序树的目的并不是为了排序，而是为了提高查找和插入删除关键字的速度。

二叉平衡树：首先是个二叉排序树，其次左右子树的高度差至多为1，也就是左子树的高度减去右子树的高度即BF（Balance Factor）只能是-1、0、1。如果某结点BF大于1，则顺时针旋转，如果小于1，则逆时针旋转。查找时间复杂度是O(logn),插入和删除也为O(logn).

红黑树：首先它是个二叉排序树。五个性质：1. 节点是红色或黑色 。2、根是黑色 。3. 所有叶子都是黑色（叶子是NIL节点）。4、每个红色节点的两个子节点都是黑色。5. 从任一节点到其每个叶子的所有简单路径 都包含相同数目的黑色节点。


平衡树和红黑树在查找、插入、删除时间复杂度一致，只不过在插入和删除的时候的旋转红黑树比平衡树时间复杂更少，据说平衡树需要O(logn)，而红黑树是O(1)，本人没经过验证在此标记一下。


遍历：分为前序遍历（父左右） 中序遍历（左父右） 后续遍历（左右父） 层序遍历（数组的话就是按i++遍历）


## 查找

#### 二分查找

假如一组数据是有序的，可以利用二分查找，

```
int Binary_Search(int *a,int n,int key)
{
    int low,high,mid;
    low = 0;
    high = n-1;
    while(low<=high)
    {
        mid = (low+high)/2; 
        if (key<a[mid])
            high = mid -1;
        else if(key >a[mid])
            low = mid+1;
        else
            return mid;

    }

    return -1;
}

```

#### 散列（hash）

一般散列类型的结构查找都是O（1）。原理：散列中有个hash函数即散列函数，这里面是程序员可以自己写的，好的代码可以减少key散列值的冲突，一般的方法有直接定址法、数字分析法、平方取数法、折叠法、除留余数法随机数法，如果冲突解决的办法有开放寻址法、拉链法，一般用拉链法的比较多，拉链法就是将hash值一样的放在一个链表中，但是如果链表长度很长的话很影响性能，所以很长的话可以转化为红黑树，减少查找的时间复杂度。

## 排序

###冒泡

稳定 、时间复杂度O（n²）、最好O（n）、最坏O（n²）、空间复杂度O（1）

概述：属于交换排序，比较是相邻的两个元素比较，交换也发生在这两个元素之间，小的放前面，大的放后面。第一遍循环过后，最大的已经在最后了，第二遍循环个数减1，依次类推。

判断稳定：假如两个元素相等不交换，所以稳定。

代码：

```

class QGPerson
{
public:
    const char * name;
    int age;
public:
    QGPerson(const char * name,int age):name(name),age(age)
    {
        //std::cout << this->name <<"----" <<this->age <<"\n";
    }
    ~QGPerson(){};
    
};

#pragma mark 交换数据
void QGSort::swap(QGPerson * a,QGPerson *b) {
    QGPerson tmp = *a;
    *a = *b;
    *b = tmp;
}

#pragma mark 冒泡
void QGSort::bubbleSort(QGPerson * source[],int num)
{
    int i,j;
    bool flag = true;
    for ( i = 0;i<num && flag;++i)
    {
        flag = false;
        for (j = 0;j<num -i-1;++j)
        {
            if (source[j]->age>source[j+1]->age)
            {
                QGSort::swap(source[j], source[j+1]);
                flag = true;
            }
        }
    }
}

```

### 简单选择
不稳定、时间复杂度O（n²）、最好O（n²）、最坏O（n²）、空间复杂度O（1）

概述：属于选择排序，第一遍遍历拿第一个值与各个值比较，得到最小的值与第一个值交换，只通过一次交换数据。第二次遍历拿第二个值比较，得到次小的值，与第二个值交换。依次类推。

判断稳定：因为交换是任意位置的，比如5 8 5 2 9，第一次遍历后就不稳定了。

代码

```
#pragma mark 简单选择
void QGSort::simpleSelectionSort(QGPerson * source[],int num)
{
    int i,j,min;
    for(i = 0 ;i<num-1;++i)
    {
        min = i;
        for (j = i +1;j<num;++j)
        {
            if (source[min]->age > source[j]->age)
            {
                min = j;
            }
        }
        
        if (i != min)
            QGSort::swap(source[i], source[min]);
    }
}

```

### 直接插入

稳定、时间复杂度O（n²）、最好O（n）、最坏O（n²）、空间复杂度O（1）

概述：属于插入排序，插入排序是在一个已经有序的小序列的基础上，一次插入一个元素。当然，刚开始这个有序的小序列只有1个元素，就是第一个元素。比较是从有序序列的末尾开始，也就是想要插入的元素和已经有序的最大者开始比起，如果比它大则直接插入在其后面，否则一直往前找直到找到它该插入的位置。

稳定判断：如果碰见一个和插入元素相等的，那么插入元素把想插入的元素放在相等元素的后面。所以，相等元素的前后顺序没有改变，从原无序序列出去的顺序就是排好序后的顺序，所以插入排序是稳定的。

代码

```
#pragma mark 直接插入
void QGSort::straihtInsertionSort(QGPerson * source[],int num)
{
    int i , j ;
    for (i =1;i<num;++i)
    {
        if(source[i]->age <source[i-1]->age)
        {
            QGPerson * temp = source[i];
            for (j = i-1;j>=0 && source[j]->age >temp->age;j--)
                source[j+1] = source[j];
            source[j+1] = temp;
        }
    }
    
}


```

### 希尔排序

不稳定、时间复杂度O（n²）、最好O（n^1.3）、最坏O（n²）、空间复杂度O（1）

概述：属于插入排序，希尔排序是按照不同步长对元素进行插入排序，当刚开始元素很无序的时候，步长最大，所以插入排序的元素个数很少，速度很快；当元素基本有序了，步长很小， 插入排序对于有序的序列效率很高。所以，希尔排序的时间复杂度会比O(n^2)好一些。

稳定判断：由于多次插入排序，我们知道一次插入排序是稳定的，不会改变相同元素的相对顺序，但在不同的插入排序过程中，相同的元素可能在各自的插入排序中移动，最后其稳定性就会被打乱，所以shell排序是不稳定的。

```
#pragma mark 希尔
void QGSort::shellSort(QGPerson * source[],int num)
{
    int i,j;
    for (int increment = num/2;increment>=1;increment /=2)
    {
        for (i = increment;i<num;++i)
        {
            if (source[i]->age < source[i-increment]->age)
            {
                QGPerson * temp = source[i];
                for (j = i-increment;j>=0 && source[j]->age >temp->age;j-=increment)
                    source[j+increment] = source[j];
                source[j+increment] = temp;
            }
        }
    }

}
```

### 堆排序

堆：堆是具有下列性质的完全二叉树：每个结点的值都大于或等于左右孩子的值称为大顶堆，每个结点的值都小于或等于左右孩子的值称为小顶堆。

不稳定、时间复杂度O（nlogn）、最好O（nlogn）、最坏O（nlogn）、空间复杂度O（1）

概述：属于选择排序排序，首先创建一个大顶堆，将根结点移走放入最后。然后将剩下的再构成一个大顶堆，然后再将根结点移走放到倒数第二个位置。依次类推。

稳定判断：比如2 3 3 ，创建大顶堆会将第二个3，放到最上面，然后就放到了最后，所以这两个3是交换了位置的，故不稳定

```
// 建立最大堆
// 这个过程相当于递归地去调整每一个子树。而叶子节点可以看做只是一个节点的堆，可以不用调整，所以只用调整非叶子节点，当index从0开始的时候，非叶子节点的最大序号是 (num-1)/2。
// Heap is source[0]~source[num-1].
void QGSort::heapSort(QGPerson * source[],int num)
{
    int i;
    for(i = (num-1)/2;i>=0;i--)
    {
        QGSort::maxHeapify(source, num, i);
    }
    
    for(i = num-1;i>0;--i)
    {
        // 把堆顶元素（即堆中最大的元素）和数组最后的元素互换，然后把这个前堆顶元素从堆中“去掉”，再调整一下新的堆。如此循环往复，就把较大的元素依次从数组尾部到头部排序下来了。
        QGSort::swap(source[0], source[i]);
        QGSort::maxHeapify(source, i, 0);
    }
    
}

// 调整以index=parent的元素为根的子树，使这个子树成为最大堆。
void QGSort::maxHeapify(QGPerson * source[],int num,int parent)
{
    // index从0计数，Left则为 2*i+1，Right则为2*i+2
    int left = 2 * parent +1;
    int right = 2 * parent +2;
    int largest = parent;
    if (left < num && source[left]->age > source[parent]->age)
        largest = left;
    else
        largest = parent;
    if (right < num && source[right]->age > source[largest]->age)
        largest = right;
    
    if (largest != parent) {
        QGSort::swap(source[parent], source[largest]);
        maxHeapify(source, num, parent);
    }
}



```

### 快速排序 

不稳定、时间复杂度O（nlogn）、最好O（nlogn）、最坏O（n²）、空间复杂度O(n) 由于递归调用产生栈空间

选择一个基准元素,通常选择第一个元素或者最后一个元素,通过一趟扫描，将待排序列分成两部分,一部分比基准元素小或等于,一部分大于基准元素,此时基准元素在其排好序后的正确位置,然后再用同样的方法递归地排序划分的两部分。

稳定判读：比如5 5 2 4，假如选最后一个个为基准元素，遍历到2时因为比4小，所以2与第一个5交换位置，所以就不稳定了

```
#pragma mark 快速排序

int QGSort::partition(QGPerson * source[],int end,int begin)
{
    
    int theAge = source[end]->age;
    int i = begin;
    for (int j = begin; j<=end - 1; ++j) {
        if (source[j]->age <= theAge)
        {
            QGSort::swap(source[i], source[j]);
            ++i;
        }
    }
    QGSort::swap(source[i], source[end]);
    return i;
    
}
void QGSort::quickSort(QGPerson * source[],int end,int begin)
{
    if (begin < end) {
        int pivotkey = partition(source, end, begin);
        quickSort(source, pivotkey-1, begin);
        quickSort(source, end, pivotkey+1);
    }
}

```

### 合并排序

稳定、时间复杂度O（nlogn）、最好O（nlogn）、最坏O（nlogn）、空间复杂度O(n) 

归并（Merge）排序法是将两个（或两个以上）有序表合并成一个新的有序表，即把待排序序列分为若干个子序列，每个子序列是有序的。然后再把有序子序列合并为整体有序序列。

稳定判断：拆分的时候假如两个相等的在两个组中合并的时候相等也不会改变顺序，假如在一个组中，顺序也不会改变，所以稳定。

```
#pragma mark 合并排序
void QGSort::merge(QGPerson * source[],int end,int begin,int mid)
{
    int leftNum = mid - begin +1;
    int rightNum = end - mid;
    QGPerson * left[leftNum];
    QGPerson * right[rightNum];
    int i = 0,j = 0;
    for (i = 0; i<leftNum; ++i) {
        left[i] = new QGPerson( source[begin+i]->name,source[begin+i]->age);
    }
    
    for (j=0; j<rightNum; j++) {
        right[j]= new QGPerson( source[mid+1+j] ->name,source[mid+1+j] ->age);
    }
    
    i=j=0;
    int k;
    for(k = begin;k<= end;k++)
    {
        if(i>=leftNum && j<rightNum)
        {
            source[k]->name = right[j]->name;
            source[k]->age = right[j]->age;
            ++j;
        }
        
        if(j>=rightNum && i<leftNum)
        {
            source[k]->name = left[i]->name;
            source[k]->age = left[i]->age;
            ++i;
        }
        
        if(i<leftNum && j<rightNum)
        {
            if(left[i]->age <= right[j]->age)
            {
                source[k]->name = left[i]->name;
                source[k]->age = left[i]->age;
                ++i;
            }
            else
            {
                source[k]->name = right[j]->name;
                source[k]->age = right[j]->age;
                ++j;
                
            }
        }
    }
    for (i = 0; i<leftNum; ++i) {
        delete left[i];
    }
    
    for (j=0; j<rightNum; j++) {
        delete right[j];
    }
    
}

void QGSort::mergeSort(QGPerson * source[],int end,int begin)
{
    if (begin < end)
    {
        int mid = (begin+end)/2;
        QGSort::mergeSort(source,mid,begin);
        QGSort::mergeSort(source,end,mid+1);
        QGSort::merge(source, end, begin, mid);
    }
}
```

# iOS中的数据结构

### 关于内存那点事

我的编程法则，我可以不知道我哪天花了多少钱，但是我必须知道 我开辟的内存啥时候释放。

```
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
```
上面代码是我们任意建一个RAC项目的main.m的代码。对于main.m有人喜欢转化为cpp，可以先通过终端cd到你的代码目录，然后在在终端输入

```
clang -x objective-c -rewrite-objc -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk main.m 
```
执行完你就可以看到main.cpp了,然后搜索`int main(int argc, const char * argv[])`可以看到

```
int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 

        NSString *s = (NSString *)&__NSConstantStringImpl__var_folders_tn_2kfn1ddx3hn1_4p9kwrrkwvc0000gp_T_main_961bfb_mi_0;
        ((NSString *(*)(id, SEL, NSString *))(void *)objc_msgSend)((id)s, sel_registerName("stringByAppendingString:"), (NSString *)&__NSConstantStringImpl__var_folders_tn_2kfn1ddx3hn1_4p9kwrrkwvc0000gp_T_main_961bfb_mi_1);

    }
    return 0;
}
```

然后再搜索`__AtAutoreleasePool`

```
struct __AtAutoreleasePool {
  __AtAutoreleasePool() {atautoreleasepoolobj = objc_autoreleasePoolPush();}
  ~__AtAutoreleasePool() {objc_autoreleasePoolPop(atautoreleasepoolobj);}
  void * atautoreleasepoolobj;
};
```
综上所述，现在代码放在一个域里{}这样__autoreleasepool变量就会在这个域结束时释放掉。我们可以看到__AtAutoreleasePool这个类的构造函数是调用了objc_autoreleasePoolPush，析构函数调用了objc_autoreleasePoolPop，

所以以上代码等同于

```
atautoreleasepoolobj = objc_autoreleasePoolPush();

//这里进行代码处理


objc_autoreleasePoolPop(atautoreleasepoolobj);
```

另外我们也可以查看汇编代码呀。

```
_main:                                  ; @main
Lfunc_begin0:
; BB#0:
    stp x29, x30, [sp, #-16]!
    mov  x29, sp
    sub sp, sp, #48             ; =48
Ltmp0:
    .cfi_def_cfa w29, 16
Ltmp1:
    .cfi_offset w30, -8
Ltmp2:
    .cfi_offset w29, -16
    stur    wzr, [x29, #-4]
    stur    w0, [x29, #-8]
    stur    x1, [x29, #-16]
Ltmp3:
    bl  _objc_autoreleasePoolPush
    adrp    x1, L_OBJC_SELECTOR_REFERENCES_@PAGE
    add x1, x1, L_OBJC_SELECTOR_REFERENCES_@PAGEOFF
    adrp    x30, L_OBJC_CLASSLIST_REFERENCES_$_@PAGE
    add x30, x30, L_OBJC_CLASSLIST_REFERENCES_$_@PAGEOFF
Ltmp4:
    ldur    w8, [x29, #-8]
    ldur    x9, [x29, #-16]
    ldr     x30, [x30]
    ldr     x1, [x1]
    str x0, [sp, #24]           ; 8-byte Folded Spill
    mov  x0, x30
    str w8, [sp, #20]           ; 4-byte Folded Spill
    str x9, [sp, #8]            ; 8-byte Folded Spill
    bl  _objc_msgSend
    bl  _NSStringFromClass
    ; InlineAsm Start
    mov  x29, x29
    ; InlineAsm End
    bl  _objc_retainAutoreleasedReturnValue
    movz    x9, #0
    ldr w8, [sp, #20]           ; 4-byte Folded Reload
    str     x0, [sp]        ; 8-byte Folded Spill
    mov  x0, x8
    ldr x1, [sp, #8]            ; 8-byte Folded Reload
    mov  x2, x9
    ldr     x3, [sp]        ; 8-byte Folded Reload
    bl  _UIApplicationMain
    stur    w0, [x29, #-4]
    ldr     x1, [sp]        ; 8-byte Folded Reload
    mov  x0, x1
    bl  _objc_release
    ldr x0, [sp, #24]           ; 8-byte Folded Reload
    bl  _objc_autoreleasePoolPop
Ltmp5:
    ldur    w0, [x29, #-4]
    mov  sp, x29
    ldp x29, x30, [sp], #16
    ret
Ltmp6:
Lfunc_end0:
```

是不是又看的一脸懵逼，这是用在iPhone6上的，ARM64的汇编。原先的push pop 用stp、ldp代替，相应的call 也变成了bl 。另外寄存器也发生了变化。不过原理都是一样的。直接看bl了哪些函数吧，看开头和结尾_objc_autoreleasePoolPush、_objc_autoreleasePoolPop。

好了，继续看objc的源码，在NSObject.mm找到

```
void *
objc_autoreleasePoolPush(void)
{
    if (UseGC) return nil;
    return AutoreleasePoolPage::push();
}
```

发现了一个`AutoreleasePoolPage`类，直译为自动释放池页，看来起起名字的哥们计算机知识也是相当扎实的，采用了分页，跟操作系统处理内存是一样样的，当程序加载到内存中也是通过虚拟内存空间（VMA）进行了分页处理。
好了上代码吧 由于代码太长，所以索性在代码写注释了

```
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

  自动释放池的实现

  一个线程的自动释放池是一个用指针来实现的栈
  每个指针指向一个由自动释放池来释放的对象，或者一个栈底指针，就跟ebp或rbp类似
  就跟函数栈一样，在返回函数的时候所有栈底指针之前都要pop掉，即所有对象都要释放
  由于栈可能很大，所以拆分为双向链表的页，根据需要增删页
  TLS指向当前hot页，当有新的对象添加的时候放到hot页里
**********************************************************************/

BREAKPOINT_FUNCTION(void objc_autoreleaseNoPool(id obj));

namespace {

struct magic_t {
    static const uint32_t M0 = 0xA1A1A1A1;
#   define M1 "AUTORELEASE!"
    static const size_t M1_len = 12;
    uint32_t m[4];
    
    magic_t() {
        assert(M1_len == strlen(M1));
        assert(M1_len == 3 * sizeof(m[1]));

        m[0] = M0;
        strncpy((char *)&m[1], M1, M1_len);
    }

    ~magic_t() {
        m[0] = m[1] = m[2] = m[3] = 0;
    }

    bool check() const {
        return (m[0] == M0 && 0 == strncmp((char *)&m[1], M1, M1_len));
    }

    bool fastcheck() const {
#if DEBUG
        return check();
#else
        return (m[0] == M0);
#endif
    }

#   undef M1
};
    
//设置为1 就可以实现mprotect() 来保护自动释放池的内容，当有其他线程的非法修改的话就会打印出相关信息
// Set this to 1 to mprotect() autorelease pool contents
#define PROTECT_AUTORELEASEPOOL 0

class AutoreleasePoolPage 
{

//设置了栈底指针的值为nil
#define POOL_SENTINEL nil
    
    //线程相关的key
    static pthread_key_t const key = AUTORELEASE_POOL_KEY;
    //当清空内存后将内存的内容设置为0xA3
    static uint8_t const SCRIBBLE = 0xA3;  // 0xA3A3A3A3 after releasing
    //页的大小 当为保护模式时必须为 虚拟内容空间页的大小的倍数 否则为4096个字节即4kB
    static size_t const SIZE = 
#if PROTECT_AUTORELEASEPOOL
        PAGE_MAX_SIZE;  // must be multiple of vm page size
#else
        PAGE_MAX_SIZE;  // size and alignment, power of 2
#endif
    static size_t const COUNT = SIZE / sizeof(id);

    magic_t const magic;
    //指针栈
    id *next;
    //线程
    pthread_t const thread;
    //父指针
    AutoreleasePoolPage * const parent;
    //子指针
    AutoreleasePoolPage *child;

    uint32_t const depth;
    uint32_t hiwat;

    // SIZE-sizeof(*this) bytes of contents follow

    //new的时候从堆上开辟一块一页的内从 当栈使
    static void * operator new(size_t size) {
        return malloc_zone_memalign(malloc_default_zone(), SIZE, SIZE);
    }
    //delete的时候释放内存
    static void operator delete(void * p) {
        return free(p);
    }
    //保护
    inline void protect() {
#if PROTECT_AUTORELEASEPOOL
        mprotect(this, SIZE, PROT_READ);
        check();
#endif
    }
    //取消保护
    inline void unprotect() {
#if PROTECT_AUTORELEASEPOOL
        check();
        mprotect(this, SIZE, PROT_READ | PROT_WRITE);
#endif
    }
    //构造函数 参数需要父指针
    AutoreleasePoolPage(AutoreleasePoolPage *newParent) 
        : magic(), next(begin()), thread(pthread_self()),
          parent(newParent), child(nil), 
          depth(parent ? 1+parent->depth : 0), 
          hiwat(parent ? parent->hiwat : 0)
    { 
        if (parent) {
            parent->check();
            assert(!parent->child);
            parent->unprotect();
            parent->child = this;
            parent->protect();
        }
        protect();
    }

    //析构函数
    ~AutoreleasePoolPage() 
    {
        check();
        unprotect();
        assert(empty());

        // Not recursive: we don't want to blow out the stack 
        // if a thread accumulates a stupendous amount of garbage
        assert(!child);
    }


    void busted(bool die = true) 
    {
        magic_t right;
        (die ? _objc_fatal : _objc_inform)
            ("autorelease pool page %p corrupted\n"
             "  magic     0x%08x 0x%08x 0x%08x 0x%08x\n"
             "  should be 0x%08x 0x%08x 0x%08x 0x%08x\n"
             "  pthread   %p\n"
             "  should be %p\n", 
             this, 
             magic.m[0], magic.m[1], magic.m[2], magic.m[3], 
             right.m[0], right.m[1], right.m[2], right.m[3], 
             this->thread, pthread_self());
    }

    void check(bool die = true) 
    {
        if (!magic.check() || !pthread_equal(thread, pthread_self())) {
            busted(die);
        }
    }

    void fastcheck(bool die = true) 
    {
        if (! magic.fastcheck()) {
            busted(die);
        }
    }

    //通过内存地址计算出本页从哪个对象开始
    id * begin() {
        return (id *) ((uint8_t *)this+sizeof(*this));
    }
    //通过内存地址计算出本页从哪个对象结束
    id * end() {
        return (id *) ((uint8_t *)this+SIZE);
    }
    //是否为空
    bool empty() {
        return next == begin();
    }
    //本页是否已经满了
    bool full() { 
        return next == end();
    }
    //还早着满呢
    bool lessThanHalfFull() {
        return (next - begin() < (end() - begin()) / 2);
    }
    //在栈中压入一个对象
    id *add(id obj)
    {
        assert(!full());
        unprotect();
        id *ret = next;  // faster than `return next-1` because of aliasing
        *next++ = obj;
        protect();
        return ret;
    }
    //pop所有对象并释放
    void releaseAll() 
    {
        releaseUntil(begin());
    }
    //释放某个之前所有对象
    void releaseUntil(id *stop) 
    {
        // Not recursive: we don't want to blow out the stack 
        // if a thread accumulates a stupendous amount of garbage
        
        //如果当前页的栈指针指向不是stop对象则循环
        while (this->next != stop) {
            // Restart from hotPage() every time, in case -release 
            // autoreleased more objects
            //当前页
            AutoreleasePoolPage *page = hotPage();

            // fixme I think this `while` can be `if`, but I can't prove it
            //如果当前页为空查找父结点的页 并设为当前页
            while (page->empty()) {
                page = page->parent;
                setHotPage(page);
            }

            page->unprotect();
            //取出栈顶指针的对象，并且栈顶指针--
            id obj = *--page->next;
            //用memset释放该对象在栈中的内存
            memset((void*)page->next, SCRIBBLE, sizeof(*page->next));
            page->protect();
            //如果不是栈底指针则调用objc_release
            if (obj != POOL_SENTINEL) {
                objc_release(obj);
            }
        }
        //设置当前对象为当前页
        setHotPage(this);

#if DEBUG
        // we expect any children to be completely empty
        for (AutoreleasePoolPage *page = child; page; page = page->child) {
            assert(page->empty());
        }
#endif
    }

    void kill() 
    {
        // Not recursive: we don't want to blow out the stack 
        // if a thread accumulates a stupendous amount of garbage
        AutoreleasePoolPage *page = this;
        while (page->child) page = page->child;

        AutoreleasePoolPage *deathptr;
        do {
            deathptr = page;
            page = page->parent;
            if (page) {
                page->unprotect();
                page->child = nil;
                page->protect();
            }
            delete deathptr;
        } while (deathptr != this);
    }

    static void tls_dealloc(void *p) 
    {
        // reinstate TLS value while we work
        setHotPage((AutoreleasePoolPage *)p);

        if (AutoreleasePoolPage *page = coldPage()) {
            if (!page->empty()) pop(page->begin());  // pop all of the pools
            if (DebugMissingPools || DebugPoolAllocation) {
                // pop() killed the pages already
            } else {
                page->kill();  // free all of the pages
            }
        }
        
        // clear TLS value so TLS destruction doesn't loop
        setHotPage(nil);
    }

    static AutoreleasePoolPage *pageForPointer(const void *p) 
    {
        return pageForPointer((uintptr_t)p);
    }

    static AutoreleasePoolPage *pageForPointer(uintptr_t p) 
    {
        AutoreleasePoolPage *result;
        uintptr_t offset = p % SIZE;

        assert(offset >= sizeof(AutoreleasePoolPage));

        result = (AutoreleasePoolPage *)(p - offset);
        result->fastcheck();

        return result;
    }


    static inline AutoreleasePoolPage *hotPage() 
    {
        AutoreleasePoolPage *result = (AutoreleasePoolPage *)
            tls_get_direct(key);
        if (result) result->fastcheck();
        return result;
    }

    static inline void setHotPage(AutoreleasePoolPage *page) 
    {
        if (page) page->fastcheck();
        tls_set_direct(key, (void *)page);
    }

    static inline AutoreleasePoolPage *coldPage() 
    {
        AutoreleasePoolPage *result = hotPage();
        if (result) {
            while (result->parent) {
                result = result->parent;
                result->fastcheck();
            }
        }
        return result;
    }

    //push后执行这里参数为栈底指针nil
    static inline id *autoreleaseFast(id obj)
    {
        //获取当前页
        AutoreleasePoolPage *page = hotPage();
        //如果当前页存在并页不满则add操作
        if (page && !page->full()) {
            return page->add(obj);
        } else if (page) { //如果存在当前页 并且满了 执行autoreleaseFullPage
            return autoreleaseFullPage(obj, page);
        } else {//如果不存在当前页执行autoreleaseNoPage
            return autoreleaseNoPage(obj);
        }
    }

    //如果当前页满了走这里
    static __attribute__((noinline))
    id *autoreleaseFullPage(id obj, AutoreleasePoolPage *page)
    {
        // The hot page is full. 
        // Step to the next non-full page, adding a new page if necessary.
        // Then add the object to that page.
        assert(page == hotPage());
        assert(page->full()  ||  DebugPoolAllocation);

        //如果满了就创建一个页呗，并将新页赋值给page
        do {
            if (page->child) page = page->child;
            else page = new AutoreleasePoolPage(page);
        } while (page->full());

        //设置新创建的页为当前页
        setHotPage(page);
        //将对象压入栈中
        return page->add(obj);
    }

    //如果当前页不存在
    static __attribute__((noinline))
    id *autoreleaseNoPage(id obj)
    {
        // No pool in place.
        assert(!hotPage());

        if (obj != POOL_SENTINEL  &&  DebugMissingPools) {
            // We are pushing an object with no pool in place, 
            // and no-pool debugging was requested by environment.
            _objc_inform("MISSING POOLS: Object %p of class %s "
                         "autoreleased with no pool in place - "
                         "just leaking - break on "
                         "objc_autoreleaseNoPool() to debug", 
                         (void*)obj, object_getClassName(obj));
            objc_autoreleaseNoPool(obj);
            return nil;
        }

        // Install the first page.
        AutoreleasePoolPage *page = new AutoreleasePoolPage(nil);
        setHotPage(page);

        // Push an autorelease pool boundary if it wasn't already requested.
        if (obj != POOL_SENTINEL) {
            page->add(POOL_SENTINEL);
        }

        // Push the requested object.
        return page->add(obj);
    }


    static __attribute__((noinline))
    id *autoreleaseNewPage(id obj)
    {
        AutoreleasePoolPage *page = hotPage();
        if (page) return autoreleaseFullPage(obj, page);
        else return autoreleaseNoPage(obj);
    }

public:
    static inline id autorelease(id obj)
    {
        assert(obj);
        assert(!obj->isTaggedPointer());
        id *dest __unused = autoreleaseFast(obj);
        assert(!dest  ||  *dest == obj);
        return obj;
    }

    //main.m中执行了push就是这里实际执行了autoreleaseFast
    static inline void *push() 
    {
        id *dest;
        if (DebugPoolAllocation) {
            // Each autorelease pool starts on a new pool page.
            dest = autoreleaseNewPage(POOL_SENTINEL);
        } else {
            dest = autoreleaseFast(POOL_SENTINEL);
        }
        assert(*dest == POOL_SENTINEL);
        return dest;
    }

    //释放某个对象之前所有的对象
    static inline void pop(void *token) 
    {
        AutoreleasePoolPage *page;
        id *stop;
        //获取这个对象在哪个页中
        page = pageForPointer(token);
        stop = (id *)token;
        if (DebugPoolAllocation  &&  *stop != POOL_SENTINEL) {
            // This check is not valid with DebugPoolAllocation off
            // after an autorelease with a pool page but no pool in place.
            _objc_fatal("invalid or prematurely-freed autorelease pool %p; ", 
                        token);
        }

        if (PrintPoolHiwat) printHiwat();
        //释放这个对象之前所有对象，移步到releaseUntil，注意这里只是释放了对象，并没有删除页
        page->releaseUntil(stop);

        //删除页
        // memory: delete empty children
        if (DebugPoolAllocation  &&  page->empty()) {
            // special case: delete everything during page-per-pool debugging
            AutoreleasePoolPage *parent = page->parent;
            page->kill();
            setHotPage(parent);
        } else if (DebugMissingPools  &&  page->empty()  &&  !page->parent) {
            // special case: delete everything for pop(top) 
            // when debugging missing autorelease pools
            page->kill();
            setHotPage(nil);
        } 
        else if (page->child) {
            // hysteresis: keep one empty child if page is more than half full
            if (page->lessThanHalfFull()) {
                page->child->kill();
            }
            else if (page->child->child) {
                page->child->child->kill();
            }
        }
    }

    static void init()
    {
        int r __unused = pthread_key_init_np(AutoreleasePoolPage::key, 
                                             AutoreleasePoolPage::tls_dealloc);
        assert(r == 0);
    }

    void print() 
    {
        _objc_inform("[%p]  ................  PAGE %s %s %s", this, 
                     full() ? "(full)" : "", 
                     this == hotPage() ? "(hot)" : "", 
                     this == coldPage() ? "(cold)" : "");
        check(false);
        for (id *p = begin(); p < next; p++) {
            if (*p == POOL_SENTINEL) {
                _objc_inform("[%p]  ################  POOL %p", p, p);
            } else {
                _objc_inform("[%p]  %#16lx  %s", 
                             p, (unsigned long)*p, object_getClassName(*p));
            }
        }
    }

    static void printAll()
    {        
        _objc_inform("##############");
        _objc_inform("AUTORELEASE POOLS for thread %p", pthread_self());

        AutoreleasePoolPage *page;
        ptrdiff_t objects = 0;
        for (page = coldPage(); page; page = page->child) {
            objects += page->next - page->begin();
        }
        _objc_inform("%llu releases pending.", (unsigned long long)objects);

        for (page = coldPage(); page; page = page->child) {
            page->print();
        }

        _objc_inform("##############");
    }

    static void printHiwat()
    {
        // Check and propagate high water mark
        // Ignore high water marks under 256 to suppress noise.
        AutoreleasePoolPage *p = hotPage();
        uint32_t mark = p->depth*COUNT + (uint32_t)(p->next - p->begin());
        if (mark > p->hiwat  &&  mark > 256) {
            for( ; p; p = p->parent) {
                p->unprotect();
                p->hiwat = mark;
                p->protect();
            }
            
            _objc_inform("POOL HIGHWATER: new high water mark of %u "
                         "pending autoreleases for thread %p:", 
                         mark, pthread_self());
            
            void *stack[128];
            int count = backtrace(stack, sizeof(stack)/sizeof(stack[0]));
            char **sym = backtrace_symbols(stack, count);
            for (int i = 0; i < count; i++) {
                _objc_inform("POOL HIGHWATER:     %s", sym[i]);
            }
            free(sym);
        }
    }

#undef POOL_SENTINEL
};

// anonymous namespace
};



```

从上面代码可以看到，自动释放池其实是在objc_autoreleasePoolPop的时候将对象之前的对象都执行了一遍objc_release(obj)，当然如果你看objc_release这里面的实现也会发现，其中还会查看计数，如果不为0不会执行dealloc。好吧我们还是看看吧

```
void objc_release(id obj) { [obj release]; }

- (oneway void)release {
    ((id)self)->rootRelease();
}

inline bool 
objc_object::rootRelease()
{
    assert(!UseGC);

    if (isTaggedPointer()) return false;
    return sidetable_release(true);
}


uintptr_t 
objc_object::sidetable_release(bool performDealloc)
{
#if SUPPORT_NONPOINTER_ISA
    assert(!isa.indexed);
#endif
    SideTable& table = SideTables()[this];

    bool do_dealloc = false;

    if (table.trylock()) {
        RefcountMap::iterator it = table.refcnts.find(this);
        if (it == table.refcnts.end()) {
            do_dealloc = true;
            table.refcnts[this] = SIDE_TABLE_DEALLOCATING;
        } else if (it->second < SIDE_TABLE_DEALLOCATING) {
            // SIDE_TABLE_WEAKLY_REFERENCED may be set. Don't change it.
            do_dealloc = true;
            it->second |= SIDE_TABLE_DEALLOCATING;
        } else if (! (it->second & SIDE_TABLE_RC_PINNED)) {
            it->second -= SIDE_TABLE_RC_ONE;
        }
        table.unlock();
        if (do_dealloc  &&  performDealloc) {
            ((void(*)(objc_object *, SEL))objc_msgSend)(this, SEL_dealloc);
        }
        return do_dealloc;
    }

    return sidetable_release_slow(table, performDealloc);
}


```

看到没上面通过objc_msgSend 发送SEL_dealloc ，前提do_dealloc == true。

好了 ，我们知道哪里释放的，可是对象啥时候放入AutoreleasePoolPage的指针栈的呀，让我们来看看都在哪里进行了压入的动作，在objc开源代码中搜一下`->add(`，一共找到四处，分别是AutoreleasePoolPage的autoreleaseFast、autoreleaseFullPage、autoreleaseNoPage。咦这不是上面我们看过的代码么？回去瞅瞅，在上面`push`函数里有用过，可是这个函数没参数啊，显然不是这个，再往上看还有个`autorelease`这个带参数obj，但是不确认。好吧让我们分别搜搜autoreleaseFast、autoreleaseFullPage、autoreleaseNoPage。搜索结果可以看出就是autorelease是入口，这里我就不列搜索结果，大家可以自行搜索。autorelease是个public类函数，调用的时候应该这样AutoreleasePoolPage::autorelease(对象)，好了继续搜AutoreleasePoolPage::autorelease(。可以在下列代码中搜到

```
id 
objc_object::rootAutorelease2()
{
    assert(!isTaggedPointer());
    return AutoreleasePoolPage::autorelease((id)this);
}
```
ok，再来搜搜rootAutorelease2，在objc项目中搜了一遍，居然没有调用的地。别着急，我也不知道苹果是不是故意的，项目目录里还有一个objc-object.h的文件，没包含在目录中，看到.h大家以为是头文件，你错了，你来看

```
// Base autorelease implementation, ignoring overrides.
inline id 
objc_object::rootAutorelease()
{
    assert(!UseGC);

    if (isTaggedPointer()) return (id)this;
    if (prepareOptimizedReturn(ReturnAtPlus1)) return (id)this;

    return rootAutorelease2();
}

```
好了，我们看到rootAutorelease是objc_object的public的对象的方法，调用的时候肯定是`->rootAutorelease`或者`rootAutorelease`，先让我们来搜一下前者，一共有两个

```
id
_objc_rootAutorelease(id obj)
{
    assert(obj);
    // assert(!UseGC);
    if (UseGC) return obj;  // fixme CF calls this when GC is on

    return obj->rootAutorelease();
}


// Replaced by ObjectAlloc
- (id)autorelease {
    return ((id)self)->rootAutorelease();
}

``

下面的autorelease就是我们在MRC中手动调用的autorelease，上面的_objc_rootAutorelease在Object.m中的

```
-(id) autorelease
{
    return _objc_rootAutorelease(self);
}
```

那是不是，在其他地方也有类似[对象 autorelease]的代码呢搜索一下`autorelease]`

```
id objc_autorelease(id obj) { return [obj autorelease]; }
```
搜索一下`objc_autorelease(`

```
id
objc_retain_autorelease(id obj)
{
    return objc_autorelease(objc_retain(obj));
}

id
objc_loadWeak(id *location)
{
    if (!*location) return nil;
    return objc_autorelease(objc_loadWeakRetained(location));
}
id
objc_autorelease(id obj)
{
    if (!obj) return obj;
    if (obj->isTaggedPointer()) return obj;
    return obj->autorelease();
}
id 
objc_autoreleaseReturnValue(id obj)
{
    if (prepareOptimizedReturn(ReturnAtPlus1)) return obj;

    return objc_autorelease(obj);
}
id
objc_retainAutorelease(id obj)
{
    return objc_autorelease(objc_retain(obj));
}

```

好了，这几个方法都可以在oc中直接调用将对象放入AutoreleasePoolPage。也就是可以通过在汇编中调用以上方法可以。

首先来看看ARC的[官方介绍](https://developer.apple.com/library/content/releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html)

> Automatic Reference Counting (ARC) is a compiler feature that provides automatic memory management of Objective-C objects

可以看到ARC是编译属性，本质上不用你写etain 、release、autorelease 这些代码，等你编译的时候，编译器自动为你加上。它没有改变 Objective-C 引用计数式内存管理的本质，更不是 GC（垃圾回收）。

好了，我现在有个需求哎，我想知道在ARC下，哪些变量能通过编译器添加代码放到AutoreleasePoolPage里了？哪些又没有。最直观的方式就是打印一下AutoreleasePoolPage，通过_objc_autoreleasePoolPrint和_CFAutoreleasePoolPrintPools方法可以打印。调用的方式又有两种

```
extern void _objc_autoreleasePoolPrint();//先声明一下

//然后在需要的地方执行一下
_objc_autoreleasePoolPrint();


```
另外一种是通过汇编直接调用，请注意使用真机来调试，否则会报错哦。
```
__asm__ ("bl __objc_autoreleasePoolPrint");
```

--------------------插叙---------------

xcode里有内置的Debugger，老版使用的是GDB，xcode自4.3之后默认使用的就是LLDB了。GDB是UNIX及UNIX-like下的调试工具。LLDB是个开源的内置于XCode的具有REPL(read-eval-print-loop)特征的Debugger，其可以安装C++或者Python插件。

---------------------------------------

好了，还可以在lldp中通过`po _CFAutoreleasePoolPrintPools()` 和`po _objc_autoreleasePoolPrint()`来打印哦，前提加上断点

好了上实验代码

```
int main(int argc, char * argv[]) {

    __asm__ ("bl __objc_autoreleasePoolPrint");
    NSArray *hh = @[@(2)];
    NSLog(@" %p",hh);
    __asm__ ("bl __objc_autoreleasePoolPrint");
    
    
    return 0;
}

```
打印结果如下：
```
objc[4036]: ##############
objc[4036]: AUTORELEASE POOLS for thread 0x1a92c0c40
objc[4036]: 0 releases pending.
objc[4036]: [0x100a44000]  ................  PAGE  (hot) (cold)
objc[4036]: ##############
warning: could not load any Objective-C class information. This will significantly reduce the quality of type information available.
2017-03-31 15:07:53.458103 DrawMaster[4036:1358804]  0x170013af0
objc[4036]: ##############
objc[4036]: AUTORELEASE POOLS for thread 0x1a92c0c40
objc[4036]: 0 releases pending.
objc[4036]: [0x100a44000]  ................  PAGE  (hot) (cold)
objc[4036]: ##############
```
然而并没有加入到AutoreleasePoolPage,再看这种
```
int main(int argc, char * argv[]) {

    __asm__ ("bl __objc_autoreleasePoolPrint");
    NSArray *hh = [NSArray arrayWithObjects:@(2), nil];
    NSLog(@" %p",hh);
    __asm__ ("bl __objc_autoreleasePoolPrint");
    
    
    return 0;
}

```

打印结果如下：

```
objc[4041]: ##############
objc[4041]: AUTORELEASE POOLS for thread 0x1a92c0c40
objc[4041]: 0 releases pending.
objc[4041]: [0x1009f8000]  ................  PAGE  (hot) (cold)
objc[4041]: ##############
2017-03-31 15:10:59.070827 DrawMaster[4041:1359726]  0x1700165f0
objc[4041]: ##############
objc[4041]: AUTORELEASE POOLS for thread 0x1a92c0c40
objc[4041]: 1 releases pending.
objc[4041]: [0x1009f8000]  ................  PAGE  (hot) (cold)
objc[4041]: [0x1009f8038]       0x1700165f0  __NSSingleObjectArrayI
objc[4041]: ##############

```
哇塞，看到没page里有个0x1700165f0，这说明已经添加到page里面了。

再来看

```
int main(int argc, char * argv[]) {

    __asm__ ("bl __objc_autoreleasePoolPrint");
    NSArray *hh = [[NSArray alloc] init];
    NSLog(@" %p",hh);
    __asm__ ("bl __objc_autoreleasePoolPrint");
    
    
    return 0;
}
```

打印结果

```
objc[4045]: ##############
objc[4045]: AUTORELEASE POOLS for thread 0x1a92c0c40
objc[4045]: 0 releases pending.
objc[4045]: [0x100c00000]  ................  PAGE  (hot) (cold)
objc[4045]: ##############
2017-03-31 15:18:06.151023 DrawMaster[4045:1360848]  0x170015dd0
objc[4045]: ##############
objc[4045]: AUTORELEASE POOLS for thread 0x1a92c0c40
objc[4045]: 0 releases pending.
objc[4045]: [0x100c00000]  ................  PAGE  (hot) (cold)
objc[4045]: ##############
```
这里也没有，上面例子说明除了，以\alloc\new\copy\mutableCopy开头的方法生成的对象都不会被添加到page中，只有除此之外生成的对象才被添加到page中.

我们只知道结果，却不知道为什么，那下面我们就来分析一下。自己创建一个类QGObject

```
@interface QGObject : NSObject
+ (QGObject*) allocOne;
+ (QGObject*) getOne;
@end
```

```
#import "QGObject.h"

@implementation QGObject
+ (QGObject*) allocOne
{
    QGObject *qgobj = [[QGObject alloc] init];
    return qgobj;
}
+ (QGObject*) getOne
{
    return [[QGObject alloc] init];
}
@end
```
然后将QGObject执行汇编操作

```
"+[QGObject allocOne]":                 ; @"\01+[QGObject allocOne]"
Lfunc_begin1:
; BB#0:
    stp x29, x30, [sp, #-16]!
    mov  x29, sp
    sub sp, sp, #32             ; =32
Ltmp5:
    .cfi_def_cfa w29, 16
Ltmp6:
    .cfi_offset w30, -8
Ltmp7:
    .cfi_offset w29, -16
    adrp    x8, L_OBJC_SELECTOR_REFERENCES_.4@PAGE
    add x8, x8, L_OBJC_SELECTOR_REFERENCES_.4@PAGEOFF
    adrp    x9, L_OBJC_CLASSLIST_REFERENCES_$_@PAGE
    add x9, x9, L_OBJC_CLASSLIST_REFERENCES_$_@PAGEOFF
    stur    x0, [x29, #-8]
    str x1, [sp, #16]
Ltmp8:
    ldr     x9, [x9]
    ldr     x1, [x8]
    mov  x0, x9
    bl  _objc_msgSend
    adrp    x8, L_OBJC_SELECTOR_REFERENCES_.6@PAGE
    add x8, x8, L_OBJC_SELECTOR_REFERENCES_.6@PAGEOFF
    ldr     x1, [x8]
    bl  _objc_msgSend
    str x0, [sp, #8]
    ldr x8, [sp, #8]
    mov  x0, x8
    bl  _objc_retain
    movz    x8, #0
    add x9, sp, #8              ; =8
    str     x0, [sp]        ; 8-byte Folded Spill
    mov  x0, x9
    mov  x1, x8
    bl  _objc_storeStrong
    ldr     x0, [sp]        ; 8-byte Folded Reload
    mov  sp, x29
    ldp x29, x30, [sp], #16
    ret
Ltmp9:
Lfunc_end1:
"-[QGObject getOne]":                   ; @"\01-[QGObject getOne]"
Lfunc_begin0:
    .cfi_startproc
; BB#0:
    stp x29, x30, [sp, #-16]!
    mov  x29, sp
    sub sp, sp, #16             ; =16
Ltmp0:
    .cfi_def_cfa w29, 16
Ltmp1:
    .cfi_offset w30, -8
Ltmp2:
    .cfi_offset w29, -16
    ;DEBUG_VALUE: -[QGObject getOne]:self <- [%SP+8]
    ;DEBUG_VALUE: -[QGObject getOne]:_cmd <- [%SP+0]
    str x0, [sp, #8]
    str     x1, [sp]
Ltmp3:
    adrp    x0, L_OBJC_CLASSLIST_REFERENCES_$_@PAGE
    ldr x0, [x0, L_OBJC_CLASSLIST_REFERENCES_$_@PAGEOFF]
    adrp    x1, L_OBJC_SELECTOR_REFERENCES_@PAGE
    ldr x1, [x1, L_OBJC_SELECTOR_REFERENCES_@PAGEOFF]
    bl  _objc_msgSend
Ltmp4:
    adrp    x1, L_OBJC_SELECTOR_REFERENCES_.2@PAGE
    ldr x1, [x1, L_OBJC_SELECTOR_REFERENCES_.2@PAGEOFF]
    bl  _objc_msgSend
    mov  sp, x29
    ldp x29, x30, [sp], #16
    b   _objc_autoreleaseReturnValue
Ltmp5:
Lfunc_end0:
```
由上面汇编代码可以看出以alloc开头的驼峰式方法allocOne是调用的_objc_retain，而getOne方法汇编代码中调用的是_objc_autoreleaseReturnValue。我们上面介绍过，这个函数最终执行到page的add里。好了，到这里就回答上面那个问题了，就是什么样的变量才会放到page里。

等等，我们是不是忘了一件事，就是变量修饰符，诸如__strong、__weak、__autoreleasing、__unsafe_unretained之类的。

#### 变量修饰符
##### __strong 

对应定义 property 时用到的 strong。当对象没有任何一个强引用指向它时，它才会被释放。如果在声明引用时不加修饰符，那么引用将默认是强引用。当需要释放强引用指向的对象时，需要保证所有指向对象强引用置为 nil。__strong 修饰符是 id 类型和对象类型默认的所有权修饰符。

##### __weak  
表示弱引用，对应定义 property 时用到的 weak。弱引用不会影响对象的释放，而当对象被释放时，所有指向它的弱引用都会自定被置为 nil，这样可以防止野指针。__weak 最常见的一个作用就是用来避免强引用循环。但是需要注意的是，__weak 修饰符只能用于 iOS5 以上的版本，在 iOS4 及更低的版本中使用 __unsafe_unretained 修饰符来代替。

__weak 的几个使用场景：

###### 在 Delegate 关系中防止强引用循环。在 ARC 特性下，通常我们应该设置 Delegate 属性为 weak 的。但是这里有一个疑问，我们常用到的 UITableView 的 delegate 属性是这样定义的： @property (nonatomic, assign) id<UITableViewDelegate> delegate;，为什么用的修饰符是 assign 而不是 weak？其实这个 assign 在 ARC 中意义等同于 __unsafe_unretaied（后面会讲到），它是为了在 ARC 特性下兼容 iOS4 及更低版本来实现弱引用机制。一般情况下，你应该尽量使用 weak。

###### 在 Block 中防止强引用循环。

###### 用来修饰指向由 Interface Builder 创建的控件。比如：@property (weak, nonatomic) IBOutlet UIButton *testButton;

#### __autoreleasing 

在 ARC 模式下，我们不能显示的使用 autorelease 方法了，但是 autorelease 的机制还是有效的，通过将对象赋给 __autoreleasing 修饰的变量就能达到在 MRC 模式下调用对象的 autorelease 方法同样的效果。其实与objc_autoreleaseReturnValue效果一样，因为比如你用__autoreleasing修饰符，汇编后可以看到编译器会调用
_objc_autorelease,而objc_autoreleaseReturnValue里面就是调用的objc_autorelease


#### __unsafe_unretained

ARC 是在 iOS5 引入的，而 __unsafe_unretained 这个修饰符主要是为了在 ARC 刚发布时兼容 iOS4 以及版本更低的系统，因为这些版本没有弱引用机制。这个修饰符在定义 property 时对应的是 unsafe_unretained。__unsafe_unretained 修饰的指针纯粹只是指向对象，没有任何额外的操作，不会去持有对象使得对象的 retainCount +1。而在指向的对象被释放时依然原原本本地指向原来的对象地址，不会被自动置为 nil，所以成为了野指针，非常不安全。在 ARC 环境下但是要兼容 iOS4.x 的版本，用 __unsafe_unretained 替代 __weak 解决强引用循环的问题。



好吧，继续看上面的问题，由上面看出只有__autoreleasing修饰的变量才会添加到page中，那好试试吧

```
int main(int argc, char * argv[]) {

    __asm__ ("bl __objc_autoreleasePoolPrint");
    __autoreleasing NSArray *hh = [[NSArray alloc] init];
    NSLog(@" %p",hh);
    __asm__ ("bl __objc_autoreleasePoolPrint");
    
    
    return 0;
}
```

结果

```
objc[4115]: ##############
objc[4115]: AUTORELEASE POOLS for thread 0x1a92c0c40
objc[4115]: 0 releases pending.
objc[4115]: [0x1009c8000]  ................  PAGE  (hot) (cold)
objc[4115]: ##############
2017-03-31 16:43:33.533737 DrawMaster[4115:1381467]  0x17400cde0
warning: could not load any Objective-C class information. This will significantly reduce the quality of type information available.
objc[4115]: ##############
objc[4115]: AUTORELEASE POOLS for thread 0x1a92c0c40
objc[4115]: 0 releases pending.
objc[4115]: [0x1009c8000]  ................  PAGE  (hot) (cold)
objc[4115]: ##############
```

什么还是没有？发生了什么情况，太捉急了，汇编一下

```
_main:                                  ; @main
Lfunc_begin0:
    .cfi_startproc
; BB#0:
    stp x29, x30, [sp, #-16]!
    mov  x29, sp
    sub sp, sp, #32             ; =32
Ltmp0:
    .cfi_def_cfa w29, 16
Ltmp1:
    .cfi_offset w30, -8
Ltmp2:
    .cfi_offset w29, -16
    stur    wzr, [x29, #-4]
    stur    w0, [x29, #-8]
    str x1, [sp, #16]
Ltmp3:
    ; InlineAsm Start
    bl  __objc_autoreleasePoolPrint
    ; InlineAsm End
    adrp    x1, L_OBJC_SELECTOR_REFERENCES_@PAGE
    add x1, x1, L_OBJC_SELECTOR_REFERENCES_@PAGEOFF
    adrp    x8, L_OBJC_CLASSLIST_REFERENCES_$_@PAGE
    add x8, x8, L_OBJC_CLASSLIST_REFERENCES_$_@PAGEOFF
    ldr     x8, [x8]
    ldr     x1, [x1]
    mov  x0, x8
    bl  _objc_msgSend
    adrp    x8, L_OBJC_SELECTOR_REFERENCES_.2@PAGE
    add x8, x8, L_OBJC_SELECTOR_REFERENCES_.2@PAGEOFF
    ldr     x1, [x8]
    bl  _objc_msgSend
    bl  _objc_autorelease
    str x0, [sp, #8]
    ldr x8, [sp, #8]
    mov  x0, sp
    str     x8, [x0]
    adrp    x0, L__unnamed_cfstring_.4@PAGE
    add x0, x0, L__unnamed_cfstring_.4@PAGEOFF
    bl  _NSLog
    ; InlineAsm Start
    bl  __objc_autoreleasePoolPrint
    ; InlineAsm End
    movz    w9, #0
    mov  x0, x9
    mov  sp, x29
    ldp x29, x30, [sp], #16
    ret
Ltmp4:
Lfunc_end0:
```
可以看到已经调用了objc_autorelease了啊 。打印一下此时hh的类型，发现是_NSArray0，这是什么鬼,又回去看代码发现有isTaggedPointer的判断。难道NSArray0会是tagged类型的么。


-------------------Tagged Pointer-------------------
Tagged Pointer特点的介绍：

Tagged Pointer专门用来存储小的对象，例如NSNumber和NSDate

Tagged Pointer指针的值不再是地址了，而是真正的值。所以，实际上它不再是一个对象了，它只是一个披着对象皮的普通变量而已。所以，它的内存并不存储在堆中，也不需要malloc和free。

在内存读取上有着3倍的效率，创建时比以前快106倍。

由此可见，苹果引入Tagged Pointer，不但减少了64位机器下程序的内存占用，还提高了运行效率。

诸如：@(2) 这就是Tagged Pointer，虽然是个对象，但是是个伪对象，如果你要@(2)->isa 会报错。
----------------------------------------------------

ok，让我们来访问一下hh的isa吧，在lldb中打印`po hh->isa` 居然有值。好吧这是个坑，目前还填不了，以后再来填。

什么这么快就放弃了么 ？那么高的工资领着不羞愧么？好吧祭出我们的法宝吧，啥法宝？看内存地址。有人问我去，这有啥好看的。难道你忘了内存里是啥样的了？栈中的内存是自上往下生长，堆内的内存是自下往上生长，数据区单独放在一起。那这个[[NSArray alloc] init]会不会放在数据区，也就是一个常量啥的。在此，我们普及一个小知识：指针常量、常量指针的区别。请在中间加上的，就能分清楚了，指针的常量说明这个指针是常量，常量const放*的右边。常量的指针，说明这个是常量的指针，也就是有个指针指向的常量，常量const放在*的左边。那么这个const是干啥的到底，是防谁的，防止谁改变？呵呵，其实是防止程序员的，比如，我写了一个变量，这个变量是我自己定的，我不想让其他程序员改变，或者不想让自己不小心改变，就用const，它是个编译属性，在编译的时候编译会进行校对，如果改变了，就会编译不成功。我们知道内存中的数据区是存放静态数据和常量的，那么这数据区的常量是指的常量指针的常量么？非也非也，数据区的常量指的是字符串常量。另外还有`static`，也是编译属性，也就是编译的时候我就需要知道static变量的值，如果你这么写 `static NSArray *b = [NSArray arrayWithObjects:@(2), nil];`编译器直接就报错了。看实验。


```
int main(int argc, char * argv[]) {
    NSArray *a = [NSArray arrayWithObjects:@(3), nil];
    NSArray *b = [NSArray arrayWithObjects:@(2), nil];
    const NSArray * c = [NSArray arrayWithObjects:@(1), nil];
    NSArray *d = @[];
    NSArray *e = @[];
    NSArray *f = [NSArray alloc];
    NSArray *g = [NSArray alloc];
    NSArray *m = [[NSArray alloc] init];
    NSArray *n = [[NSArray alloc] init];
    NSArray *o = [NSArray new];
    NSArray *s = [NSArray new];
    NSArray *x = [NSArray array];
    NSArray *y = [NSArray array];
    NSDictionary *h = @{};
    NSNumber * k = @(2);
    NSString * str = @"sss";
    static int i = 0;
    NSLog(@"指针a的地址：%p 指针a指向的地址%p",&a,a);
    NSLog(@"指针b的地址：%p 指针b指向的地址%p",&b,b);
    NSLog(@"指针c的地址：%p 指针c指向的地址%p",&c,c);
    NSLog(@"指针d的地址：%p 指针d指向的地址%p",&d,d);
    NSLog(@"指针e的地址：%p 指针e指向的地址%p",&e,e);
    NSLog(@"指针f的地址：%p 指针f指向的地址%p",&f,f);
    NSLog(@"指针g的地址：%p 指针g指向的地址%p",&g,g);
    NSLog(@"指针m的地址：%p 指针m指向的地址%p",&m,m);
    NSLog(@"指针n的地址：%p 指针n指向的地址%p",&n,n);
    NSLog(@"指针o的地址：%p 指针o指向的地址%p",&o,o);
    NSLog(@"指针s的地址：%p 指针s指向的地址%p",&s,s);
    NSLog(@"指针x的地址：%p 指针x指向的地址%p",&x,x);
    NSLog(@"指针y的地址：%p 指针y指向的地址%p",&y,y);
    NSLog(@"指针h的地址：%p 指针h指向的地址%p",&h,h);
    NSLog(@"指针k的地址：%p 指针k指向的地址%p",&k,k);
    NSLog(@"指针str的地址：%p 指针str指向的地址%p",&str,str);
    NSLog(@"i的地址：%p ",&i);
    
    
    return 0;
}
```

执行结果 

```
2017-04-01 12:26:51.170228 DrawMaster[4740:1534203] 指针a的地址：0x16fd9fa58 指针a指向的地址0x170012090
2017-04-01 12:26:51.170331 DrawMaster[4740:1534203] 指针b的地址：0x16fd9fa50 指针b指向的地址0x1700120a0
2017-04-01 12:26:51.170396 DrawMaster[4740:1534203] 指针c的地址：0x16fd9fa48 指针c指向的地址0x1700120c0
2017-04-01 12:26:51.170439 DrawMaster[4740:1534203] 指针d的地址：0x16fd9fa40 指针d指向的地址0x170011bb0
2017-04-01 12:26:51.170479 DrawMaster[4740:1534203] 指针e的地址：0x16fd9fa30 指针e指向的地址0x170011bb0
2017-04-01 12:26:51.170522 DrawMaster[4740:1534203] 指针f的地址：0x16fd9fa20 指针f指向的地址0x170011b80
2017-04-01 12:26:51.170565 DrawMaster[4740:1534203] 指针g的地址：0x16fd9fa18 指针g指向的地址0x170011b80
2017-04-01 12:26:51.170613 DrawMaster[4740:1534203] 指针m的地址：0x16fd9fa10 指针m指向的地址0x170011bb0
2017-04-01 12:26:51.170654 DrawMaster[4740:1534203] 指针n的地址：0x16fd9fa08 指针n指向的地址0x170011bb0
2017-04-01 12:26:51.170731 DrawMaster[4740:1534203] 指针o的地址：0x16fd9fa00 指针o指向的地址0x170011bb0
2017-04-01 12:26:51.170796 DrawMaster[4740:1534203] 指针s的地址：0x16fd9f9f8 指针s指向的地址0x170011bb0
2017-04-01 12:26:51.170868 DrawMaster[4740:1534203] 指针x的地址：0x16fd9f9f0 指针x指向的地址0x170011bb0
2017-04-01 12:26:51.170927 DrawMaster[4740:1534203] 指针y的地址：0x16fd9f9e8 指针y指向的地址0x170011bb0
2017-04-01 12:26:51.170967 DrawMaster[4740:1534203] 指针h的地址：0x16fd9f9e0 指针h指向的地址0x170011ba0
2017-04-01 12:26:51.171007 DrawMaster[4740:1534203] 指针k的地址：0x16fd9f9c8 指针k指向的地址0xb000000000000022
2017-04-01 12:26:51.171047 DrawMaster[4740:1534203] 指针str的地址：0x16fd9f9c0 指针str指向的地址0x100463000
2017-04-01 12:26:51.171086 DrawMaster[4740:1534203] i的地址：0x100519cc0
```
从上面结果可以看出

1、栈指针的地址是从高到低

2、数据区保存的是字符串常量和静态数据

3、@[]和[NSArray alloc]和@{}等等类似的也放在堆中，但是是常量，无论多少个指针指向它，地址都不会变，但是[NSArray alloc]与其他方式生成的对象地址是不一样的，我们可以从这入手。

4、@(1)这样的是Tagged指针（伪对象）内存地址以0xb开头，iOS会对它特殊对待

5、但是堆中是无序的，以上代码执行10次，内存中的增长方向是不固定的。


按照上面的结论 `__autoreleasing`对常量、字符串常量、静态变量、tagged指针应该是无效的，经测试确实如此，这里就不列代码了，但是[NSArray alloc]例外，虽然是常量，但是还是可以起作用

```
int main(int argc, char * argv[]) {
    __asm__ ("bl __objc_autoreleasePoolPrint");
    __autoreleasing NSArray *hh = [NSArray alloc];
    NSLog(@" %p",hh);
    __asm__ ("bl __objc_autoreleasePoolPrint");
    
    return 0;
}
```

```
objc[4747]: ##############
objc[4747]: AUTORELEASE POOLS for thread 0x1a92c0c40
objc[4747]: 0 releases pending.
objc[4747]: [0x1009f4000]  ................  PAGE  (hot) (cold)
objc[4747]: ##############
2017-04-01 12:37:08.352556 DrawMaster[4747:1536437]  0x17000e1e0
objc[4747]: ##############
objc[4747]: AUTORELEASE POOLS for thread 0x1a92c0c40
objc[4747]: 1 releases pending.
objc[4747]: [0x1009f4000]  ................  PAGE  (hot) (cold)
objc[4747]: [0x1009f4038]       0x17000e1e0  __NSPlaceholderArray
objc[4747]: ##############
```


##### 请注意以上如果换成NSObject是没问题的

```
int main(int argc, char * argv[]) {
    __asm__ ("bl __objc_autoreleasePoolPrint");
    __autoreleasing NSObject *hh = [[NSObject alloc] init];
    __autoreleasing NSObject *ii = [NSObject alloc] ;
    __autoreleasing NSObject *ss = [NSObject alloc] ;
    NSLog(@"hh指向的内存地址为： %p ii指向的内存地址为：%p ss指向的内存地址为： %p",hh,ii,ss);
    __asm__ ("bl __objc_autoreleasePoolPrint");
    
    return 0;
}
```

结果为

```
objc[4764]: ##############
objc[4764]: AUTORELEASE POOLS for thread 0x1a92c0c40
objc[4764]: 0 releases pending.
objc[4764]: [0x1009e4000]  ................  PAGE  (hot) (cold)
objc[4764]: ##############
2017-04-01 13:15:00.696983 DrawMaster[4764:1543682] hh指向的内存地址为： 0x1700004a0 ii指向的内存地址为：0x1700004b0 ss指向的内存地址为： 0x1700004d0
objc[4764]: ##############
objc[4764]: AUTORELEASE POOLS for thread 0x1a92c0c40
objc[4764]: 3 releases pending.
objc[4764]: [0x1009e4000]  ................  PAGE  (hot) (cold)
objc[4764]: [0x1009e4038]       0x1700004a0  NSObject
objc[4764]: [0x1009e4040]       0x1700004b0  NSObject
objc[4764]: [0x1009e4048]       0x1700004d0  NSObject
objc[4764]: ##############
```

说明oc对NSArray和 NSDictionary进行了优化，具体细节，没有代码就没办法深究了

#### 临时变量的释放

临时变量的释放有以下几种方式

##### 设置变量为nil

该方式会释放该变量指向的内存，但是前提有几个：

1、没有变量再对此变量进行强引用

2、该变量没有被`__autoreleasing`修饰符修饰

3、该变量不是NSMutableArray、NSArray

4、该变量不是字符串类型的变量

实验：注意在return 0那加断点

```
int main(int argc, char * argv[]) {
    NSObject *a = [NSObject alloc];
    NSObject *b =a;
    NSLog(@"在lldb输入:po %p",a);
    a = nil;
    
    __autoreleasing NSObject *c = [NSObject alloc];
    NSLog(@"在lldb输入:po %p",c);
    c = nil;
    
    NSArray *d = [NSArray arrayWithObjects:@(1),@(2), nil];
    NSLog(@"在lldb输入:po %p",d);
    d = nil;
    
    NSMutableArray *e = [NSMutableArray arrayWithObjects:@(1),@(2), nil];
    NSLog(@"在lldb输入:po %p",e);
    e = nil;
    
    NSString *f = [[NSString alloc] initWithFormat:@"QuanGe"];
    NSLog(@"在lldb输入:po %p",f);
    f = nil;
    
    return 0;
}

```

结果

```
2017-04-01 16:20:36.266034 DrawMaster[5041:1596867] 在lldb输入:po 0x1700044c0
2017-04-01 16:20:36.266142 DrawMaster[5041:1596867] 在lldb输入:po 0x1700044b0
2017-04-01 16:20:36.266213 DrawMaster[5041:1596867] 在lldb输入:po 0x17002a680
2017-04-01 16:20:36.266267 DrawMaster[5041:1596867] 在lldb输入:po 0x170044230
2017-04-01 16:20:36.266333 DrawMaster[5041:1596867] 在lldb输入:po 0xa0065476e6175516
(lldb) po 0x1700044c0
<NSObject: 0x1700044c0>

(lldb) po 0x1700044b0
<NSObject: 0x1700044b0>

(lldb) po 0x17002a680
<__NSArrayI 0x17002a680>(
1,
2
)


(lldb) po 0xa0065476e6175516
QuanGe

(lldb) 

```

##### _objc_rootRelease

像以前一样 先声明 `extern void _objc_rootRelease(id obj);`

将上面的代码修改一下

实验：注意在return 0那加断点

```
extern void _objc_rootRelease(id obj);
int main(int argc, char * argv[]) {
    NSObject *a = [NSObject alloc];
    NSObject *b =a;
    NSLog(@"在lldb输入:po %p",a);
    _objc_rootRelease(a);
    
    __autoreleasing NSObject *c = [NSObject alloc];
    NSLog(@"在lldb输入:po %p",c);
    _objc_rootRelease(c);
    
    NSArray *d = [NSArray arrayWithObjects:@(1),@(2), nil];
    NSLog(@"在lldb输入:po %p",d);
    _objc_rootRelease(d);
    
    NSMutableArray *e = [NSMutableArray arrayWithObjects:@(1),@(2), nil];
    NSLog(@"在lldb输入:po %p",e);
    _objc_rootRelease(e);
    
    NSString *f = [[NSString alloc] initWithFormat:@"QuanGe"];
    NSLog(@"在lldb输入:po %p",f);
    _objc_rootRelease(f);
    
    return 0;
}
```

结果

```
2017-04-01 16:25:56.426322 DrawMaster[5048:1598342] 在lldb输入:po 0x170010320
2017-04-01 16:25:56.426436 DrawMaster[5048:1598342] 在lldb输入:po 0x174010600
2017-04-01 16:25:56.426509 DrawMaster[5048:1598342] 在lldb输入:po 0x174021be0
2017-04-01 16:25:56.426572 DrawMaster[5048:1598342] 在lldb输入:po 0x174055090
2017-04-01 16:25:56.426653 DrawMaster[5048:1598342] 在lldb输入:po 0xa0065476e6175516
(lldb) po 0x170010320
<NSObject: 0x170010320>

(lldb) po 0x174010600
6241191424

(lldb) po 0x174021be0
<__NSArrayI 0x174021be0>(
1,
2
)


(lldb) po 0x174055090
<__NSArrayM 0x174055090>(
1,
2
)


(lldb) po 0xa0065476e6175516
QuanGe

```

哈哈，__autoreleasing修饰的居然释放掉了。注意，这种方法不适用于真实项目中，但是有一个很重要作用，测试哪里会自带@autoreleasepool，因为你一调用该方法就会在哪闪退，这样就知道哪里有@autoreleasepool不用自己写了。



##### memset 直接操作内存

在这需要补充点新知识，ARC下OC对象和CF对象之间的桥接(bridge)

在开发iOS应用程序时我们有时会用到Core Foundation对象简称CF，例如Core Graphics、Core Text，并且我们可能需要将CF对象和OC对象进行互相转化，我们知道，ARC环境下编译器不会自动管理CF对象的内存，所以当我们创建了一个CF对象以后就需要我们使用CFRelease将其手动释放，那么CF和OC相互转化的时候该如何管理内存呢？答案就是我们在需要时可以使用__bridge,__bridge_transfer,__bridge_retained，具体介绍和用法如下

1、__bridge:CF和OC对象转化时只涉及对象类型不涉及对象所有权的转化；

```
NSArray * a = [NSArray arrayWithObjects:@(1), nil];
CFArrayRef ap = (__bridge CFArrayRef) a;
```

2、__bridge_transfer:常用在讲CF对象转换成OC对象时，将CF对象的所有权交给OC对象，此时ARC就能自动管理该内存；

3、__bridge_retained:（与__bridge_transfer相反）常用在将OC对象转换成CF对象时，将OC对象的所有权交给CF对象来管理；

```
NSArray * a = [NSArray arrayWithObjects:@(1), nil];
CFArrayRef ap = (__bridge CFArrayRef) a;
CFRelease(ap);
```

但并不是多有的CF对象都支持 Toll-Free Bridging.

所以试验只列一个吧

```
int main(int argc, char * argv[]) {
    
    NSArray *d = [NSArray arrayWithObjects:@(1),@(2), nil];
    NSLog(@"在lldb输入:po %p",d);
    CFArrayRef ap = (__bridge CFArrayRef) d;
    memset((void*)ap, 0, sizeof(ap));
    
    
    return 0;
}
```
结果

```
2017-04-01 16:43:05.696882 DrawMaster[5052:1600368] 在lldb输入:po 0x17403adc0
(lldb) po 0x17403adc0
6241365440

```

我去，居然真的释放了啊，不过由于直接处理内存，没有对引用计数操作，所以实际上真实项目中也不适用，和上面一样，可以测试哪些代码里带@autoreleasepool

##### CFRelease

上面已经有介绍了 直接上代码吧

```
int main(int argc, char * argv[]) {
    
    NSArray *d = [NSArray arrayWithObjects:@(1),@(2), nil];
    NSLog(@"在lldb输入:po %p",d);
    CFArrayRef ap = (__bridge_retained CFArrayRef) d;
    CFRelease(ap);
    
    
    return 0;
}
```

结果

```
2017-04-01 16:46:44.847973 DrawMaster[5056:1601094] 在lldb输入:po 0x17003f5e0
(lldb) po 0x17003f5e0
<__NSArrayI 0x17003f5e0>(
1,
2
)
```


好吧，失败，没有释放掉。

##### @autoreleasepool 
还客气啥直接上代码吧。

```
int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSObject *a = [NSObject alloc];
        NSObject *b =a;
        NSLog(@"在lldb输入:po %p",a);
    
        __autoreleasing NSObject *c = [NSObject alloc];
        NSLog(@"在lldb输入:po %p",c);
        
        NSArray *d = [NSArray arrayWithObjects:@(1),@(2), nil];
        NSLog(@"在lldb输入:po %p",d);
        
        NSMutableArray *e = [NSMutableArray arrayWithObjects:@(1),@(2), nil];
        NSLog(@"在lldb输入:po %p",e);
        
        NSString *f = [[NSString alloc] initWithFormat:@"QuanGe"];
        NSLog(@"在lldb输入:po %p",f);
    }
    return 0;
}
```
结果

```
2017-04-01 16:51:02.180957 DrawMaster[5066:1602412] 在lldb输入:po 0x174018580
2017-04-01 16:51:02.181058 DrawMaster[5066:1602412] 在lldb输入:po 0x1740186d0
2017-04-01 16:51:02.181121 DrawMaster[5066:1602412] 在lldb输入:po 0x1740324a0
2017-04-01 16:51:02.181222 DrawMaster[5066:1602412] 在lldb输入:po 0x174053020
2017-04-01 16:51:02.181380 DrawMaster[5066:1602412] 在lldb输入:po 0xa0065476e6175516
(lldb) po 0x174018580
6241224064

(lldb) po 0x1740186d0
6241224400

(lldb) po 0x1740324a0
6241330336

(lldb) po 0x174053020
6241464352

(lldb) po 0xa0065476e6175516
QuanGe
```
哇塞，简直ko了其他任何方法，有没有，有没有。最简单的，最懒的代码才是好代码啊。

###### @autoreleasepool 在哪里会自动创建？

上面的代码再拿来用一下

```
int main(int argc, char * argv[]) {

    __asm__ ("bl __objc_autoreleasePoolPrint");
    NSArray *hh = [NSArray arrayWithObjects:@(2), nil];
    NSLog(@" %p",hh);
    __asm__ ("bl __objc_autoreleasePoolPrint");
    
    
    return 0;
}
```
注意看打印结果

```
objc[5072]: ##############
objc[5072]: AUTORELEASE POOLS for thread 0x1a92c0c40
objc[5072]: 0 releases pending.
objc[5072]: [0x1009f8000]  ................  PAGE  (hot) (cold)
objc[5072]: ##############
2017-04-01 17:08:48.870601 DrawMaster[5072:1604981]  0x17001b910
objc[5072]: ##############
objc[5072]: AUTORELEASE POOLS for thread 0x1a92c0c40
objc[5072]: 1 releases pending.
objc[5072]: [0x1009f8000]  ................  PAGE  (hot) (cold)
objc[5072]: [0x1009f8038]       0x17001b910  __NSSingleObjectArrayI
objc[5072]: ##############
```

打印结果中写的是自动释放池是线程0x1a92c0c40。也就是，当前main函数是在主线程中，我们并没有创建写@autoreleasepool{},其实已经有了。那么我自己创建的线程有么？来试一下：注意在`NSLog(@"QuanGe ");`打断点

```
@interface QGObject : NSObject
+ (QGObject*) allocOne;
+ (QGObject*) getOne;
@end

@implementation QGObject
- (void)dealloc
{
    NSLog(@"这里会释放内存");
}

+ (QGObject*) allocOne
{
    QGObject *qgobj = [[QGObject alloc] init];
    return qgobj;
}

+ (QGObject*) getOne
{
    QGObject *qgobj = [[QGObject alloc] init];
    return qgobj;
}
int main(int argc, char * argv[]) {
    __asm__ ("bl __objc_autoreleasePoolPrint");
    
    NSThread * thread = [[NSThread alloc] initWithBlock:^{
        __asm__ ("bl __objc_autoreleasePoolPrint");
        __weak QGObject * qg;
        qg = [QGObject getOne];
        NSLog(@"\n==========================================");
        NSLog(@"\n=====QuanGe object memeory adress %p======",qg);
        NSLog(@"\n==========================================");
        __asm__ ("bl __objc_autoreleasePoolPrint");
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop runUntilDate: [NSDate dateWithTimeIntervalSinceNow:10.0]];
    }];
    [thread setName:@"Thread-QuanGe"];
    [thread start];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"QuanGe ");
    });
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    [runLoop run];
    return 0;
}

```
断点以后在llpd打印上面输出的内存地址中的内容

```
objc[5458]: ##############
objc[5458]: AUTORELEASE POOLS for thread 0x1a92c0c40
objc[5458]: 0 releases pending.
objc[5458]: [0x100a50000]  ................  PAGE  (hot) (cold)
objc[5458]: ##############
objc[5458]: ##############
objc[5458]: AUTORELEASE POOLS for thread 0x16e0b3000
objc[5458]: 0 releases pending.
objc[5458]: [0x1023f4000]  ................  PAGE  (hot) (cold)
objc[5458]: ##############
2017-04-01 21:44:54.857499 DrawMaster[5458:1672309] 
==========================================
2017-04-01 21:44:54.857843 DrawMaster[5458:1672309] 
=====QuanGe object memeory adress 0x174019700======
2017-04-01 21:44:54.857881 DrawMaster[5458:1672309] 
==========================================
objc[5458]: ##############
objc[5458]: AUTORELEASE POOLS for thread 0x16e0b3000
objc[5458]: 1 releases pending.
objc[5458]: [0x1023f4000]  ................  PAGE  (hot) (cold)
objc[5458]: [0x1023f4038]       0x174019700  QGObject
objc[5458]: ##############
2017-04-01 21:45:04.860405 DrawMaster[5458:1672309] 这里会释放内存
(lldb) po 0x174019700
6241228544
```
实验表明 任何一个线程中都会有@autoreleasepool，而且在线程退出的时候会自动清理自动释放池里的对象。但是如果这个线程通过runloop来保持长久的等待，那么这个线程就不会结束，也就不会释放里面的对象，所以需要手动加上@autoreleasepool{}.例如main.m中就是手动加上的，如果不写的，里面的对象释放要等main线程的runloop结束也就是主线程结束也就是app退出，这不是太扯了么。



### 来看看哪些存放对象的数据结构

iOS都有哪些数据结构可以供我们使用：NSArray、NSMutableArray、NSDictionary、NSMutableDictionary、NSSet、NSMutableSet、NSHashTable、NSMapTable。

个人经验你只知道前面四个已经可以胜任工作了，但是，我们的目标不仅仅是完成任务，而是如何提高自己，挣更多的工资。

#### NSArray

##### 原理大揭秘

###### NSArray官方是如何打包给我们使用的

我们知道链接库分为动态链接库和静态链接库，动态链接库是运行的时候需要的，静态链接库是编译时候需要的。在windows中.lib是静态链接库.dll是动态链接库。

####### iOS动态链接库

而在iOS中.dylib是动态链接库，比如我们经常看的苹果开源代码objc编译以后就会生成`libobjc.A.dylib`，一般会放在系统目录中，我们随便打开一个项目，然后打开项目设置的Build Phases页面，在Link Binary With Libraries下面的+号点击，然后点击Orther 然后按下Command+Shift+G，就会提示你存放的动态链接库的目录`/usr/lib`，点击GO，你就会发现libobjc.A.dylib在这里哦,当然这是供PC上程序使用的。动态链接库实际功能使用有两种：第一是多个程序使用相同的函数等共享内存的问题，第二是因为是运行时需要，更新以后不需要编译，可以将各个功能模块话，程序更新的话只更新某个模块，这样的话就可以实现更新省时省力。

另外动态链接库是不需要存在APP中的，放在系统之中。

####### iOS静态链接库

iOS中静态链接指.a文件，一般配合着.h一起打包发布，一般我们使用的第三方的分享库比如微信，新浪微博等。之所以叫做静态，是因为静态库在编译的时候会被直接拷贝一份，复制到目标程序里，这段代码在目标程序里就不会再改变了。

####### framework

这是一个有个性的库的类型，既可以是动态链接库，又可以是静态链接库，创建一个`Cocoa Touch Framework`类型的项目，然后在项目属性中的`Linking`组有个`Mach-O Type`可以选择`Dynamic Library`也可以选择`Static Library`.那么别人打包好的，如何查看Mach-O类型，比如腾讯QQ的sdk，就是framework，打开TencentOpenAPI.framework，里面有Headers和TencentOpenAPI。先`cd`到sdk的framework目录下，然后通过file命令查看TencentOpenAPI，`file TencentOpenAPI`，结果如下

```
TencentOpenAPI: Mach-O universal binary with 5 architectures: [arm_v7: current ar archive] [arm_v7s] [i386] [x86_64] [arm64]
TencentOpenAPI (for architecture armv7):    current ar archive
TencentOpenAPI (for architecture armv7s):   current ar archive
TencentOpenAPI (for architecture i386): current ar archive
TencentOpenAPI (for architecture x86_64):   current ar archive
TencentOpenAPI (for architecture arm64):    current ar archive

```

看到`current ar archive`了么，说明是静态链接库，如果是类似`: Mach-O 64-bit dynamically linked shared library x86_64`说明是动态链接库

也可以通过`otool -v -h TencentOpenAPI`命令来查看头部

```
Archive : TencentOpenAPI
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1696 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1296 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1536 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1856 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1696 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1856 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1616 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1376 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1136 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1536 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1456 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1136 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1776 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1616 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1936 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1456 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1936 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3        656 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1456 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1536 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1696 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1456 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1696 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1216 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1536 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1296 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1536 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3        576 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1376 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1296 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1296 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1696 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1616 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1456 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3        576 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3        816 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1216 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1616 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1376 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1376 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3        896 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1856 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1536 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1056 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1456 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1216 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1696 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1536 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1456 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3        416 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1216 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1216 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1856 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3       1856 SUBSECTIONS_VIA_SYMBOLS
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      OBJECT     3        816 SUBSECTIONS_VIA_SYMBOLS

```

其中filetype 是`OBJECT`代表是静态链接库，如果`DYLIB`代表是静态动态链接库。


####### 总结

说了半天还没切入正题iOS的NSArray是怎么打包给我们开发者的，打开一个项目找到NSArray，按着command键鼠标点击就会跳转到头文件，在Xcode的上方会显示在`Simulator-iOS 10.2 ->Frameworks->Foundation->NSArray.h`，说明官方是用framework打包给我们使用的，找到应用程序Xcode，右键显示包内容->Contents->Developer->Platforms,你就可以看到所有平台的sdk了，打开iPhoneOS.platform->Developer->SDKs->iPhoneOS.sdk->System->Library->Frameworks ，所有用到的官方的Framework都在这里了，然而打开Foundation.framework，我们却没有找到Foundation二进制文件，只有Foundation.tbd，用cat命令读取一下`cat Foundation.tbd`,结果如下

```
--- !tapi-tbd-v2
archs:           [ armv7, armv7s, arm64 ]
uuids:           [ 'armv7: E142F79B-70E0-3D00-A159-395B0C46F375', 'armv7s: 24F45751-84CB-3FB6-B9B6-E94B051517AE', 
                   'arm64: 7D40355E-6850-36CC-8034-55E5CBF6245F' ]
platform:        ios
install-name:    /System/Library/Frameworks/Foundation.framework/Foundation
current-version: 1349.13
compatibility-version: 300.0
objc-constraint: none
exports:         
  - archs:           [ armv7, armv7s ]
    symbols:         [ '$ld$add$os2.0$_OBJC_CLASS_$_NSURL', '$ld$add$os2.0$_OBJC_METACLASS_$_NSURL', 
                       '$ld$add$os2.1$_OBJC_CLASS_$_NSURL', '$ld$add$os2.1$_OBJC_METACLASS_$_NSURL', 
                       '$ld$add$os2.2$_OBJC_CLASS_$_NSURL', '$ld$add$os2.2$_OBJC_METACLASS_$_NSURL', 
                       '$ld$add$os3.0$_OBJC_CLASS_$_NSURL', '$ld$add$os3.0$_OBJC_METACLASS_$_NSURL', 
                       '$ld$add$os3.1$_OBJC_CLASS_$_NSURL', '$ld$add$os3.1$_OBJC_METACLASS_$_NSURL', 
                       '$ld$add$os3.2$_OBJC_CLASS_$_NSURL', '$ld$add$os3.2$_OBJC_METACLASS_$_NSURL' ]
  - archs:           [ arm64 ]
    objc-ivars:      [ _NSPredicate.reserved ]
  - archs:           [ armv7, armv7s, arm64 ]
    re-exports:      [ /System/Library/Frameworks/CoreFoundation.framework/CoreFoundation, 
                       /usr/lib/libobjc.A.dylib ]
    symbols:         [ '$ld$add$os4.3$_NSHTTPCookieComment', '$ld$add$os4.3$_NSHTTPCookieCommentURL', 
                       '$ld$add$os4.3$_NSHTTPCookieDiscard', '$ld$add$os4.3$_NSHTTPCookieDomain', 
                       '$ld$add$os4.3$_NSHTTPCookieExpires', '$ld$add$os4.3$_NSHTTPCookieLocationHeader', 
                       '$ld$add$os4.3$_NSHTTPCookieManagerAcceptPolicyChangedNotification', 


```
里面写明了真正动态链接库的位置，/System/Library/Frameworks/Foundation.framework/Foundation。我们也可以打开mac上的这个地址，`file /System/Library/Frameworks/Foundation.framework/Foundation`。可以看到

```
/System/Library/Frameworks/Foundation.framework/Foundation: Mach-O universal binary with 2 architectures: [x86_64: Mach-O 64-bit dynamically linked shared library x86_64] [i386]
/System/Library/Frameworks/Foundation.framework/Foundation (for architecture x86_64):   Mach-O 64-bit dynamically linked shared library x86_64
/System/Library/Frameworks/Foundation.framework/Foundation (for architecture i386): Mach-O dynamically linked shared library i386
```

当然这只是模拟器使用的，如果要看苹果手机的这个文件就要到`/System/Library/Frameworks/Foundation.framework/Foundation`查看一二了，由于我这里也没有越狱的iPhone所有没有办法看。

另外这种.tbd格式是Xcode7.0以后才出现的，因为苹果的平台越来越多，为了节省空间，才这样搞，否则一个平台搞一套库，那得多大啊。

所以，我们从上面看出NSArray是通过framework动态链接库实现的，但是在iOS8.0之前苹果官方是不允许我们通过framework创建动态链接库供他人使用。好吧下面我们直接上例子。

##### 基础概念

在开始之前我们还要普及几个关键字

###### NSObject

如果你自定义个OC的类，基本都是最终都是要继承在这个类下面的。我们来看，它的定义

```
@interface NSObject <NSObject> {
    Class isa  OBJC_ISA_AVAILABILITY;
}

+ (void)load;

+ (void)initialize;
- (instancetype)init
#if NS_ENFORCE_NSOBJECT_DESIGNATED_INITIALIZER
    NS_DESIGNATED_INITIALIZER
#endif
    ;

+ (instancetype)new OBJC_SWIFT_UNAVAILABLE("use object initializers instead");
+ (instancetype)allocWithZone:(struct _NSZone *)zone OBJC_SWIFT_UNAVAILABLE("use object initializers instead");
+ (instancetype)alloc OBJC_SWIFT_UNAVAILABLE("use object initializers instead");
- (void)dealloc OBJC_SWIFT_UNAVAILABLE("use 'deinit' to define a de-initializer");

- (void)finalize OBJC_DEPRECATED("Objective-C garbage collection is no longer supported");

- (id)copy;
- (id)mutableCopy;

+ (id)copyWithZone:(struct _NSZone *)zone OBJC_ARC_UNAVAILABLE;
+ (id)mutableCopyWithZone:(struct _NSZone *)zone OBJC_ARC_UNAVAILABLE;

+ (BOOL)instancesRespondToSelector:(SEL)aSelector;
+ (BOOL)conformsToProtocol:(Protocol *)protocol;
- (IMP)methodForSelector:(SEL)aSelector;
+ (IMP)instanceMethodForSelector:(SEL)aSelector;
- (void)doesNotRecognizeSelector:(SEL)aSelector;

- (id)forwardingTargetForSelector:(SEL)aSelector OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0);
- (void)forwardInvocation:(NSInvocation *)anInvocation OBJC_SWIFT_UNAVAILABLE("");
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector OBJC_SWIFT_UNAVAILABLE("");

+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)aSelector OBJC_SWIFT_UNAVAILABLE("");

- (BOOL)allowsWeakReference UNAVAILABLE_ATTRIBUTE;
- (BOOL)retainWeakReference UNAVAILABLE_ATTRIBUTE;

+ (BOOL)isSubclassOfClass:(Class)aClass;

+ (BOOL)resolveClassMethod:(SEL)sel OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0);
+ (BOOL)resolveInstanceMethod:(SEL)sel OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0);

+ (NSUInteger)hash;
+ (Class)superclass;
+ (Class)class OBJC_SWIFT_UNAVAILABLE("use 'aClass.self' instead");
+ (NSString *)description;
+ (NSString *)debugDescription;

```

有没有看到NSObject有一个实例变量（注意实例变量访问符号用->，property访问用符号.），Class类型的变量isa，后面还有个修饰符 OBJC_ISA_AVAILABILITY。先看看Class到底是个啥吧,在class按command点击鼠标，进到objc/objc.h头文件

###### objc_class 

```
/// An opaque type that represents an Objective-C class.
typedef struct objc_class *Class;
```
进到objc_class 

```
struct objc_class {
    Class isa  OBJC_ISA_AVAILABILITY;

#if !__OBJC2__
    Class super_class                                        OBJC2_UNAVAILABLE;
    const char *name                                         OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
    struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
    struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
#endif

} OBJC2_UNAVAILABLE;
/* Use `Class` instead of `struct objc_class *` */

```
看到OBJC2_UNAVAILABLE了么，说明在现在的oc2.0中已经不支持objc_class了，和上面的OBJC_ISA_AVAILABILITY遥相呼应，如果你在代码中写aa->isa那么会提示你使用object_getClass(aa).

再进到object_getClass里面

```
/***********************************************************************
* object_getClass.
* Locking: None. If you add locking, tell gdb (rdar://7516456).
**********************************************************************/
Class object_getClass(id obj)
{
    if (obj) return obj->getIsa();
    else return Nil;
}
```

如果obj有值，则调用obj的getIsa方法。

###### id

```
/// A pointer to an instance of a class.
typedef struct objc_object *id;

```

id是objc_object类型的指针

###### objc_object

```
struct objc_object {
private:
    isa_t isa;

public:

    // ISA() assumes this is NOT a tagged pointer object
    Class ISA();

    // getIsa() allows this to be a tagged pointer object
    Class getIsa();

    // initIsa() should be used to init the isa of new objects only.
    // If this object already has an isa, use changeIsa() for correctness.
    // initInstanceIsa(): objects with no custom RR/AWZ
    // initClassIsa(): class objects
    // initProtocolIsa(): protocol objects
    // initIsa(): other objects
    void initIsa(Class cls /*indexed=false*/);
    void initClassIsa(Class cls /*indexed=maybe*/);
    void initProtocolIsa(Class cls /*indexed=maybe*/);
    void initInstanceIsa(Class cls, bool hasCxxDtor);

    // changeIsa() should be used to change the isa of existing objects.
    // If this is a new object, use initIsa() for performance.
    Class changeIsa(Class newCls);

    bool hasIndexedIsa();
    bool isTaggedPointer();
    bool isClass();

    // object may have associated objects?
    bool hasAssociatedObjects();
    void setHasAssociatedObjects();

    // object may be weakly referenced?
    bool isWeaklyReferenced();
    void setWeaklyReferenced_nolock();

    // object may have -.cxx_destruct implementation?
    bool hasCxxDtor();

    // Optimized calls to retain/release methods
    id retain();
    void release();
    id autorelease();

    // Implementations of retain/release methods
    id rootRetain();
    bool rootRelease();
    id rootAutorelease();
    bool rootTryRetain();
    bool rootReleaseShouldDealloc();
    uintptr_t rootRetainCount();

    // Implementation of dealloc methods
    bool rootIsDeallocating();
    void clearDeallocating();
    void rootDealloc();

private:
    void initIsa(Class newCls, bool indexed, bool hasCxxDtor);

    // Slow paths for inline control
    id rootAutorelease2();
    bool overrelease_error();

#if SUPPORT_NONPOINTER_ISA
    // Unified retain count manipulation for nonpointer isa
    id rootRetain(bool tryRetain, bool handleOverflow);
    bool rootRelease(bool performDealloc, bool handleUnderflow);
    id rootRetain_overflow(bool tryRetain);
    bool rootRelease_underflow(bool performDealloc);

    void clearDeallocating_slow();

    // Side table retain count overflow for nonpointer isa
    void sidetable_lock();
    void sidetable_unlock();

    void sidetable_moveExtraRC_nolock(size_t extra_rc, bool isDeallocating, bool weaklyReferenced);
    bool sidetable_addExtraRC_nolock(size_t delta_rc);
    size_t sidetable_subExtraRC_nolock(size_t delta_rc);
    size_t sidetable_getExtraRC_nolock();
#endif

    // Side-table-only retain count
    bool sidetable_isDeallocating();
    void sidetable_clearDeallocating();

    bool sidetable_isWeaklyReferenced();
    void sidetable_setWeaklyReferenced_nolock();

    id sidetable_retain();
    id sidetable_retain_slow(SideTable& table);

    uintptr_t sidetable_release(bool performDealloc = true);
    uintptr_t sidetable_release_slow(SideTable& table, bool performDealloc = true);

    bool sidetable_tryRetain();

    uintptr_t sidetable_retainCount();
#if DEBUG
    bool sidetable_present();
#endif
};
```

可以看到objc_object也有变量isa，私有的，只能通过getIsa访问

```
inline Class 
objc_object::ISA() 
{
    assert(!isTaggedPointer()); 
    return isa.cls;
}

inline Class 
objc_object::getIsa() 
{
#if SUPPORT_TAGGED_POINTERS
    if (isTaggedPointer()) {
        uintptr_t slot = ((uintptr_t)this >> TAG_SLOT_SHIFT) & TAG_SLOT_MASK;
        return objc_tag_classes[slot];
    }
#endif
    return ISA();
}

```

可以看到最终还是会访问实例变量isa，那么这个值是在那里初始化的呢？我们从alloc开始跟踪

```
+ (id)self {
    return (id)self;
}
+ (id)alloc {
    return _objc_rootAlloc(self);
}
// Base class implementation of +alloc. cls is not nil.
// Calls [cls allocWithZone:nil].
id
_objc_rootAlloc(Class cls)
{
    return callAlloc(cls, false/*checkNil*/, true/*allocWithZone*/);
}

// Call [cls alloc] or [cls allocWithZone:nil], with appropriate 
// shortcutting optimizations.
static ALWAYS_INLINE id
callAlloc(Class cls, bool checkNil, bool allocWithZone=false)
{
    if (checkNil && !cls) return nil;

#if __OBJC2__
    if (! cls->ISA()->hasCustomAWZ()) {
        // No alloc/allocWithZone implementation. Go straight to the allocator.
        // fixme store hasCustomAWZ in the non-meta class and 
        // add it to canAllocFast's summary
        if (cls->canAllocFast()) {
            // No ctors, raw isa, etc. Go straight to the metal.
            bool dtor = cls->hasCxxDtor();
            id obj = (id)calloc(1, cls->bits.fastInstanceSize());
            if (!obj) return callBadAllocHandler(cls);
            obj->initInstanceIsa(cls, dtor);
            return obj;
        }
        else {
            // Has ctor or raw isa or something. Use the slower path.
            id obj = class_createInstance(cls, 0);
            if (!obj) return callBadAllocHandler(cls);
            return obj;
        }
    }
#endif

    // No shortcuts available.
    if (allocWithZone) return [cls allocWithZone:nil];
    return [cls alloc];
}

id class_createInstance(Class cls, size_t extraBytes)
{
    if (UseGC) {
        return _class_createInstance(cls, extraBytes);
    } else {
        return (*_alloc)(cls, extraBytes);
    }
}

id (*_alloc)(Class, size_t) = _class_createInstance;

static id _class_createInstance(Class cls, size_t extraBytes)
{
    return _class_createInstanceFromZone (cls, extraBytes, nil);
}

id 
_class_createInstanceFromZone(Class cls, size_t extraBytes, void *zone)
{
    void *bytes;
    size_t size;

    // Can't create something for nothing
    if (!cls) return nil;

    // Allocate and initialize
    size = cls->alignedInstanceSize() + extraBytes;

    // CF requires all objects be at least 16 bytes.
    if (size < 16) size = 16;

#if SUPPORT_GC
    if (UseGC) {
        bytes = auto_zone_allocate_object(gc_zone, size,
                                          AUTO_OBJECT_SCANNED, 0, 1);
    } else 
#endif
    if (zone) {
        bytes = malloc_zone_calloc((malloc_zone_t *)zone, 1, size);
    } else {
        bytes = calloc(1, size);
    }

    return objc_constructInstance(cls, bytes);
}

id 
objc_constructInstance(Class cls, void *bytes) 
{
    if (!cls  ||  !bytes) return nil;

    id obj = (id)bytes;

    obj->initIsa(cls);

    if (cls->hasCxxCtor()) {
        return object_cxxConstructFromClass(obj, cls);
    } else {
        return obj;
    }
}

```

从上面代码可以看到最终调用obj->initIsa(cls);的参数是通过NSObject的self类方法传递进去的，然后self直接返回的是(id)self。也就是在OC中类本来就是对象，也就是说object_getClass(aa)返回的是类对象，我们可以通过对比内存地址，来简单分析下，类对象

```
static int b = 10;
NSObject *so = [NSObject alloc];
NSLog(@"%p",object_getClass(so));
NSLog(@"%p",so);
NSLog(@"%p",&so);
NSLog(@"%p",@(2));
NSLog(@"%p",@"aa");
int a = 0;
NSLog(@"%p",&a);
NSLog(@"%p",&b);

```
输出

```
2017-04-11 11:24:26.269 DrawMaster[58811:1271136] 0x104fa2e58
2017-04-11 11:24:26.269 DrawMaster[58811:1271136] 0x61000001e120
2017-04-11 11:24:26.269 DrawMaster[58811:1271136] 0x7fff5f2db648
2017-04-11 11:24:26.270 DrawMaster[58811:1271136] 0xb000000000000022
2017-04-11 11:24:26.270 DrawMaster[58811:1271136] 0x100d5d1c0
2017-04-11 11:24:26.270 DrawMaster[58811:1271136] 0x7fff5f2db644
2017-04-11 11:24:26.270 DrawMaster[58811:1271136] 0x100e136f0
```

可以看到内存地址与字符串常量和静态变量的内存地址相近，说明类对象是放在数据区的。

##### List源码分析

在objc中有个List类，虽然不用了，但是我们可以学习一下，首先数组里的内容如何保存，List是放在了一个指针数组里面

```
@interface List : Object
{
@public
    id      *dataPtr  DEPRECATED_ATTRIBUTE; /* data of the List object */
    unsigned    numElements  DEPRECATED_ATTRIBUTE;  /* Actual number of elements */
    unsigned    maxElements  DEPRECATED_ATTRIBUTE;  /* Total allocated elements */
}

```

在创建的时候初始化使用C函数malloc申请一块内存

```
#define DATASIZE(count) ((count) * sizeof(id))
- (id)initCount:(unsigned)numSlots
{
    maxElements = numSlots;
    if (maxElements) 
    dataPtr = (id *)malloc(DATASIZE(maxElements));
    return self;
}

```
当插入元素检查是否需要扩容，如果需要使用realloc

```
- (id)insertObject:anObject at:(unsigned)index
{
    register id *this, *last, *prev;
    if (! anObject) return nil;
    if (index > numElements)
        return nil;
    if ((numElements + 1) > maxElements) {
    volatile id *tempDataPtr;
    /* we double the capacity, also a good size for malloc */
    maxElements += maxElements + 1;
    tempDataPtr = (id *) realloc (dataPtr, DATASIZE(maxElements));
    dataPtr = (id*)tempDataPtr;
    }
    this = dataPtr + numElements;
    prev = this - 1;
    last = dataPtr + index;
    while (this > last) 
    *this-- = *prev--;
    *last = anObject;
    numElements++;
    return self;
}

```
##### 下标访问

```
- (void)setObject:(id)object forKeyedSubscript:(id < NSCopying >)aKey;
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

```

##### MRC和ARC兼容

如果你写的代码本来是MRC，如果你直接将代码给ARC的项目使用会有问题,三种方式解决

1、Xcode ->Edit->Convert->to Object-C ARC，复杂的会出错

2、项目属性->Build Phases->Complier Flags->-fno-objc-arc 如果文件多的话可以使用[xproj](https://github.com/qfish/xproj)Shell脚本

3、打包成.a静态库


##### 真机和模拟器兼容

New->Target->Aggregate->在target的Build Phases中点加号 添加一个Run Script

```
set -e
set +u
# Avoid recursively calling this script.
if [[ $SF_MASTER_SCRIPT_RUNNING ]]
then
exit 0
fi
set -u
export SF_MASTER_SCRIPT_RUNNING=1

SF_TARGET_NAME=${PROJECT_NAME}
SF_EXECUTABLE_PATH="${SF_TARGET_NAME}.framework/${SF_TARGET_NAME}"
SF_WRAPPER_NAME="${SF_TARGET_NAME}.framework"

if [[ "$SDK_NAME" =~ ([A-Za-z]+) ]]
then
SF_SDK_PLATFORM=${BASH_REMATCH[1]}
else
echo "Could not find platform name from SDK_NAME: $SDK_NAME"
exit 1
fi

if [[ "$SDK_NAME" =~ ([0-9]+.*$) ]]
then
SF_SDK_VERSION=${BASH_REMATCH[1]}
else
echo "Could not find sdk version from SDK_NAME: $SDK_NAME"
exit 1
fi

if [[ "$SF_SDK_PLATFORM" = "iphoneos" ]]
then
SF_OTHER_PLATFORM=iphonesimulator
else
SF_OTHER_PLATFORM=iphoneos
fi

if [[ "$BUILT_PRODUCTS_DIR" =~ (.*)$SF_SDK_PLATFORM$ ]]
then
SF_OTHER_BUILT_PRODUCTS_DIR="${BASH_REMATCH[1]}${SF_OTHER_PLATFORM}"
else
echo "Could not find platform name from build products directory: $BUILT_PRODUCTS_DIR"
exit 1
fi

rm -rf buildProducts
mkdir buildProducts

# Build the other platform.
xcrun xcodebuild -project "${PROJECT_FILE_PATH}" -target "${TARGET_NAME}" -configuration "${CONFIGURATION}" -sdk ${SF_OTHER_PLATFORM}${SF_SDK_VERSION} BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}" SYMROOT="${SYMROOT}" $ACTION

# Smash the two static libraries into one fat binary and store it in the .framework
xcrun lipo -create "${BUILT_PRODUCTS_DIR}/$PRODUCT_NAME.framework/$PRODUCT_NAME" "${SF_OTHER_BUILT_PRODUCTS_DIR}/$PRODUCT_NAME.framework/$PRODUCT_NAME" -output "${PROJECT_DIR}/buildProducts/$PRODUCT_NAME"

cp -rf ${BUILT_PRODUCTS_DIR}/$PRODUCT_NAME.framework ${PROJECT_DIR}/buildProducts
mv ${PROJECT_DIR}/buildProducts/$PRODUCT_NAME ${PROJECT_DIR}/buildProducts/$PRODUCT_NAME.framework
```

然后将需要给外界的头文件放在属性->Build Phases ->Headers 的public位置





