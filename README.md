nagios_conf
===========

ネットワーク機器の情報からNagios設定ファイル(インタフェース周りの監視設定)を自動生成するためのスクリプト。
CiscoとJuniperに対応。ruby 2.0.0-p0 (CentOS release 6.3)で動作確認済み。

nagiosのcheck_snmpプラグインを用いてインタフェース監視定義を作成する上で、ifindexをOIDの末尾に付けて設定する必要があった、
かつ、ifindexが特定のコマンド出力により得られることから作成。(ちなみにifindexはインタフェース番号とリンクしない)




## input file

|MAKER  |COMMAND                    |
|:------|:--------------------------|
|cisco  |show snmp mib ifmib ifindex|
|juniper|show interfaces            |

上記コマンドの結果を、ファイルに保存する。
ファイル名には、ホスト名を付ける。(拡張子はなんでもよい。)


sampleは`input/`以下を参照。



## usage

- usage

`generate_nagios.rb`の第一引数に上述したファイルを、第二引数にメーカ(cisco / juniper)を渡す。
結果は、`output_nagios/`以下に同一ファイル名で出力する。

    $ ruby generate_nagios_conf.rb [INPUT_FILE] [MAKER]



- example

`$ ruby generate_nagios_conf.rb input/HOSTNAME_CISCO.txt cisco`
