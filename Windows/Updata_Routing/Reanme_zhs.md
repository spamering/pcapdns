## 服用方法

 - 选择Updata_gb2312.bat打开

## 可选参数

 - -LOCAL   (从上次的缓存中重建)


## 本地文件相关

 - #Routingipv4#   (仅ipv4路由表独立缓存)
 - #Routingipv6#   (仅ipv6路由表独立缓存)
 - delegated-apnic-latest   (上次抓取的原始apnic路由表文件)
 - Log_Lib   (ipv4非掩码长度转换为ipv6前缀长度的映射库, 删除会影响路由表生成速度, 更新时还会生成此文件)
 - latest文件夾   (用于进行更新比对的缓存文件)
 - Routing.txt   (最终生成的可用路由表文件, 直接剪切或拷贝替换上级目录同名文件即可)