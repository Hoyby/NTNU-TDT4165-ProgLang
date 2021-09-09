local X Y in
X = "This is a string"
thread {Show Y} end
Y = X
end


% The reason Y can run "before" its assignment is because
% the showInfo runs in a different, concurrent thread.
% The thread containing showInfo will be suspended at first
% and then resumed once Y is decleared.