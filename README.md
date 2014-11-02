Pcap_DNSProxy
=====
A local DNS server base on WinPcap and LibPcap.

### Branch
本分支 Release 为 Pcap_DNSProxy 项目的编译版本，**源代码请移步 [master 主分支](https://github.com/chengr28/Pcap_DNSProxy)**

### Usage
* Windows 版参见 [Wiki](https://github.com/chengr28/Pcap_DNSProxy/wiki) 的 [ReadMe](https://github.com/chengr28/Pcap_DNSProxy/wiki/ReadMe)
* Linux 版参见 [Wiki](https://github.com/chengr28/Pcap_DNSProxy/wiki) 的 [ReadMe_Linux](https://github.com/chengr28/Pcap_DNSProxy/wiki/ReadMe_Linux)
* Mac 版参见 [Wiki](https://github.com/chengr28/Pcap_DNSProxy/wiki) 的 [ReadMe_Mac](https://github.com/chengr28/Pcap_DNSProxy/wiki/ReadMe_Mac)

### Updated
* **Windows：0.4 Beta(2014-11-02)**
* **Linux：0.2(2014-08-19)**
* **Mac：0.1(2014-08-19)**

### Platform
* 本工具**抓包模块**所支持的网络类型
  * 网络设备类型为 Ethernet 的网络
  * 原生IPv4网络和原生IPv6网络**（非原生IPv6网络环境建议不要开启IPv6功能）**
  * 基于PPPoE或PPPoEv6的IPv4网络和IPv6网络
  * 如果需要支持更多网络类型，可与作者联系
* Windows 平台
    * **所有 Windows XP/2003 以及更新内核的版本(32位/x86版本)和 Windows Vista/2008 以及更新的版本(64位/x64版本)**
    * 支持最新版本 [WinPcap](http://www.winpcap.org/install/default.htm)
* Linux 平台
    * 支持 [编译所需依赖包](https://github.com/chengr28/Pcap_DNSProxy/wiki/ReadMe_Linux) 的Linux发行版
    * 支持最新版本 [Libpcap](http://www.tcpdump.org)
* Mac 平台
    * **采用Intel平台处理器的 Mac OS X 10.5 Leopard 以及更新的版本**

### License
GNU General Public License/GNU GPL v2
