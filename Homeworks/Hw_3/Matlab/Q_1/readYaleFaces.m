%%
%Load the data for the problem eigen faces into the memory.

extensions = {'centerlight', 'glasses', 'happy', 'leftlight', 'noglasses', 'normal', 'rightlight', 'sad', 'sleepy', 'surprised', 'wink' };

num_extensions = length(extensions);    % total 11 extensions
num_subjects = 15;                      %the number of distinct people
[m, n]  = deal(243, 320);                % image dimemsion [height, width]
X_train = []; % zeros(m*n, num_subjects*10); 
X_test  = []; % zeros(m*n, 20); 

for i = 1:num_subjects
    basename = 'yalefaces/subject';
    if( i < 10 )
        basename = [basename, '0', num2str(i)];
    else
        basename = [basename, num2str(i)];
    end
    
    for j = 1:num_extensions
        fullname = [basename, '.', extensions{j}];
        try
            temp = double(imread(fullname));
            a=1;
        catch
            %disp( 'does not exist')
            a = 0;
        end
        if(a)
            X_train = [X_train reshape(temp, [], 1)];
        end
    end
end
disp('The matrix A is loaded in memory. Its size is:')
disp(size(X_train));

train_face_id = reshape(repmat([1:15]',1,10)',1,150);

% load test images
Path = [pwd '/imgs/'];
for i = 1 : 20
    str_i = ['image' num2str(i) '.mat'];
    path = strcat(Path, str_i)';
    img = double( struct2array( load(path) ) );
    X_test = [X_test reshape(img, [], 1)];      % vectorize matrices
end


% ground-truth
num_gnd_truth = 20;
is_face = ones(num_gnd_truth,1);
is_face(1) = 0;
is_face(3) = 0;
is_face(6) = 0;
is_face(12) = 0;
is_face(14) = 0;


face_id = [0,1,0,2,-1,0,4,-1,6,7,8,0,9,0,10,-1,12,13,-1,15];
