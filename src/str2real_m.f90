module str2real_m
implicit none
private
public :: str2real

integer, parameter :: wp    = kind(1.0d0)
integer, parameter :: ikind = selected_int_kind(2)
integer(kind=ikind), parameter :: period     = -2
integer(kind=ikind), parameter :: char_e_cap = 21
integer(kind=ikind), parameter :: char_e     = char_e_cap + 32
integer(kind=ikind), parameter :: minus_sign = -3
real(wp),  parameter :: expo(*) = &
        [1d15,  1d14,  1d13,  1d12,  1d11,  1d10,  1d9,   1d8,   &
         1d7,   1d6,   1d5,   1d4,   1d3,   1d2,   1d1,   1d0,   &
         0d0,                                                    &
         1d-1,  1d-2,  1d-3,  1d-4,  1d-5,  1d-6,  1d-7,  1d-8,  &
         1d-9,  1d-10, 1d-11, 1d-12, 1d-13, 1d-14, 1d-15, 1d-16, &
         1d-17, 1d-18, 1d-19, 1d-20, 1d-21, 1d-22, 1d-23, 1d-24]

contains



function str2real(s) result(r)
character(*), target, intent(in) :: s
real(wp) :: r
integer,   parameter :: N = 32
character(N) :: equ_s
integer(kind=ikind)    :: equ_i(N)
integer(kind=ikind)    :: mask(N)
integer      :: period_loc
integer      :: exponent_loc
integer      :: mask_from
integer      :: mask_till
real(wp)     :: r_base
real(wp)     :: r_expo


equivalence(equ_i, equ_s)

equ_s = s
equ_i = equ_i - 48

period_loc   = findloc(equ_i, period, 1)
!exponent_loc = max( &
!        findloc(equ_i, char_e,     1, back=.true.), &
!        findloc(equ_i, char_e_cap, 1, back=.true.))
exponent_loc = findloc(equ_i, char_e_cap, 1, back=.true.)
if(exponent_loc == 0) exponent_loc = len(s) + 1
if(period_loc   == 0) period_loc   = exponent_loc

where (0 <= equ_i .and. equ_i <= 9)
    mask = 1
elsewhere
    mask = 0
end where

mask_from = 18 - period_loc
mask_till = mask_from + exponent_loc - 2

r_base = sum( &
        equ_i(:exponent_loc - 1)  * &
        expo(mask_from:mask_till) * &
        mask(:exponent_loc - 1))
r_expo = sum( &
        equ_i(exponent_loc+1:len(s)) * &
        mask(exponent_loc+1:len(s))  * &
        expo(17-(len(s)-exponent_loc):16))
if(equ_i(exponent_loc+1) == minus_sign) r_expo = -r_expo
if(equ_i(1)              == minus_sign) r_base = -r_base
r = r_base * 10 ** r_expo
end function str2real



end module str2real_m
