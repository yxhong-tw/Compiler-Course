/* 
    DOM Judge 注意事項
    - C++ Libary：
        - C++ 版本使用 C++11
        - 請以 cin 與 cout 作為主要的 I/O (e.g. cin.getline(), cin.get(), cin.peek(), cin.eof() )
        - class 、 struct  與 enum 均可使用
        - <regex> 函式庫也可以使用 ( 只要不出錯 )
        - <vector> 也可以使用
        - C 的標頭檔(.h) 能不使用就盡量別用
    - Run Error 可能的情況：
        - 程式的 main() 缺少了 return 0
        - 存取非法記憶體區塊
        - 陣列越界
        - 除以零
        - Stack Overflow
    - Compiler Error 可能的情況：
        - 使用到非 C++11 的版本的 function或 libary
        - 變數或函式與 Libary 的衝突
    - Lex 遇到 TIMELIMIT 的情況
        - 多新增一個規則 eol   [\n]
        - 不要用 int yywrap()
 */

#include <iostream>

using namespace std;

int main() {
    cout << "Hello World" << endl;
    return 0;
}