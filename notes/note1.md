# 1. `PROGRAM <name>` && `end PROGRAM <name>`
```fortran
PROGRAM convert_wg2rho

...

END PROGRAM convert_wg2rho
```

# 2. `implicit` (隐式语句)
1. In Fortran, the `implicit` statement can be used to declare the implicit `typing of variables`. 
    - <font color="red">By default, all variables in Fortran are of type `real`.</font>
    - The `implicit` statement can be used to specify the default type for variables that start with certain letters. For example:
```fortran
! 1. Declares that all variables must be explicitly with a type declaration
implicit none

! 2. declares that all variables starting with letters `a` to `z` are of type `integer` by default
implicit integer (a-z)
```
2. It's important to note that the use of the `implicit` statement (隐式语句) is discouraged in modern Fortran, as explicit type declarations make code more readable and maintainable.
    - 现代 Fortran 不鼓励`隐式语句`，因为`显示语句`写出的代码更加可读、可维护。


# 3. `double precision` && `real*8` (`real(kind=8)`)
1. The `double precision` statement:
    - specifies the type to be `double precision`
    - optionally specifies `array dimensions` and `initializes with values`.
2. Description: The declaration can be: `double precision` or `real*8`
    1. `double precision`: For a declaration such as `double precision x`, the variable `x` is a `real*8` element in memory, interpreted as <font color="red">one double-width real number</font>.
    2. If you do not specify the size, a default size is used. The default size, for a declaration such as` DOUBLE PRECISION X`, can be altered by compiling with any of the options `-dbl, -r8, or -xtypemap`. See the discussion in Chapter 2 for details.
    3. `real*8`: For a declaration, such as `real*8` the variable `x` is always an element of type `real*8` in memory, interpreted as <font color="red">a double-width real number</font>.
```fortran
double precision R, S(3, 6)
```

## 3.1. Demo
```fortran
program demo

real*8 :: x, y, result
x = 123456.789
y = 987654.321
result = x + y
print *, "The sum of x and y is: ", result

end program demo
```
Output:
```shell
$ ifort test1.f90 -o test
$ ./test
 The sum of x and y is :    1111111.10156250
```



# 4. `SUBROUTINE <function_name(argument_1, argument_2, ...)> ... END SUBROUTINE <function_name>` : 其实就是函数
1. In Fortran, a `subroutine` is a block of code that can be called multiple times from different places in the program. 
    - `SUBROUTINE` allows you to reuse code and keep your main program organized and easier to read.

## 4.1. Demo 
1. In this demo, `example_subroutine` takes in two integer inputs `x` and `y`, returns through the argument `result`.
2. When the `subroutine` is called from the `main` program:
   1. The values of `x` and `y` are passed to the `subroutine`
   2. The result are stored in `result` varibale.
3. `IMPLICIT NONE` statement is used to make sure that all varibales explicitly declared and prevent any unexpected type conversions.

```fortran
! Part I. subroutine (Act as function in C++)
SUBROUTINE example_subroutine(x, y, result)
    IMPLICIT NONE
    INTEGER :: x, y, result
    result = x + y
END SUBROUTINE example_subroutine


! Part II. Driver code
PROGRAM main
    IMPLICIT NONE
    INTEGER :: x, y, result
    x = 5
    y = 10
    CALL example_subroutine(x, y, result)
    PRINT *, "The sum of x and y is : ", result
END PROGRAM main
```
Output:
```shell
$ ifort test1.f90 -o test
$ ./test
 The sum of x and y is :           15
```


# 5. `INTENT`
1. In Fortran, the `INTENT` attribute is used to <font color="#73db90">specify the intended use of a dummy argument in a subroutine or function.</font> 
    - A `dummy argument` is a placeholder for an actual argument that is passed to the subroutine or function when it is called.
2. Usage:
    - `INTENT(IN)` specifies that a dummy argument is an `input argument`.
    - `INTENT(OUT)` specifies that a dummy argument is an `output argument`.
    - `INTENT(INOUT)` specifies that 
