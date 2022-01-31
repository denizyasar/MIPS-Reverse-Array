#include<stdio.h>
#include<stdlib.h>
void f_iter(int *a, int s, int f)
{
    int t;
    while(s < f)
    {
        t = a[s];
        a[s] = a[f];
        a[f] = t;
        s++;
        f--;
    }
}
void f_rec(int *a, int s, int f)
{
    int t;
    if(s < f)
    {
        t = a[s];
        a[s] = a[f];
        a[f] = t;
        f_rec(a, s+1, f-1);
    }
}
#define N 10
int main()
{
    int arr[N] = {95, 86, 79, 63, 52, 41, 34, 28, 17, 6};
    int s, f, i;
    s = 0;
    f = N-1;
    f_iter(arr, s, f);
    printf("f_iter : ");
    i = 0;
    while(i < N)
    {
        printf("%d ", arr[i]);
        i++;
    }
    printf("\n");
    s = 0;
    f = N-1;
    f_rec(arr, s, f);
    printf("f_rec : ");
    i = 0;
    while(i < N)
    {
        printf("%d ", arr[i]);
        i++;
    }
    printf("\n");
    return 0;
}
