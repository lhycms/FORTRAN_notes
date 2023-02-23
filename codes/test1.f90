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