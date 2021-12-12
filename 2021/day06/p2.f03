! fortran is very lol
program p1
    implicit none

    ! open (unit=10, file="simple")
    integer(kind=8), dimension(9) :: fish
    integer, dimension(:), allocatable :: initial
    integer :: j
    integer(kind=8) :: save
    integer :: generations = 256

    initial = [1,1,1,2,1,1,2,1,1,1,5,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,4,1, &
    1,1,1,3,1,1,3,1,1,1,4,1,5,1,3,1,1,1,1,1,5,1,1,1,1,1,5,5,2,5,1,1,2,1,1, &
    1,1,3,4,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,5,4,1,1,1,1,1,5,1,2,4,1,1,1,1, &
    1,3,3,2,1,1,4,1,1,5,5,1,1,1,1,1,2,5,1,4,1,1,1,1,1,1,2,1,1,5,2,1,1,1,1,1, &
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,3,1,1,3,1,3,1,4,1,5,4,1,1, &
    2,1,1,5,1,1,1,1,1,5,1,1,1,1,1,1,1,1,1,4,1,1,4,1,1,1,1,1,1,1,5,4,1,2,1,1, &
    1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,4,1,1,1,2,1,4,1,1,1,1,1,1,1,1,1, &
    4,2,1,2,1,1,4,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,3,2,1,4,1,5,1,1,1,4,5,1,1,1,1,1,1,5,1,1,5,1,2,1,1,2,4,1,1,2,1,5,5,3]

    fish = [0,0,0,0,0,0,0,0,0]
    do j=1,size(initial)
        if(initial(j) .eq. 0) then
            fish(9) = fish(9) + 1
        else
            fish(initial(j)) = fish(initial(j)) + 1
        end if
    end do

    ! fish = [1,1,2,1,0,0,0,0,0] ! 9 is zero because of 1 indexing


    print *, fish
    do j=1,generations
        save = fish(9)
        fish(9) = fish(1) ! 1 day goes to 0
        fish(1) = fish(2) ! 2 goes to 1
        fish(2) = fish(3) ! 3 goes to 2
        fish(3) = fish(4)
        fish(4) = fish(5)
        fish(5) = fish(6)
        fish(6) = fish(7)
        fish(7) = fish(8)
        ! 9 is really zero, and it actually goes to six
        fish(6) = fish(6) + save
        ! we also add fish at 8 equal to the fish at zero
        fish(8) = save
    end do

    ! wow this is way better than whatever i tried in p1

    print *, sum(fish)
end
