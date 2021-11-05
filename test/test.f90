program test
use str2real_m, only: str2real
implicit none

integer, parameter :: wp = kind(1.0d0)

call check("1.234")
call check("1.E1")
call check("1e0")
call check("0.1234E0")
call check("12.34E0")
call check("0.34E2")
call check(".34e0")
call check("34.E1")
call check("-34.5E1")
call check("0.0021E10")
call check("12.21e-1")


contains



subroutine check(s)
character(*), intent(in) :: s

integer  :: total_tests  = 0
integer  :: failed_tests = 0
real(wp) :: formatted_read_out
real(wp) :: str2real_out
real(wp) :: abs_err
real(wp) :: rel_err

total_tests = total_tests + 1
read(s,*) formatted_read_out
str2real_out = str2real(s)
abs_err = str2real_out - formatted_read_out
rel_err = abs_err / formatted_read_out

write(*,"('input          : ""' g0 '""')") s
if(abs(rel_err) > 0) then
    write(*,"('formatted read : ' g0)") formatted_read_out
    write(*,"('str2real       : ' g0)") str2real_out
end if
if(abs(rel_err) > 1d-15) then
    failed_tests = failed_tests + 1
    write(*,"('str2real       : ' g0)") str2real_out
    write(*,"('difference abs : ' g0)") abs_err
    write(*,"('difference rel : ' g0 '%')") rel_err * 100
end if
write(*,*)

end subroutine check



end program test
