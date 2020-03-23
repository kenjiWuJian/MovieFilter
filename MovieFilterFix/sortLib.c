//
//  libSort.c
//  MovieFilter
//
//  Created by JoannaWQ on 21/3/20.
//  Copyright © 2020 Wu Jian. All rights reserved.
//

#include "sortLib.h"

//int arr[] = {3,5,3,6,7,3,2};
//int arr1[] = {100,100,100,100,80,65,60,47,42,40};
//int arr2[] = {100,100,100,100};
void swap(int* a, int* b)
{
    int temp;
    temp = *a;
    *a = *b;
    *b = temp;
}

int partition(int* arr, int low, int high)
{
    int pivot = arr[high]; //select a pivot
    int i = (low - 1); //initial place
    int j = 0;
    for(j = low; j < high ; j++)
    {
        if(arr[j]>pivot)
        {
            i++;
            swap(&arr[i],&arr[j]);
        }
    }
    swap(&arr[i+1],&arr[high]); //finally exchange pivot to the correct place
    return i+1; //return the posion of pivot
}

void quickSort(int* arr, int low, int high)
{
    int pos = 0;
    if(low<high)
    {
        pos = partition(arr,low,high);
        quickSort(arr,low,pos-1);
        quickSort(arr,pos+1,high);
    }
}

void Merge(int* array1,int size1, int* array2,int size2, int* array)
{
    int index1 = 0;
    int index2 = 0;
    int index = 0;
    //int*pTemp =malloc(sizeof(size1+size2)); //create a new array
    while (index1 < size1 && index2 < size2)//any array reach the end, then finish
    {
        if (array1[index1] > array2[index2])//if member of array1 > array2, put it into new array
            array[index++] = array1[index1++];
        else
            array[index++] = array2[index2++];//else put member of array2 to the new array
    }
    while (array1[index1])//after the loop, if array 1 has member left, then put them directly to new array
    {
        array[index++] = array1[index1++];
    }
    while (array2[index2])//the same for array 2
    {
        array[index++] = array2[index2++];
    }
   // return pTemp;
}
int test(int n)
{
    return n+2;
}

#if 0
int main()
{

   // quickSort(arr,0,6);
   // for(int i = 0; i < 7; i++)
   // {
   //      printf("%d\n",arr[i]);
   // }

    int arr3[14] ;
    Merge(arr1,10,arr2,4,arr3);
    for(int i = 0; i < 14; i++)
    {
        printf("%d\n",arr3[i]);
    }
    return 0;
}
#endif

