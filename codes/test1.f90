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