3. In general, using `INTENT` helps:
    - Make code more readable and self-documenting
    - Provide some performance benefits in some cases, since the compiler can better optimize the code if it knows the intended use of a dummy argument.

## 5.1. `INTENT(IN)`
1. `INTENT(IN)`: Specifying that a dummy argument is an input argument, meaning that:
    - It is <font color="red">only used for reading</font> the value passed from the caller. <font color="red">Any changes made to it within the subroutine or function will not be reflected in the caller.</font>
2. This is the most common use of dummy arguments.

### 5.1.1. Demo 
<font color="red" size="4">

Note
----
1. Any changes made to `x` and `y` within the subroutine will not affect the values in the caller.

</font>

```fortran
! Part I. subroutine
SUBROUTINE add(x, y, result)
    IMPLICIT NONE
    INTEGER, INTENT(IN) :: x, y;    ! The usage of `INTENT(IN)`
    INTEGER :: result

    result = x + y
END SUBROUTINE add

! Part II. driver code
PROGRAM main
    IMPLICIT NONE
    INTEGER :: x, y, result
    x = 5
    y = 10
    CALL add(x, y, result)
    print *, "The sum of x and y is : ", result
END PROGRAM main
```
Output:
```shell
$ ifort test.f90 -o test
$ ./test
 The sum of x and y is :           15
```

## 5.2. `INTENT(OUT)`
1. `INTENT(OUT)`: Specifies that a dummy argument is an `output argument`, meaning that its value will be set within the subroutine and return to the caller.

### 5.2.1. Demo
```fortran
! Part I. Subroutine
SUBROUTINE add(x, y, result)
    IMPLICIT NONE
    INTEGER, INTENT(IN) :: x, y
    INTEGER, INTENT(OUT) :: result
    result = x + y
END SUBROUTINE add


! Part II. Driver code
PROGRAM main
    IMPLICIT NONE
    INTEGER :: x, y, result
    x = 5
    y = 10
    CALL add(x, y, result)
    print *, "The sum of x and y is : ", result
END PROGRAM main
```
Output:
```shell
$ ifort test1.f90 -o test
$ ./test
 The sum of x and y is :           15
```


## 5.3. `INTENT(INOUT)`
1. `INTENT(INOUT)`: Specifies that a dummy argument is `both an input and output argument`, meaning that its value will be used and then changed within the subroutine, and the changed value will retrurned to the caller.


## 5.4. Difference between `INTENT(OUT)` and `INTENT(INOUT)`
1. `INTENT(OUT)`: When the subroutine or function is called
    - <font color="#73db90">the dummy argument is not initialized and has an undefined value</font>
    - But after the subroutine or function is executed, the dummy argument will be set and return to the caller.
2. `INTENT(INOUT)`: When the subroutines or function is called
    - <font color="#73db90">The dummy argument is initialized with value passed from the caller, </font>
    - After the subroutine or function is executed, its value may changed and will be returned to caller.


# 6. `Data types` in Fortran
1. `INETGER`:
    - `INTEGER*2`
    - `INTERGE*4`
    - `INETGER*8`
    - depending on the size of the integer
2. `REAL`: 
    - `REAL*4`
    - `REAL*8`
    - depending on the size of the real number
3. `DOUBLE PRECISION`
4. `COMPLEX`:
    - `COMPLEX*8`
    - `COMPLEX*16`
    - depending on the size of the complex number
5. `LOGICAL`:
    - `.TRUE.`
    - `.FALSE.`
6. `CHARACTER`:
    - A character value is a string of one or more characters.

## 6.1. Demo 1: Difference between `REAL` and `REAL*8`
<font color="steelblue" size="4">

1. `REAL` and `REAL*8` are both data type used to represent `real numbers`, but there is difference in `precision`.
    1. `REAL` typically corresponds to `single-precision real numbr`, which has a precision of about `7 decimal digits`.
        - The actual size of REAL may vary depending on the compiler and the target architecture, but it is typically `4 bytes` in size.
    2. `REAL*8` typically corresponds to a `double-precision real number`, which has a precision of about 15 decimal digits.
        - `REAL*8` is typically `8 bytes` in size。
