s=surf(peaks(20));
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');

direction = [1 0 0];
rotate(s,direction,25)
