# java-iec104(iec60870-5-104)-modbus数据传输实现

`APDU`:应用规约数据单元；
`ASDU`:应用服务数据单元；
`APCI`:应用规约控制信息；
iec104默认端口为2404；

## openmuc:j60870关键源码分析

### ConnectionEventListner接口

```
public interface ConnectionEventListener {

    /**
     * Invoked when a new ASDU arrives.
     *
     * @param aSdu
     *            the ASDU that arrived.
     */
    public void newASdu(ASdu aSdu);

    /**
     * Invoked when an IOException occurred while listening for incoming ASDUs. An IOException implies that the
     * {@link Connection} that feeds this listener was automatically closed and can no longer be used to send commands
     * or receive ASDUs.
     *
     * @param e
     *            the exception that occurred.
     */
    public void connectionClosed(IOException e);

}
```

`newASdu`方法会在ASDU到达时被调用，该方法应该被重写；

### connection类

* 用于表示服务器和客户端的连接，可以通过`ClientConnectionBuilder`实例创建或传递给`ServerEventListener`
* `Connection`一旦被关闭，无法再被打开
* 新建立的连接是成功建立到服务器的TCP/IP连接
* `Connection`在接收`ASDU`或发送命令前，必须调用`Connection`的`startDataTransfer(ConnectionEventListener, int)`方法或`Connection`的`waitForStartDT(ConnectionEventListener, int)`方法
* 之后将传入的`ASDU`转发到`ConnectionEventListener`
* 传入的`ASDU`排队，所以`ConnectionEventListener`中的`newASdu(ASdu)`方法从不会为同一连接同时调用

