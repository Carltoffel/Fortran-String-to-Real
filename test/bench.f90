program bench

use iso_fortran_env, only: wp => real64, ip => int64
use str2real_m, only: str2real

implicit none

integer,parameter :: n = 1e6 !! number of values

integer :: i
character(len=30),dimension(:),allocatable :: strings
real(wp) :: rval
integer :: ierr
integer(ip) :: start, finish, count_rate
real :: formatted_read_time
real :: str2real_time

! create a list of values to parse
call system_clock(start, count_rate)
allocate(strings(n))
do i = 1, n
    call RANDOM_NUMBER(rval)
    write(strings(i), '(E30.16)') rval
end do
call system_clock(finish)
write(*,'("write          : "f7.4" s")') (finish-start)/real(count_rate,wp)

call system_clock(start)
do i = 1, n
    read(strings(i),fmt=*,iostat=ierr) rval
end do
call system_clock(finish)

formatted_read_time = (finish-start)/real(count_rate, wp)
write(*,'("formatted read : "f7.4" s")') formatted_read_time

call system_clock(start)
do i = 1, n
    rval = str2real(strings(i))
end do
call system_clock(finish)

str2real_time = (finish-start)/real(count_rate, wp)
write(*,'("str2real       : "f7.4" s")') str2real_time

write(*,'("Speedup        : "f7.4)') formatted_read_time / str2real_time
end program bench
