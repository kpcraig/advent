! fortran is very lol
subroutine append_fish(a, v)
    integer, dimension(:),allocatable,intent(inout)::a
    integer, intent(in)::v

    a = [a,v]
end subroutine

program p1
    implicit none
    interface 
        subroutine append_fish(a, v)
            integer, dimension(:),allocatable,intent(inout)::a
            integer, intent(in)::v
        end subroutine
    end interface
    ! open (unit=10, file="simple")
    integer, dimension(:),allocatable :: fish
    integer :: i
    integer :: j
    integer :: births
    integer :: generations = 80
    fish = [1,1,1,2,1,1,2,1,1,1,5,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,4,1, &
    1,1,1,3,1,1,3,1,1,1,4,1,5,1,3,1,1,1,1,1,5,1,1,1,1,1,5,5,2,5,1,1,2,1,1, &
    1,1,3,4,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,5,4,1,1,1,1,1,5,1,2,4,1,1,1,1, &
    1,3,3,2,1,1,4,1,1,5,5,1,1,1,1,1,2,5,1,4,1,1,1,1,1,1,2,1,1,5,2,1,1,1,1,1, &
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,3,1,1,3,1,3,1,4,1,5,4,1,1, &
    2,1,1,5,1,1,1,1,1,5,1,1,1,1,1,1,1,1,1,4,1,1,4,1,1,1,1,1,1,1,5,4,1,2,1,1, &
    1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,4,1,1,1,2,1,4,1,1,1,1,1,1,1,1,1, &
    4,2,1,2,1,1,4,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,3,2,1,4,1,5,1,1,1,4,5,1,1,1,1,1,1,5,1,1,5,1,2,1,1,2,4,1,1,2,1,5,5,3]



    ! print *, fish
    do j=1,generations
        births = 0
        do i=1,size(fish)
            if (fish(i) .eq. 0) then
                births = births + 1
                fish(i) = 6
            else
                fish(i) = fish(i) - 1
            end if
        end do
        do i=1,births
            call append_fish(fish, 8)
        end do
        print *, j
    end do

    ! call append_fish(fish, 99)

    print *, size(fish)
end
