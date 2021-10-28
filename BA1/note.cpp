#include <iostream>
#include <iomanip>
#include <vector>
#include <string>

using namespace std;

int main() {
    // setprecision
    string a = "1.23456789";
    double a_double = stod(a);
    cout << setprecision(a.length()) << a_double << endl;

    // easy regex without ascii code
    char b = 'a';
    if((b >= 'a' && b <= 'z') || (b >= 'A' && b <= 'Z')) {
        cout << "HELOO" << endl;
    }

    // getline
    string c = "";
    getline(cin, c);
    cout << c << endl;

    // getline until EOF
    string d = "";
    while(getline(cin, d)) {
        cout << d << endl;
    }

    // get all lines without getline
    char e;
    string f = "";
    while(!cin.get(e).eof()) {
        if(e == '\n') {
            cout << f << endl;
            f = "";
        }
        else {
            f += e;
        }
    }

    // stoi, stod
    // stof 會有殘值
    string g = "123", h = "1.2345";
    int i = stoi(g);
    double j = stod(h);
    cout << i << " " << j << endl;

    // to_string ( but may have some wrong )
    double k = 1.23456789;
    cout << to_string(k) << endl;
    return 0;
}