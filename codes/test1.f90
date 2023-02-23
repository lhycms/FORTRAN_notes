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

  open(unit=file_unit, file="./output.txt", status="old")
  call set_array_value(array_real, file_unit)
  call print_array(array_real)
  close(file_unit)
end program main