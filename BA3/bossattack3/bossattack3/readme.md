## 檔案說明

1. 公開測資
   1. all_open.txt 列出所有的 open test cases
   2. all_open_ans.txt 列出所有的 open test cases 的正確 output
2. lex 與 yacc 檔案
   1. lex/flex 的檔案為 list.l，定義如何匹配 token 與將值存到 token 中(DIGITS token)
   2. yacc/bison 的檔案為 list.y，定義 list 和 slice 的 struct，並且定義一些操作 list 的函數，以及描述 token 和 NonTerminal 儲存資料的型別，並且完整定義文法，只差 action 部份沒有動作（只有印出訊息，讓人比較好知道 reduce 情況與順序)
3. parser 的 input
   1. list.y 在 main 函數那邊要特別注意，如果想要在自己電腦測試，有提供從檔案讀入 input，預設是讀入 t.txt，如果要上傳到 domJudge 要把那段設定 yacc/bison input 的 code 註解掉
4. list 相關的函數的使用範例有寫在 test.c，如果要用可以自己玩玩看

## compile and run

有提供 Makefile 方便編譯，指令如下
generate parser named a.out

```shell
make all
```

run parser

```shell
./a.out
```
