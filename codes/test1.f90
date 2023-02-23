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