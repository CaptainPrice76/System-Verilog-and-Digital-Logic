int f, g, y; // global variables
int sum(int a, int b) {
return (a + b);
}
int main(void)
{
f = 2;
g = 3;
y = sum(f, g);
return y;
}

/*To compile, assemble, and link a C program named prog.c with
GCC, use the command:
gcc –O1 –g prog.c –o prog
This command produces an executable output file called prog. The –O1
flag asks the compiler to perform basic optimizations rather than produ-
cing grossly inefficient code. The –g flag tells the compiler to include
debugging information in the file.
*/