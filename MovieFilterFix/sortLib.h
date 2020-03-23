//
//  sortLib.h
//  MovieFilterFix
//
//  Created by JoannaWQ on 23/3/20.
//  Copyright © 2020 Wu Jian. All rights reserved.
//

#ifndef sortLib_h
#define sortLib_h

#include <stdio.h>
#include <stdlib.h>
//To sort the disorder data
void quickSort(int* arr, int low, int high);
//To merge 2 ordered array, test okay in c, but alwasy crash in xos, give up
void Merge(int* array1, int size1, int* array2,int size2,int* array);

int test(int n);
#endif /* sortLib_h */
