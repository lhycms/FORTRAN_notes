# 1. `getarg()` function
<font color="steelblue" size="4">

1. The `getarg()` function is used to retrieve command-line arguments passed to the program.
2. The function takes two arguments:
    - `i`: is the `index of argument` to retrieve
    - `arg`: is a `character string variable` that will receive the `value of the argument`.

</font>

## 1.1. Demo 1:
<font color="red" size="4">

Note
----
1. Note that the `getarg()` function returns a string that is padded with spaces to the length of the character variable passed as the second argument. Therefore, it's important to use the `trim() function` to `remove any trailing spaces` from the argument string before using it.

</font>

```fortran
program main
  implicit none
  integer :: i, argc
  character*40 :: arg
  ! get number of command-line arguments
  argc = command_argument_count()
  
  do i = 1, argc
    ! get command-line argument at index `i`
    call getarg(i, arg)
    ! print argument to console
    write(*, *) "Index ", i, " = ", arg
  end do
end program main
```