>Represents a connection between a client and a server. It is created either through an instance of {@link ClientConnectionBuilder} or passed to {@link ServerEventListener}. Once it has been closed it cannot be opened again. A newly created connection has successfully build up a TCP/IP connection to the server. Before receiving ASDUs or sending commands one has to call {@link Connection#startDataTransfer(ConnectionEventListener, int)} or {@link Connection#waitForStartDT(ConnectionEventListener, int)}. Afterwards incoming ASDUs are forwarded to the {@link ConnectionEventListener}. Incoming ASDUs are queued so that {@link ConnectionEventListener#newASdu(ASdu)} is never called simultaneously for the same connection.

>Connection offers a method for every possible command defined by IEC 60870 (e.g. singleCommand). Every command function may throw an IOException indicating a fatal connection error. In this case the connection will be automatically closed and a new connection will have to be built up. The command methods do not wait for an acknowledgment but return right after the command has been sent.

### startDataTransfer

```
／**
 * 启动连接。
 * 发送STARTDT命令并等待STARTDT命令。
 * 如果成功，将启动新的线程，侦听传入的ASDU并通知给定的ASduListener。
 * 
 * @param listener ASDU要通知的ASduListener
 * @param timeout 发送STARTDT ACT消息后等待STARDT CON消息的最大时间（以毫秒为单位）。
 *                如果设置为零，则禁用超时。
 *／
public void startDataTransfer(ConnectionEventListener listener, int timeout) throws IOException, TimeoutException {
   if (timeout < 0) {
       throw new IllegalArgumentException("timeout may not be negative");
   }

   synchronized (this) {
       startdtConSignal = new CountDownLatch(1);
       os.write(STARTDT_ACT_BUFFER, 0, STARTDT_ACT_BUFFER.length);
   }
   os.flush();

   if (timeout == 0) {
       try {
           startdtConSignal.await();
       } catch (InterruptedException e) {
       }
   }
   else {
       boolean success = true;
       try {
           success = startdtConSignal.await(timeout, TimeUnit.MILLISECONDS);
       } catch (InterruptedException e) {
       }
       if (!success) {
           throw new TimeoutException();
       }
   }

   synchronized (this) {
       this.aSduListener = listener;
       dataTransferStarted = true;
   }
}
```

### CountDownLatch

```
A synchronization aid that allows one or more threads to wait until a set of operations being performed in other threads completes.

 <p>A {@code CountDownLatch} is initialized with a given <em>count</em>.
The {@link #await await} methods block until the current count reaches zero due to invocations of the {@link #countDown} method, after which all waiting threads are released and any subsequent invocations of {@link #await await} return immediately. 
 This is a one-shot phenomenon -- the count cannot be reset.  If you need a version that resets the count, consider using a {@link CyclicBarrier}.
 *
 * <p>A {@code CountDownLatch} is a versatile synchronization tool and can be used for a number of purposes.  A {@code CountDownLatch} initialized with a count of one serves as a simple on/off latch, or gate: all threads invoking {@link #await await} wait at the gate until it is opened by a thread invoking {@link #countDown}.  A {@code CountDownLatch} initialized to <em>N</em> can be used to make one thread wait until <em>N</em> threads have  completed some action, or some action has been completed N times.
 *
 * <p>A useful property of a {@code CountDownLatch} is that it doesn't require that threads calling {@code countDown} wait for the count to reach zero before proceeding, it simply prevents any thread from proceeding past an {@link #await await} until all threads could pass.
 *
 * <p><b>Sample usage:</b> Here is a pair of classes in which a group
 * of worker threads use two countdown latches:
 * <ul>
 * <li>The first is a start signal that prevents any worker from proceeding
 * until the driver is ready for them to proceed;
 * <li>The second is a completion signal that allows the driver to wait
 * until all workers have completed.
 * </ul>
 *
 *  <pre> {@code
 * class Driver { // ...
 *   void main() throws InterruptedException {
 *     CountDownLatch startSignal = new CountDownLatch(1);
 *     CountDownLatch doneSignal = new CountDownLatch(N);
 *
 *     for (int i = 0; i < N; ++i) // create and start threads
 *       new Thread(new Worker(startSignal, doneSignal)).start();
 *
 *     doSomethingElse();            // don't let run yet
 *     startSignal.countDown();      // let all threads proceed
 *     doSomethingElse();
 *     doneSignal.await();           // wait for all to finish
 *   }
 * }
 *
 * class Worker implements Runnable {
 *   private final CountDownLatch startSignal;
 *   private final CountDownLatch doneSignal;
 *   Worker(CountDownLatch startSignal, CountDownLatch doneSignal) {
 *     this.startSignal = startSignal;
 *     this.doneSignal = doneSignal;
 *   }
 *   public void run() {
 *     try {
 *       startSignal.await();
 *       doWork();
 *       doneSignal.countDown();
 *     } catch (InterruptedException ex) {} // return;
 *   }
 *
 *   void doWork() { ... }
 * }}</pre>
 *
 * <p>Another typical usage would be to divide a problem into N parts,
 * describe each part with a Runnable that executes that portion and
 * counts down on the latch, and queue all the Runnables to an
 * Executor.  When all sub-parts are complete, the coordinating thread
 * will be able to pass through await. (When threads must repeatedly
 * count down in this way, instead use a {@link CyclicBarrier}.)
 *
 *  <pre> {@code
 * class Driver2 { // ...
 *   void main() throws InterruptedException {
 *     CountDownLatch doneSignal = new CountDownLatch(N);
 *     Executor e = ...
 *
 *     for (int i = 0; i < N; ++i) // create and start threads
 *       e.execute(new WorkerRunnable(doneSignal, i));
 *
 *     doneSignal.await();           // wait for all to finish
 *   }
 * }
 *
 * class WorkerRunnable implements Runnable {
 *   private final CountDownLatch doneSignal;
 *   private final int i;
 *   WorkerRunnable(CountDownLatch doneSignal, int i) {
 *     this.doneSignal = doneSignal;
 *     this.i = i;
 *   }
 *   public void run() {
 *     try {
 *       doWork(i);
 *       doneSignal.countDown();
 *     } catch (InterruptedException ex) {} // return;
 *   }
 *
 *   void doWork() { ... }
 * }}</pre>
 *
 * <p>Memory consistency effects: Until the count reaches
 * zero, actions in a thread prior to calling
 * {@code countDown()}
 * <a href="package-summary.html#MemoryVisibility"><i>happen-before</i></a>
 * actions following a successful return from a corresponding
 * {@code await()} in another thread.
```

### 协议InputStream

```
# 允许登陆
0x69 0xae -> 0x69 0xfd 0xee 0x61
# TIME REQUEST 回复时间戳
0x69 0xbb -> 0x69 0x06 0x58 0x5F 0x62 0xF9 0x4B 0x72
# 配置第一帧
0x69 0xbf -> 0x69 0x04 0x04 0x01 0x9f 0x79
# 配置第二帧
0x69 0xba -> 0x69 0x04 0x01 0x00 0x01 0x00 0x03 0x03 0x03 0x00 0x00 0x02 0x01 0x00 0x00 0x01 0x00 0x01 0x00 0x01 0x00 0x02 0x00 0x04 0x8E 0x8D
# 配置第三帧
0x69 0xbf -> 0x69 0x04 0x02 0x00 0x02 0x01 0x01 0xFB 0xD2
# 结束配置帧
0x69 0xba -> 0x69 0x04 0x03 0xE3 0x1D
# VERSION
0x69 0x88 -> 0x69 0x0A 0xaf 0xe7
```

### Iec104Runner.java执行过程

继承`CommandLineRunner`的java类为随SpringBoot容器启动执行的，
容器启动后将自动执行其中的run方法，
run方法调用了ClientApp中的startRunner方法，该方法通过`ClientConnectionBuilder`类调用Connection的构造方法创建`Connection`实例，
`Connection`实例调用内部类`ConnectionReader`，启动子线程；

ConnectionReader线程中读取inputStream，判断输入流字节数组是否以`0x69`开始；
ConnectionReader根据输入流创建不可变的APDU实例(调用`final APDU aPDU = new APDU(is, setting)`构造方法，该构造方法中将通过对is的判断，指定该APDU实例的类型)，
ConnectionReader根据不同的APDU实例类型，做不同的操作，之后调用`resetMaxIdleTimeTimer`，flush()出不同的ack；

## 知识点

* ServerSocket
* InetAddress
* ServerSocketFactory
* DatagramSocket
* ExecutorService
* @SuppressWarnings
* ScheduledExecutorService
* Runtime

## ASdu

`ASdu`包括以下内容：

* 1byte的typeId
* 1byte的variable structure qualfier
* 1or2byte的case of transmission
* 1or2byte的common address of asdu
* a list of information objects

## ClientConnectionBuilder

* 一个客户端应用程序想要连接到104服务，必须先创建一个`ClientConnectionBuilder`的实例。设置所有必须的配置参数。最终调用`connect`方法连接到104服务。
* 一个`ClientConnectionBuilder`实例可以创建无限多个连接。
* 修改`ClientConnectionBuilder`对于已经创建的连接没有影响。
* 对于网络中的所有的通信节点，COT、CA、IOA的字段长度必须相同。 
