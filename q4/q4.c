#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h> 

typedef int (*fptr)(int,int);

int main(){
    char op[10];
    int num1, num2;

    while(scanf("%s %d %d", op, &num1, &num2)==3){
        char lib_name[32];
        snprintf(lib_name,sizeof(lib_name),"./lib%s.so",op);

        void* handle=dlopen(lib_name,RTLD_LAZY);
        if(!handle) continue;

        fptr operation=(fptr)dlsym(handle,op);
        if(!operation){
            dlclose(handle);
            continue;
        }

        int result=operation(num1,num2);
        printf("%d\n",result);
        dlclose(handle);
    }

    return 0;
}
