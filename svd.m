clear all;
close all;
clc;

% Read an input image
Img=imread("girl.png");
Img = double(Img);                

% Convert image into red , green , blue image
redImg = Img(:,:,1);            
greenImg = Img(:,:,2);         
blueImg = Img(:,:,3); 

               
% Find SVD of redImg , greenImg , blueImg image
[Ur, Sr, Vr] = svd(redImg);   
[Ug, Sg, Vg] = svd(greenImg); 
[Ub, Sb, Vb] = svd(blueImg);  

    
% Row , column of image
No_rows = size(Img)(1);        
No_cols = size(Img)(2);

   
% Initialize some vector
dispError = [];                 
S_Values = [];
dispError1 = [];
S_Values1 = [];


% Start for loop
for No_modes=10:30:400
          
% Low rank approximation for red image
  Ured = Ur(1:No_rows,1:No_modes);       
  Sred = Sr(1:No_modes,1:No_modes);
  Vred = Vr(1:No_cols,1:No_modes);

% Low rank approximation for green image
  Ugreen = Ug(1:No_rows,1:No_modes);  
  Sgreen = Sg(1:No_modes,1:No_modes);
  Vgreen = Vg(1:No_cols,1:No_modes);

% Low rank approximation for blue image
  Ublue = Ub(1:No_rows,1:No_modes);           
  Sblue = Sb(1:No_modes,1:No_modes);
  Vblue = Vb(1:No_cols,1:No_modes);

 % calculate red,green,blue image
  red = Ured*Sred*(Vred');   
  green = Ugreen*Sgreen*(Vgreen');        
  blue = Ublue*Sblue*(Vblue');            

  
  red = uint8(red);
  green = uint8(green);
  blue = uint8(blue);

  
% Calculate compressed image from adding red,green,blue images
  SVD_compress_Img = cat(3,red,green,blue);      
  
% Error values between original and compressed image
  error=sum(sum((Img-SVD_compress_Img).^2));      
  
% Values of compressed image
  compImgVal=sum(sum((SVD_compress_Img).^2));       

  
% Store error values for display
  dispError = [dispError; error];     
 % store S values for display  
  S_Values = [S_Values; No_modes];      
 % store values for display
   dispError1 = [dispError1; compImgVal]; 
   S_Values1 = [S_Values1; No_modes];
    
% Show images    
imwrite(SVD_compress_Img,"max_image.jpg");
% end for loop
end                          

           
% Graph between error and singular values
figure;                                 
title('Error in Compression');
plot(S_Values, dispError);      
xlabel('Singular Values ');
ylabel('Error between Compressed and Original Image ');


% Graph between original image and singular values
figure;                            
title('Compressed Image VS Singular Values');
plot(S_Values1, dispError1);
xlabel('Singular Values ');
ylabel('Compressed Image');

