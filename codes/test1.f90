!!! PartI. Module -- array_utils
module array_utils
  implicit none
  contains
    !!! subroutine 1.
    subroutine set_array_value(array_int, value)
      integer, dimension(:) :: array_int
      integer :: idx, value
      do idx = 1, size(array_int)
        array_int(idx) = value
      end do
    end subroutine

    !!! subroutine 2.
    subroutine print_array(array_int)
      integer, dimension(:) :: array_int
      integer :: idx
      do idx = 1, size(array_int)
        print '(I5)', array_int(idx)
      end do
    end subroutine

end module array_utils


!!! Part II. Driver code
program main
  use array_utils
  implicit none

  integer, dimension(10) :: array_int
  integer :: value = 5
  ! 1. call `set_array_value`
  call set_array_value(array_int, value)
  ! 2. call `print_array`
  call print_array(array_int)
end program main