2. In this example, x is declared as `REAL`, and y is declared as `REAL*8`. Both are initialized with the value `0.1`. When the program is run, you will see that x has a slightly different value than y due to the difference in precision:

</font>

```fortran
PROGRAM example
  IMPLICIT NONE
  REAL :: x
  REAL*8 :: y

  x = 0.1
  y = 0.1

  PRINT *, 'x =', x
  PRINT *, 'y =', y
END PROGRAM example
```
Output:
```shell
$ ifort test1.f90 -o test
$ ./test
 x =  0.1000000    
 y =  0.100000001490116
```


# 7. `PRINT *, varibale1, variable2, ...`
<font color="steelblue" size="4">

1. In Fortran, you can use `print` statement to outpuyt text to the `console` or `file`. The basic syntax of the `PRINT` is as follows:
    - `format` is format specification that controls the appearance of the output.
    - `variable1`, `varibable2` are variables to be printed.
```fortran
PRINT format, varibable1, varibale2
``` 

</font>

## 7.1. Demo 1: print a string to console -- format specifier (`(A)`)
```fortran
PROGRAM hello 

IMPLICIT NONE
PRINT '(A)', "Hello, world!"

END PROGRAM hello
```


## 7.2. Demo 2: print a `integer with field width of 10 characters` -- format specifier (`(I10)`)
```fortran
PROGRAM print_int

IMPLICIT NONE
INTEGER :: I = 42
PRINT '(I10)', i

END PROGRAM print_int
```

## 7.3. Demo 3: print a `real variable with 6 decimal place` -- format specifier (`(F0.6)`)
```fortran
PROGRAM print_real

IMPLICIT NONE
REAL :: x = 3.1415926
PRINT '(F0.6)', x

END PROGRAM print_real
```

## 7.4. Format specifier -- (`*`)
<font color="steelblue" size="4">

1. `PRINT *` statement is a shorthand for printing output to the console `without` using a format specifier.
2. For example, to print `a string and an integer` variable to the console using `PRINT *`, you can write:

</font>

```fortran
PROGRAM print_variables

IMPLICIT NONE
INTEGER :: i = 42
PRINT *, "The value is ", i

END PROGRAM print_variables
```


# 8. `WRITE(file_unit, format, IOSTAT)`
<font color="red" size="5">

`IOSTAT`
--------
1. `IOSTAT` is an optional argument that can be used with Fortran `input/output statement` such as:
    - `read(file_unit, format, IOSTAT)`
    - `write(file_unit, format, IOSTAT)`
    - It is `intent(out)`. It is used to indicate the status of the `input/output` operation, i.e. whether the operation was successful or not.
2. The `IOSTAT` argument is an integer variable that is assigned a value by `input/output` statement:
    1. `IOSTAT=0`: The operation was `successful`
    2. `IOSTAT>0`: An error occured during the operation. The value of `IOSTAT` indicates the number of the first record that could not be processed.
    3. `IOSTAT<0`: End-of-file was encountered before any data could be processed.

</font>

<font color="steelblue" size="4">

1. The `write()` statement in Fortran is used to output data to a file or to the console. The basic syntax of the `write()` statement is as follows:
```fortran
! 1. `format`: is a character string that specifies the format of the output.
!   - first is `*`: output to console
! 2. `output_list`: a list of varibales to output
write(format, output_list)
``` 

</font>

## 8.1. Demo 1: Output to `console`
```fortran
program main
  implicit none
  integer :: x = 10, y = 20
  real :: z = 3.14
  character(len=20) :: name = "John Smith"

  ! 1. Output integer to console
  write(*, *) "x = ", x
  write(*, *) "y = ", y
  ! 2. Write real variable to console
  write(*, *) "z = ", z
  ! 3. write charactr variable to console
  write(*, *) "name = ", name
end program main
```
Ouput:
```fortran
$ gfortran test1.f90 -o test
$ ./test
 x =           10
 y =           20
 z =    3.14000010    
 name = John Smith 
```


