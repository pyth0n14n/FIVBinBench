# FIVBinBench

[English README is here](./README.md)

A Binary-Level Benchmark Dataset for Fault Injection Vulnerability Detection
発音: **/ˈfaɪvɪnbɛntʃ/** （ファイヴィンベンチ）または **/ˈfɪvɪnbɛntʃ/** （フィヴビンベンチ）

## 概要

FIVBinBenchは、フォールトインジェクション攻撃（Fault Injection Attack: FIA）に対するバイナリレベル脆弱性検出ツール（以降、FVD (Fault Vulnerability Detection) ツールと呼ぶ）の評価用データセットである。本データセットは、オープンソースのFVDツール群を用いて複数のアーキテクチャ上のバイナリに対してフォールト脆弱性検出を行い、手動検証を経て真値付きの脆弱性ラベルデータセットを整備したものである。ターゲットアプリケーションには、[FISSC](https://lazart.gricad-pages.univ-grenoble-alpes.fr/fissc/) (Fault Injection and Simulation Secure Collection) のVerifyPINを採用した。  

ここでは、FVDデータセットと、その作成に使用したFVDツール、設定、解析スクリプトを提供する。

### FVDツールとターゲットアーキテクチャ

| Tool                      | ARMv7m | ARMv7a | x86 |
|---------------------------|--------|--------|-----|
| FaultFinder               | &check;  | &check; | &check; |
| Archie                    | &check;  | - | -|
| Armory                    | &check;  | - | - |
| ChaosDuck                 | - | &check; |&check; |
| FaultArm                  | - | &check;| &check;|
| FaultInjectionSimulator   | - | - |&check; |
| fault-injection-simulation| &check; | &check; | - |

**注意:** datasetや評価スクリプト内では、ARMv7aを"PIE" (Position Independent Executable) と表現しています。

## 梱包物（構成）

| ディレクトリ  | 内容                                      |  ライセンス            |
| --------------- | --------------------------------------- | ---------------------- |
| `dataset/`      | 真値付き脆弱性データセット              | 個別                   |
| ┃  `binary/`    | 評価対象バイナリ                        | GNU LGPLv3 (FISSC継承) |
| ┃  `asm/`       | 評価対象アセンブリ (FaultArmでのみ使用) | GNU LGPLv3 (FISSC継承) |
| ┃  `result/`    | 真値付き脆弱性リスト(TSV)               | Mitsubishiライセンス   |
| ┗  `build/`     | ビルド設定 (binary/asm作成に使用)       | Mitsubishiライセンス   |
| `eval_scripts/` | 評価スクリプト・設定ファイル等          | Mitsubishiライセンス   |
| `tools/`        | FVDツール群                             | 各ツール準拠           |

詳細は、ディレクトリ内のREADMEをご覧ください。

**dataset/binary補足** `elf`と`map`のほかに、`gdb.bin`というファイルがあります。これは、FaultFinderで使用するターゲットバイナリで、GDBで`main()`まで実行した後にcode領域をダンプしたものです。Rehostingと呼ばれる手法の一要素です（詳細は、[論文](#出版と引用)をご覧ください）。

## 真値付き脆弱性リスト

真値付き脆弱性リストは下図のとおり。これは、ARMv7mにおける1ビット反転モデルの脆弱性リストです。
命令スキップモデル (IS: Instruction Skip)、命令の1 bit-flipモデル (BFI: Bit-Flip Instruciton)、レジスタの1 bit-flipモデル (BFR: Bit-Flip Register)の結果が示されています。

![BFI説明](./fig/result_desc.jpg)

他のフォールトモデルを含めた読み方は次のとおり：

- バイナリ情報
  - IP: 命令ポインタ（命令アドレス）
  - code: 機械語
  - opcode: オペコード
  - oprand: オペランド
  - mask: ビット反転モデルのマスク値 (0はマスクなしの正常な命令)
  - reg: レジスタのビット反転モデルのマスク値 (空欄はマスクなしの正常な命令)
- 評価結果
  - 各ツールでのフォールト脆弱性検出結果
- 手動検証結果
  - Grand Truth: 手動検証により得られた真値
  - Type: 誤分類 (誤検出および見逃し) がある場合、その理由を分類 詳細は、[論文](#出版と引用)をご覧ください
  - Reason: フォールトにより何が起こるかを解釈し、ツールの検出結果が正しいかを理由付けしたもの

## 検証

下記の手順でFVDツールを動作させ、その結果を整理することで、本データセットの作成を追体験できます。

### 検証環境
[論文](#出版と引用)における検証環境は次のとおり（必須要件ではないことに注意ください）：

| 項目     | バージョン・備考                 |
| ------ | ------------------------ |
| OS     | Windows 11 (22H2) |
| Linux  | Ubuntu 24.04.1 (WSL2)    |
| CPU    | Intel Core i5-8500 (6コア) |
| RAM    | 56GB                     |
| gcc    | 13.3.0                   |
| Python | 3.12.3                  |

### 利用方法

1. リポジトリのコピー（サブモジュール含む）
   ```sh
   $ git clone --recurse-submodules https://github.com/pyth0n14n/FIVBinBench.git
   ```
2. 必要なツールのビルド/インストール
   各 `tools/` 配下の各ツールのREADME参照
3. データセットや評価スクリプトの利用
   `eval_scripts/` を各種 `tools/` に移動
4. ツールで脆弱性を検出する。
   `dataset/binary`にあるバイナリから脆弱性を検証する。
5. ツールの検出結果を統合する
   それぞれ出力形式が異なるため、IPおよびフォールトモデルに合わせて統合することで、`dataset/result`と同じ結果が得られるはずです。

### 検証例 (FaultFinder)

FaultFinder (Rehostingあり) による検証結果は次のとおり。

- Print Stats では、各アドレスにメモリ状態が設定されている。これが、Rehostingによるデータの移植である。
- 16個の命令スキップ脆弱性が特定されている。

```sh
$ ./run_fault_finder.sh v7m fault-is
~~~ Run details  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 >> json filename:          eval/v7m/jsons/binary-details.json
 >> run mode:               fault
...

~~~ FAULTS TO EMULATE  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Fault: 4-200
  Instruction Pointer 
...

~~~~~~~~~~~~~~~~~~ Print Stats  ~~~~~~~~~~~~~~~~~~~~~~
 >> Binary file under test:      eval/bins/verifypin_0_arm_v7m.bin
 >> Input 0 at address: 0x0 provided:  00200020a9010008000000000...
 >> Input 1 at address: 0x40003808 provided:  0a0000000000000007000...
 >> Input 2 at address: 0x40004400 provided:  c0
...

#extracted: 16
Extracted Fault Addresses: 16
0x800004c  : InstructionPointer SKIP  
0x800004e  : InstructionPointer SKIP  
0x800005c  : InstructionPointer SKIP  
0x8000068  : InstructionPointer SKIP  
0x800006a  : InstructionPointer SKIP  
0x8000072  : InstructionPointer SKIP  
0x8000074  : InstructionPointer SKIP  
0x8000076  : InstructionPointer SKIP  
0x8000078  : InstructionPointer SKIP  
0x800009a  : InstructionPointer SKIP  
0x80000a8  : InstructionPointer SKIP  
0x8000118  : InstructionPointer SKIP  
0x8000124  : InstructionPointer SKIP  
0x800012e  : InstructionPointer SKIP  
0x800013a  : InstructionPointer SKIP  
0x8000162  : InstructionPointer SKIP  
```


## 出版と引用

本データセットおよびリポジトリを論文内で引用する場合、下記を参考にしてください。
```bibtex
@misc{nashimoto2025fivbinbench,
  author = {Nashimoto, Shoei},
  title = {{FIVBinBench: A Binary-Level Benchmark Dataset for Fault Injection Vulnerability Detection}},
  howpublished = {\url{https://github.com/pyth0n14n/FIVBinBench}},
  year = {2025}
}

@inproceedings{nashimoto2025improved,
  author = {Nashimoto, Shoei},
  title = {{Improving Fault Vulnerability Detection via Rehosting and Comparative Analysis of Open-Source Tools}},
  booktitle={2025 Workshop on Fault Detection and Tolerance in Cryptography (FDTC)},
  pages={TBD},
  year = {2025},
  organization={IEEE}
}
```