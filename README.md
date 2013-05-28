nagios_conf
===========

ネットワーク機器の情報からNagios設定ファイル(インタフェース周りの監視設定)を自動生成するためのスクリプト。
CiscoとJuniperに対応。


## 入力とするコマンド

|MAKER  |COMMAND                    |
|:------|:--------------------------|
|cisco  |show snmp mib ifmib ifindex|
|juniper|show interfaces            |



## usage

- usage

`$ ruby generate_nagios_conf.rb [INPUT FILE] [MAKER]`


- example

`$ ruby generate_nagios_conf.rb input/HOSTNAME_CISCO.txt cisco`

