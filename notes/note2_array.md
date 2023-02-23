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


# 2. When dummy argument is `array` -- 在 Fortran 中，array 作为dummy argument传递时，传递的是`reference`
<font color="steelblue" size="4">

1. You can pass an array as argument to the subroutine or function.
```fortran
! 1. Basic syntax for dummy arguments
subroutine func(array_name)
...
...
...
end subroutine func

! 2. Basic syntax for `call`
call func(array_name)
```

</font>

## 2.1. Demo 1: Wrong
<font color="red" size="4">

1. 报错信息：`Error: Procedure 'set_array_0' at (1) with assumed-shape dummy argument 'array_int' must have an explicit interface
test1.f90:36.1`
2. The error message you encountered occurs when a Fortran `subroutine or function has an assumed-shape dummy argument` and `is calld from another program unit` without an `explicit interface`. 

</font>

```fortran
!!! Part I.
subroutine set_array_0(array_int)

implicit none
integer, dimension(:) :: array_int
integer :: idx

do idx = 1, 10
  print *, idx
  array_int(idx) = 0
end do

end subroutine set_array_0


!!! Part II.
subroutine print_array(array_int)

implicit none
integer, dimension(:) :: array_int
integer :: idx

do idx = 1, size(array_int)
  print '(I5)', array_int(idx)
end do

end subroutine print_array


!!! Part III.
program main

implicit none
integer, dimension(10) :: array_int
call set_array_0(array_int)
call print_array(array_int)

end program main
```
Output:
```Output
$ gfortran -g test1.f90 -o test
$ ./test
test1.f90:35.16:

call set_array_0(array_int)
                1
Error: Procedure 'set_array_0' at (1) with assumed-shape dummy argument 'array_int' must have an explicit interface
test1.f90:36.16:

call print_array(array_int)
                1
Error: Procedure 'print_array' at (1) with assumed-shape dummy argument 'array_int' must have an explicit interface
```


# 3. `explicit interface` in Fortran
<font color="steelblue" size="4">

1. In Fortran, an `explicit interface` is way to provide the compiler with `information about the types and characteristics of the arguments` of a procedure (subroutine or function) from the calling program unit:
    - Number of argument
    - Data types
    - Intent of argument
    - Any `assumed-shape` or `assumed-size` array argument
2. `Explicit interfaces` can be provided in several ways:
    1. By `putting the procedure (subroutine or function) in a module` and `use` that module in the `calling program unit (程序调用单元)`
    2. By `providing an interface block within the same program unit` that calls the procedure.
    3. By using a `separate interface file` that provides the interface information for the procedure.

</font>

## 3.1. Demo 1: Providing `explicit interface` -- `module block`
<font color="red" size="4">

Note
----
1. Note that `when passing arrays as arguments`, the array elements are `passed by reference rather than by value`.
    - which means that any changes made to the elements of the array in the subroutine or function will also `affect the corresponding elements of the actual array passed as an argument`.

</font>

<font color="steelblue" size="4">

1. In below demo, the subroutine `set_array_0` is defined in a module called `array_utils`.
    - The `array_utils module` contains an `explicit inferface` for the subroutine.
2. The `dimension(:)` specifier indicates that a is an array of unknown size and shape, which means it can be any size or shape array. 
3. The `size(a)` function returns the number of elements in the array

</font>

```fortran
!!! Part 1. array_utils (Module)
module array_utils
  implicit none
  contains  ! module contains: 
    !!! subroutine 1.
    subroutine set_array_0(array_int)
      integer, dimension(:) :: array_int
      integer :: idx

      do idx = 1, size(array_int)
        array_int(idx) = 0
      end do
    end subroutine set_array_0


    !!! subroutine 2.
    subroutine print_array(array_int)
      integer, dimension(:) :: array_int
      integer :: idx

      do idx = 1, size(array_int)
        print '(I5)', array_int(idx)
      end do
    end subroutine print_array

end module array_utils


!!! Part 2. Driver code
program main
  use array_utils ! use module: 
  implicit none
  integer, dimension(10) :: array_int
  ! 1. call the subroutine -- `set_array_0`
  call set_array_0(array_int)
  ! 2. call the subroutine -- `print_array`
  call print_array(array_int)
end program main
```
Output:
```shell
$ gfortran -g test1.f90 -o test
$ ./test
    0
    0
    0
    0
    0
    0
    0
    0
    0
    0
```

## 3.2. Demo 2: Providing `explicit interface` -- `interface block`

## 3.3. Demo 3: Providing `explicit interface` -- ``


# 4. `allocatable` && `allocate` && `deallocate`
<font color="steelblue" size="4">

1. The `allocatable` attribute can be used to declare a variable whose size can be `dynamically allocated at runtime`.
    - This allows the program to `allocate and deallocate memory as needed`, which is useful for handling large arrays or other data structures.
    - Here's an example of how to use `allocatable`

</font>

```fortran
program main
  implicit none
  ! Declare an allocatable integer array
  integer, allocatable, dimension(:) :: myarray
  ! Allocate memory for the array
  allocate(myarray(10))
  ! Initialize the array to zero
  myarray = 0
  ! Modify the first element of array
  myarray(1) = 1
  ! Print the contents of the array
  print *, myarray
  ! Deallocate memory for the memory
  deallocate(myarray)
end program main
```
Output:
```shell
$ gfortran test1.f90 -o test
$ ./test
           1           0           0           0           0           0           0           0           0           0
```