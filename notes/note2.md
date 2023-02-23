# Array in Fortran 

# 1. Basic
<font color="steelblue" size="4">

1. In Fortran, you can declare and use arrays to store and manipulate multiple values of the same data type.
    - The basic syntax for declaring an array is:
```fortran
! 1. Basic syntax
type, dimension(dim1, dim2, ...) :: array_name

! 2. Declare one-dimensional integer array named `a` with 10 elements
integer, dimension(10) :: a

! 3. Declare two-dimensional real array named `b` with dimension 3 by 4.
real*8, dimension(3, 4) :: b
```
2. You can access individual elements of an array using an index (or multiple indices for multi-dimensional arrays), as follows:
```fortran
! 1. Basic syntax for index
array_name(index1, index2, ...)

! 2. Syntax for assignment
a(3) = 42
b(2, 3) = 3.14

! 3. Demo for assignment
do i = 1, 10
    a(i) = i
end do

! 4. Demo for assignment
do i = 1, 3
    do j=1, 4
        b(i, j) = i*j
    end do
end do
```

</font>


<font color="red" size="4">

Note
----
1. Fortran use `column-major` ordering for multi-dimensional arrays, which means `the rightmost index varies fastest in memory.`

</font>

## 1.1. Demo
```fortran
program main

implicit none
integer :: idx
integer, dimension(10) :: array_int

!!! Assignment
!!!     Note: 
!!!         1. Fortran 的数组索引从 1 开始
!!!         2. do idx=start, final;...;end do -- 循环包前也包后
do idx = 1, 10
    array_int(idx) = idx * 2
end do

!!! Output to console
do idx = 1, size(array_int)
    print '(I5)', array_int(idx)
end do

end program main
```
Output:
```shell
$ ifort test1.f90 -o test
$ ./test
    2
    4
    6
    8
   10
   12
   14
   16
   18
   20
```


# 2. When dummy argument is `array`
<font color="steelblue" size="4">

1. You can pass an array as argument to the subroutine or function.
```fortran
! Basic syntax
call subroutinue(array_name)
```


</font>