## 8.2. Demo 2: Output to `file` -- `open(unit, file, status)` && `close(unit)`
```fortran
program main
  implicit none
  integer :: x = 10, y = 20, iounit
  real :: z = 3.14
  character(len=20) :: name = "Jon Smith"

  iounit = 10   ! assign file unit number

  ! open output file
  open(unit=iounit, file="output.txt", status="replace")
    ! write a integer to the file
    write(iounit, *) "x = ", x
    write(iounit, *) "y = ", y
    ! write a real to the file
    write(iounit, *) "z = ", z
    ! write character to the file
    write(iounit, *) "name = ", name
  close(iounit)
end program main
```
Output:
```shell
$ gfortran test1.f90 -o test
$ ./test    # output to `output.txt`
```


# 9. `READ(file_unit, format, IOSTAT)`
<font color="steelblue" size="4">



</font>

## 9.1. Demo 1: How to use `READ(file_unit, format, iostat)`
```fortran
!!! Part I. Module -- array_utils
module array_utils
  implicit none
  contains
    !!! Subroutine 1. set_array_value
    subroutine set_array_value(array_real, file_unit)
      real*8, dimension(:) :: array_real
      integer :: file_unit, idx, ierr
      do idx = 1, size(array_real)
        read(file_unit, *, IOSTAT=ierr) array_real(idx)
      end do
    end subroutine set_array_value

    !!! Subroutine 2. print_array()
    subroutine print_array(array_real)
    real*8, dimension(:) :: array_real
      write(*, *) array_real
    end subroutine print_array

end module array_utils


!!! Part II. Driver code
program main
  use array_utils
  implicit none
  real*8, dimension(10) :: array_real;
  integer file_unit;

  ! Open the `output.txt` file
  open(unit=file_unit, file="./output.txt", status="old")
  call set_array_value(array_real, file_unit)
  call print_array(array_real)
  ! Close the `output.txt` file
  close(file_unit)
end program main
```
Output:
```shell
$ gfortran test1.f90 -o test
$ ./test
   1.0000000000000000        2.0000000000000000        3.0000000000000000        4.0000000000000000        5.0000000000000000        6.0000000000000000        7.0000000000000000        8.0000000000000000        9.0000000000000000        10.000000000000000   
```


# 10. `REWIND`
<font color="steelblue" size="4">

1. The `rewind(file_unit)` statement is used to `reset the file position` to the beginning of a file.
```fortran
rewind(file_unit)
```

</font>

## 10.1. Demo 1:
```txt
1
2
3
4
5
6
7
8
9
10
```

```fortran
!!! Part I. Module 
module array_utils
  implicit none
  contains
    ! subroutine 1. set_array_value from file
    subroutine set_array_value(array_real, file_unit)
      real*8, dimension(:) :: array_real
      integer :: file_unit
      integer :: idx
      do idx = 1, size(array_real)
        read(file_unit, *) array_real(idx)
      end do
    end subroutine set_array_value

    ! subroutine 2. print_array
    subroutine print_array(array_real)
      real*8, dimension(:) :: array_real
      write(*, *) array_real
    end subroutine print_array
end module array_utils


!!! Part II. Driver code
program main
  use array_utils
  implicit none
  integer :: file_unit=10, idx
  real*8, dimension(10) :: array_real

  open(unit=file_unit, file="output.txt", status="old")
    call set_array_value(array_real, file_unit)
    call print_array(array_real)

    rewind(file_unit)

    call set_array_value(array_real, file_unit)
    call print_array(array_real)

  close(file_unit)
end program main
```
Output:
```shell
$ gfortran test1.f90 -o test
$ ./test
   1.0000000000000000        2.0000000000000000        3.0000000000000000        4.0000000000000000        5.0000000000000000        6.0000000000000000        7.0000000000000000        8.0000000000000000        9.0000000000000000        10.000000000000000     
   1.0000000000000000        2.0000000000000000        3.0000000000000000        4.0000000000000000        5.0000000000000000        6.0000000000000000        7.0000000000000000        8.0000000000000000        9.0000000000000000        10.000000000000000 
```