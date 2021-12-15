
fd = fopen('input-data', 'r');
A = fscanf(fd, '%d,%d', [2 Inf]);
fclose(fd);

fd = fopen('input-inst', 'r');
B = fscanf(fd, '%*s %*s %[xy]=%d', [2 Inf]);
fclose(fd);

fld = @(v, fold) 2 * fold - v;

for fold = B
    switch(fold(1)) % 120 is x, 121 is y
        case 120
            % for each coord, mutate if past the line
            C = A(1,:) > fold(2);
            A(1, C) = fld(A(1,C), fold(2));
        case 121
            C = A(2,:) > fold(2);
            A(2, C) = fld(A(2,C), fold(2));
    end
    A = unique(A.', 'rows').'; % brilliant
    [h, w] = size(A);
    disp(sprintf("%d is the dot count", w));
end

scatter(A(1,:), A(2,:)); 
axis([0 40 -10 10]);
s = input("hey")