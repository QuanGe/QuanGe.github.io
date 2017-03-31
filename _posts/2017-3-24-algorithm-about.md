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






先来看看 iOS都有哪些数据结构可以供我们使用。NSArray、NSMutableArray、NSDictionary、NSMutableDictionary、NSSet、NSMutableSet、NSHashTable、NSMapTable。

个人经验你只知道前面四个已经可以胜任工作了，但是，我们的目标不仅仅是完成任务，而是如何提高自己，挣更多的工资。

### NSArray


