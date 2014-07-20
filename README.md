Pcap_DNSProxy
=====
A local DNS server base on WinPcap and LibPcap.

### 关于分支
本分支 Release 为 Pcap_DNSProxy 项目的编译版本，**源代码等请移步 [master 主分支](https://github.com/chengr28/pcap_dnsproxy)**

### 使用方法
* Windows 版参见 [Wiki](https://github.com/chengr28/pcap_dnsproxy/wiki) 中 [ReadMe](https://github.com/chengr28/pcap_dnsproxy/wiki/ReadMe) 之内容
* Linux 版参见 [Wiki](https://github.com/chengr28/pcap_dnsproxy/wiki) 中 [ReadMe_Linux](https://github.com/chengr28/pcap_dnsproxy/wiki/ReadMe_Linux) 之内容
* Mac 版参见 [Wiki](https://github.com/chengr28/pcap_dnsproxy/wiki) 中 [ReadMe_Mac](https://github.com/chengr28/pcap_dnsproxy/wiki/ReadMe_Mac) 之内容

### 最新版本
* **Windows 版本：v0.4 Beta(2014-07-20)**
* **Linux 版本：v0.2(2014-03-02)**
* **Mac 版本：v0.1(2014-03-02)**

### 支持平台
* 本工具**抓包模块**所支持的网络类型
  * 网络设备类型为 Ethernet 的网络
  * 原生IPv4网络和原生IPv6网络**（非原生IPv6网络环境切勿开启IPv6功能）**
  * 基于PPPoE或PPPoEv6的IPv4网络和IPv6网络
  * 如果需要支持更多网络类型，可与作者联系
* Windows 平台
    * **所有 Windows XP/2003 以及更新内核的版本(32位/x86版本)和 Windows Vista/2008 以及更新的版本(64位/x64版本)**
    * 支持最新版本 [WinPcap](http://www.winpcap.org/install/default.htm)
* Linux 平台
    * 支持 [编译所需依赖包](https://github.com/chengr28/pcap_dnsproxy/wiki/ReadMe_Linux) 的Linux发行版
    * 支持最新版本 [Libpcap](http://www.tcpdump.org)
* Mac 平台
    * **采用Intel平台处理器的 Mac OS X 10.5 Leopard 以及更新的版本**

### 许可证
GNU General Public License/GNU GPL v2
