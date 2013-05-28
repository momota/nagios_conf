nagios_conf
===========

ネットワーク機器の情報からNagios設定ファイル(インタフェース周りの監視設定)を自動生成するためのスクリプト。
CiscoとJuniperに対応。

- 以下のCiscoコマンド結果を入力する
  show snmp mib ifmib ifindex
- 以下のJuniperコマンド結果を入力する
  show interfaces


## usage

  $ ruby generate_nagios_conf.rb [INPUT FILE] [MAKER]
  
  (example)
  $ ruby generate_nagios_conf.rb input/HOSTNAME_CISCO.txt cisco
