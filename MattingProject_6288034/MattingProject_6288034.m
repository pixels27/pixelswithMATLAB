%-----MattingProject_6288034------%
%Pranungfun Prapaenee sec2 6288034

%Composite (cast to double)
c1 = double(imread("CompositeImg01.jpg"));
c2 = double(imread("CompositeImg02.jpg"));

%Background (cast to double)
bg1 = double(imread("BackgroundImg01.jpg"));
bg2 = double(imread("BackgroundImg02.jpg"));

% access RGB of c1
c1R = c1(:,:,1);
c1G = c1(:,:,2);
c1B = c1(:,:,3);

% access RGB of c2
c2R = c2(:,:,1);
c2G = c2(:,:,2);
c2B = c2(:,:,3);

% access RGB of bg1
bg1R = bg1(:,:,1);
bg1G = bg1(:,:,2);
bg1B = bg1(:,:,3);

% access RGB of bg2
bg2R = bg2(:,:,1);
bg2G = bg2(:,:,2);
bg2B = bg2(:,:,3);

Numerator = (c1R-c2R).*(bg1R-bg2R)+(c1G-c2G).*(bg1G-bg2G)+(c1B-c2B).*(bg1B-bg2B);

Denominator = (bg1R-bg2R).^2+(bg1G-bg2G).^2+(bg1B-bg2B).^2;

%find alpha
a = 1 - (Numerator./Denominator);

%find foreground Red
fr = (c1R-(1-a).*bg1R)./a;
%find foreground Red
fg = (c1G-(1-a).*bg1G)./a;
%foreground Blue
fb = (c1B-(1-a).*bg1B)./a;

%import new bg
newBg = imread("NewBackground.jpg");

%layer RGB (new Background)
newBgR = double(newBg(:,:,1)); %Red
newBgG = double(newBg(:,:,2)); %Green
newBgB = double(newBg(:,:,3)); %Blue

%find RGB of new composite
newCR = a.*fr+(1-a).*newBgR;
newCG = a.*fg+(1-a).*newBgG;
newCB = a.*fb+(1-a).*newBgB;

%cast to int
newCR = uint8(newCR);
newCG = uint8(newCG);
newCB = uint8(newCB);

%new Component
newCom = cat(3,newCR,newCG,newCB);

%Matte
[row, col, ncolors] = size(c1);

%get size from picture for create white bg 
WR = zeros(row,col);
wG = zeros(row,col);
WB = zeros(row,col);

% Composite with white bg
WR(:,:) = 255;
WG(:,:) = 255;
WB(:,:) = 255;

% composite with white bg
CWR = a.*fr+(1-a).*WR;
CWG = a.*fg+(1-a).*WG;
CWB = a.*fb+(1-a).*WB;

%cast to int
CWR =uint8(CWR);
CWG =uint8(CWG);
CWB =uint8(CWB);

matte = cat(3, CWR, CWG, CWB); %combined layers

%cast back to int
c1 = uint8(c1);
c2 = uint8(c2);
bg1 = uint8(bg1);
bg2 = uint8(bg2);
newBg = uint8(newBg);

%show figure
%subplot(row,col,position)
subplot(4,2,1), imshow(c1)
subplot(4,2,2), imshow(c2)
subplot(4,2,3), imshow(bg1)
subplot(4,2,4), imshow(bg2)
subplot(4,2,5), imshow(newBg)
subplot(4,2,6), imshow(newCom)
subplot(4,2,7), imshow(matte)

%imwrite
imwrite(matte,"matteOutput.jpg")
imwrite(newCom,"newCompoOutput.jpg")