function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% when operating in convolution mode. See 'help imfilter'. 
% While "correlation" and "convolution" are both called filtering, 
% there is a difference. From 'help filter2':
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should meet the requirements laid out on the project webpage.

% Boundary handling can be tricky as the filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% we look at 'help imfilter', we see that there are several options to deal 
% with boundaries. 
% Please recreate the default behavior of imfilter:
% to pad the input image with zeros, and return a filtered image which matches 
% the input image resolution. 
% A better approach is to mirror or reflect the image content in the padding.

% Uncomment to call imfilter to see the desired behavior.
% output = imfilter(image, filter, 'conv');

%%%%%%%%%%%%%%%%
% Your code here
%     image = im2single(imread('../data/monster.jpg'));
%     figure(1)
%     imshow(image);
%      filter = [ 0 0 0; 0 1 0 ;0 0 0];

    [m1,n1,z] = size(image);  
    [m2,n2] = size(filter); 
    if (mod(m2,2)~=1)&&(mod(n2,2)~=1)
        error('Filter error: even dimensions.')
    end
    padsizem=(m2-1)/2;
    padsizen=(n2-1)/2;
    padimage = padarray(image,[m2,n2],'symmetric','post');%pad with reflection
    padfilter= padarray(filter,[m1,n1],'post');
% brute force method:   
%     rotfilter=rot90(filter,2);
%     newimage=zeros(m1,n1,z);
%     if z==3
%         for i=1:m1
%             for j=1:n1
%                 newvalue1=padimage(i:i+m2-1,j:j+n2-1,1).*rotfilter;
%                 newvalue2=padimage(i:i+m2-1,j:j+n2-1,2).*rotfilter;
%                 newvalue3=padimage(i:i+m2-1,j:j+n2-1,3).*rotfilter;
%                 newimage(i,j,1)=sum(newvalue1(:));
%                 newimage(i,j,2)=sum(newvalue2(:));
%                 newimage(i,j,3)=sum(newvalue3(:));
%             end
%         end
%     else
%         for i=1:m1
%             for j=1:n1
%                 newvalue=padimage(i:i+m2-1,j:j+n2-1).*rotfilter;
%                 newimage(i,j)=sum(newvalue(:));
%             end
%         end
%     end
%     output=newimage;
%FFT method:
    if z==3
        newout1=ifft2(fft2(padimage(:,:,1)).*fft2(padfilter));
        newout2=ifft2(fft2(padimage(:,:,2)).*fft2(padfilter));
        newout3=ifft2(fft2(padimage(:,:,3)).*fft2(padfilter));
        newout(:,:,1)=newout1(m2-padsizem:m1+m2-1-padsizem,n2-padsizen:n1+n2-1-padsizen);
        newout(:,:,2)=newout2(m2-padsizem:m1+m2-1-padsizem,n2-padsizen:n1+n2-1-padsizen);
        newout(:,:,3)=newout3(m2-padsizem:m1+m2-1-padsizem,n2-padsizen:n1+n2-1-padsizen);
        output=newout;
    else
        newout=ifft2(fft2(padimage).*fft2(padfilter));
        newout=newout(m2-padsizem:m1+m2-1-padsizem,n2-padsizen:n1+n2-1-padsizen);
        output=newout;
    end
%     figure(2)
%     imshow(newout);
%%%%%%%%%%%%%%%%





