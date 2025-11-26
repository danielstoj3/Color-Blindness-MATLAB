%% Close all disable for testing
close all
%% Settings Section
% Image Used
RGBimage = imread("VisionSamples.jpeg");

% Method Used
method = 2;

% ImageSC Display toggle
displayImageSC = 0;

% Original Grouping
numberOfHueOriginalGroups = 10;
numberOfSatOriginalGroups = 4;
numberOfValOriginalGroups = 4;

% Filter Grouping
numberOfHueFilterGroups = 10;
numberOfSatFilterGroups = 4;
numberOfValFilterGroups = 4;

% Groups of difficulty
difficultyGroupingAutomatic = 1;
if difficultyGroupingAutomatic ==1
    numberOfDifficultGroups = 5;
else
    DifficultyPerecentCutoff = 10;
end

%% Setup
HSVimage = rgb2hsv(RGBimage);
untouchedHSV = HSVimage;
imageHue = HSVimage(:,:,1);
imageSat = HSVimage(:,:,2);
imageValues = HSVimage(:,:,3);
originalHue = imageHue;
originalValues = imageValues;
originalSat = imageSat;
redHigh = 330/360;
if method == 1 || method == 3
    yellowHue = 52/360; %52 or 60
    blueHue = 220/360; %220 or 240
elseif method == 2
    yellowHue = 60/360; %52 or 60
    blueHue = 240/360; %220 or 240
end
greenHigh = 160/360;
%% Method 1
if method == 1
    % Main Value shift
    % Bright Red to yellow value shift
    underYellowImage = imageHue;
    underYellowImage(underYellowImage==0) = -1;
    underYellowImage(underYellowImage>yellowHue) = 0;
    underYellowImage(underYellowImage>0) = yellowHue - underYellowImage(underYellowImage>0);
    underYellowImage(underYellowImage==-1) = yellowHue;
    imageValues = imageValues - underYellowImage.*4.*originalSat;
    imageValues(imageValues<0) = 0;
    
    % Yellow to green value shift
    aboveYellowImage = imageHue;
    aboveYellowImage(aboveYellowImage<yellowHue | aboveYellowImage>greenHigh) = 0;
    aboveYellowImage(aboveYellowImage>0) = aboveYellowImage(aboveYellowImage>0) - (yellowHue);
    imageValues = imageValues - aboveYellowImage.*originalSat;
    imageValues(imageValues<0) = 0;
    
    % Dark Red to purple value
    overRedImage = imageHue;
    overRedImage(overRedImage<redHigh) = 0;
    overRedImage(overRedImage>0) = 1 - overRedImage(overRedImage>0);
    overRedExtra = ones(size(imageValues)) * .5;
    overRedExtra(overRedImage==0) = 0;
    imageValues = imageValues - overRedImage.*7.*originalSat -overRedExtra.*originalSat;
    imageValues(imageValues<0) = 0;

    BPShift = imageHue;
    BPShift(BPShift < greenHigh+25/360 | BPShift > blueHue) = 0;
    BPShift(BPShift>0) = abs(BPShift(BPShift>0) - blueHue);
    imageSat = imageSat - BPShift.*4.5.*originalValues.*originalSat;
    imageSat(imageSat<0) = 0;
    
    BPShift = imageHue;
    BPShift(BPShift < blueHue | BPShift > redHigh-10/360) = 0;
    BPShift(BPShift>0) = abs(BPShift(BPShift>0) - blueHue);
    imageSat = imageSat - BPShift.*3.*originalValues.*originalSat;
    imageSat(imageSat<0) = 0;
    
    % Green Bright Blue sat shift
    GBBShift = imageHue;
    GBBShift(GBBShift < greenHigh | GBBShift > greenHigh+25/360) = 0;
    GBBShift(GBBShift>0) = .25 - abs(180/360-GBBShift(GBBShift>0));
    imageSat = imageSat - GBBShift.*3.*originalValues.*originalSat;
    imageSat(imageSat<0) = 0;
    
    % Green val shift
    GShift = imageHue;
    GShift(GShift < greenHigh | GShift > greenHigh+10/360) = 0;
    GShift(GShift>0) = GShift(GShift>0)-greenHigh;
    imageSat = imageSat - GShift.*12.*originalValues.*originalSat;
    imageValues = imageValues - GShift.*8.*originalValues.*originalSat;
    imageValues(imageValues<0) = 0;
    imageSat(imageSat<0) = 0;
    
    % Purple sat shift
    PShift = imageHue;
    PShift(PShift < redHigh-10/360 | PShift > redHigh) = 0;
    PShift(PShift>0) = .20 - (redHigh - PShift(PShift>0));
    imageSat = imageSat - PShift.*4.75.*originalSat.*originalValues;
    imageValues = imageValues - PShift.*2.*originalValues.*originalSat;
    imageSat(imageSat<0) = 0;
    imageValues(imageValues<0) = 0;



    % Hue Shift
    % Major color shift
    imageHue(imageHue <= greenHigh) = yellowHue;
    imageHue(imageHue >= redHigh) = yellowHue;
    imageHue(imageHue > greenHigh & imageHue < redHigh) = blueHue;
end
%% Method 2
if method == 2
    %------Value Shift------
    % Bright Red to yellow value shift
    underYellowImage = imageHue;
    underYellowImage(underYellowImage==0) = -1;
    underYellowImage(underYellowImage>yellowHue) = 0;
    underYellowImage(underYellowImage>0) = yellowHue - underYellowImage(underYellowImage>0);
    underYellowImage(underYellowImage==-1) = yellowHue;
    imageValues = imageValues - underYellowImage.*3.*originalSat.*originalValues;
    imageValues(imageValues<0) = 0;
    
    % Yellow to green value shift
    aboveYellowImage = imageHue;
    aboveYellowImage(aboveYellowImage<yellowHue | aboveYellowImage>greenHigh) = 0;
    aboveYellowImage(aboveYellowImage>0) = aboveYellowImage(aboveYellowImage>0) - yellowHue;
    imageValues = imageValues - aboveYellowImage.*1.5.*originalSat.*originalValues;
    imageValues(imageValues<0) = 0;
    
    % Dark Red to purple value
    overRedImage = imageHue;
    overRedImage(overRedImage<redHigh) = 0;
    overRedImage(overRedImage>0) = 1 - overRedImage(overRedImage>0);
    overRedExtra = ones(size(imageValues)) * .4;
    overRedExtra(overRedImage==0) = 0;
    imageValues = imageValues - overRedImage.*1.8.*originalSat.*originalValues -overRedExtra.*originalSat.*originalValues;
    imageValues(imageValues<0) = 0;
    
    %------Yellow Sat Shift------
    % Blue Green sat shift
    BGShift = imageHue;
    BGShift(BGShift < 130/360 | BGShift > greenHigh) = 0;
    BGShift(BGShift>0) = BGShift(BGShift>0) - 130/360;
    imageSat = imageSat - BGShift.*10.*originalSat;
    imageValues = imageValues + BGShift.*2.*originalValues;
    imageSat(imageSat<0) = 0;
    
    % Red Purple sat Shift
    RPShift = imageHue;
    RPShift(RPShift < redHigh) = 0;
    RPShift(RPShift>0) = 1 - RPShift(RPShift>0);
    imageSat = imageSat - RPShift.*10.*originalSat;
    imageValues = imageValues + RPShift.*1.75.*originalValues.*originalSat;
    imageSat(imageSat<0) = 0;
    imageValues(imageValues>1) = 1;
    
    %------Blue Sat Shift------
    % Blue Purple sat shift
    BPShift = imageHue;
    BPShift(BPShift < greenHigh+25/360 | BPShift > blueHue) = 0;
    BPShift(BPShift>0) = abs(BPShift(BPShift>0) - blueHue);
    imageSat = imageSat - BPShift.*4.5.*originalValues.*originalSat;
    imageSat(imageSat<0) = 0;
    
    BPShift = imageHue;
    BPShift(BPShift < blueHue | BPShift > redHigh-10/360) = 0;
    BPShift(BPShift>0) = abs(BPShift(BPShift>0) - blueHue);
    imageSat = imageSat - BPShift.*3.*originalValues.*originalSat;
    imageSat(imageSat<0) = 0;
    
    % Green Bright Blue sat shift
    GBBShift = imageHue;
    GBBShift(GBBShift < greenHigh | GBBShift > greenHigh+25/360) = 0;
    GBBShift(GBBShift>0) = .25 - abs(180/360-GBBShift(GBBShift>0));
    imageSat = imageSat - GBBShift.*3.*originalValues.*originalSat;
    imageSat(imageSat<0) = 0;
    
    % Green val shift
    GShift = imageHue;
    GShift(GShift < greenHigh | GShift > greenHigh+10/360) = 0;
    GShift(GShift>0) = GShift(GShift>0)-greenHigh;
    imageSat = imageSat - GShift.*12.*originalValues.*originalSat;
    imageValues = imageValues - GShift.*8.*originalValues.*originalSat;
    imageValues(imageValues<0) = 0;
    imageSat(imageSat<0) = 0;
    
    % Purple sat shift
    PShift = imageHue;
    PShift(PShift < redHigh-10/360 | PShift > redHigh) = 0;
    PShift(PShift>0) = .20 - (redHigh - PShift(PShift>0));
    imageSat = imageSat - PShift.*4.75.*originalSat;
    imageValues = imageValues - PShift.*2.*originalValues.*originalSat;
    imageSat(imageSat<0) = 0;
    imageValues(imageValues<0) = 0;

    %------Hue Shift------
    % Major color shift
    imageHue(imageHue <= greenHigh) = yellowHue;
    imageHue(imageHue >= redHigh) = yellowHue-5/360;
    imageHue(imageHue > greenHigh & imageHue < redHigh) = blueHue;
end
%% Method 3
if method == 3
    satCutOff = originalSat;
    satCutOff(satCutOff>.5) = 1;
    satCutOff(satCutOff<=.5) = satCutOff(satCutOff<=.5).*2;
    %Red orange Sat shift
    ROSShift = imageHue;
    eqValues = [2397.8442,718.1918,-177.2063,10.1309,0.0029];
    ROSShift(ROSShift >= redHigh) = ROSShift(ROSShift >= redHigh)-1;
    ROSShift(ROSShift > 45/360) = 0;
    RGSShiftArea = ROSShift;
    RGSShiftArea(RGSShiftArea~=0) = 1;
    imageSat = imageSat + (eqValues(1).*ROSShift.^4 + eqValues(2).*ROSShift.^3 + eqValues(3).*ROSShift.^2 + eqValues(4).*ROSShift + eqValues(5).*RGSShiftArea).*satCutOff;
    imageSat(imageSat>1) = 1;
    imageSat(imageSat<0) = 0;

    % Red orange Val shift
    shiftValues = imageHue;
    eqValues = [1354.0773,139.1387,-32.5140,3.1049,-0.4417];
    shiftValues(shiftValues >= 348/360) = shiftValues(shiftValues >= 348/360)-1;
    shiftValues(shiftValues ==0) = 1/720;
    shiftValues(shiftValues > 45/360) = 0;
    shiftArea = shiftValues;
    shiftArea(shiftArea~=0) = 1;
    imageValues = imageValues + (eqValues(1).*shiftValues.^4 + eqValues(2).*shiftValues.^3 + eqValues(3).*shiftValues.^2 + eqValues(4).*shiftValues + eqValues(5).*shiftArea).*satCutOff;
    imageValues(imageValues>1) = 1;
    imageValues(imageValues<0) = 0;

    % Red transition Val shift part one
    shiftValues = imageHue;
    shiftValues(shiftValues >= 348/360 | shiftValues <= 346/360) = 0;
    shiftValues(shiftValues~=0) = shiftValues(shiftValues~=0)-1;
    shiftArea = shiftValues;
    shiftArea(shiftArea~=0) = 1;
    shiftFirstAmount = (eqValues(1).*shiftValues.^4 + eqValues(2).*shiftValues.^3 + eqValues(3).*shiftValues.^2 + eqValues(4).*shiftValues + eqValues(5).*shiftArea).*satCutOff;

    % Red purple Val shift
    shiftValues = imageHue;
    eqValues = [2930.919,1541.738,337.554,24.995,0.000];
    shiftValues(shiftValues >= redHigh & shiftValues <= 346/360) = shiftValues(shiftValues >= redHigh & shiftValues <= 346/360)-1;
    shiftValues(shiftValues>0) = 0;
    shiftArea = shiftValues;
    shiftArea(shiftArea~=0) = 1;
    imageValues = imageValues + (eqValues(1).*shiftValues.^4 + eqValues(2).*shiftValues.^3 + eqValues(3).*shiftValues.^2 + eqValues(4).*shiftValues + eqValues(5).*shiftArea).*satCutOff;
    imageValues(imageValues>1) = 1;
    imageValues(imageValues<0) = 0;

    % Red transition Val shift part two
    shiftValues = imageHue;
    shiftValues(shiftValues >= 348/360 | shiftValues <= 346/360) = 0;
    shiftValues(shiftValues~=0) = shiftValues(shiftValues~=0)-1;
    shiftArea = shiftValues;
    shiftArea(shiftArea~=0) = 1;
    shiftSecondAmount = (eqValues(1).*shiftValues.^4 + eqValues(2).*shiftValues.^3 + eqValues(3).*shiftValues.^2 + eqValues(4).*shiftValues + eqValues(5).*shiftArea).*satCutOff;
    
    % Adding red Val transition
    shiftValues = imageHue;
    shiftValues(shiftValues >= 348/360 | shiftValues <= 346/360) = 0;
    shiftValues(shiftValues~=0) = (shiftValues(shiftValues~=0) - 346/360).*(360/2);
    imageValues = imageValues+shiftFirstAmount.*shiftValues;
    shiftValues(shiftValues~=0) = abs(shiftValues(shiftValues~=0)-1);
    imageValues = imageValues+shiftSecondAmount.*shiftValues;
    imageValues(imageValues>1) = 1;
    imageValues(imageValues<0) = 0;

    
    
    % Yellow green Sat shift
    YGSShift = imageHue;
    eqValues = [-11.2504,13.0523,-3.4541,0.2652];
    YGSShift(YGSShift < 45/360 | YGSShift > greenHigh) = 0;
    YGSArea = YGSShift;
    YGSArea(YGSArea~=0) = 1;
    imageSat = imageSat + (eqValues(1).*YGSShift.^3 + eqValues(2).*YGSShift.^2 + eqValues(3).*YGSShift + eqValues(4).*YGSArea).*satCutOff;
    imageSat(imageSat>1) = 1;
    imageSat(imageSat<0) = 0;

    %------Hue Shift------
    % Major color shift
    imageHue(imageHue <= greenHigh) = yellowHue;
    imageHue(imageHue >= redHigh) = yellowHue;

    % RGHShift = imageHue;
    % RGHShift(RGHShift>=redHigh) = 1-RGHShift(RGHShift >= redHigh);
    %eqValues = [-29.1968,17.5030,-3.0967,0.1798,0.1443];
    %imageHue(originalHue <= greenHigh) = eqValues(1).*RGHShift(originalHue <= greenHigh).^4 + eqValues(2).*RGHShift(originalHue <= greenHigh).^3 + eqValues(3).*RGHShift(originalHue <= greenHigh).^2 + eqValues(4).*RGHShift(originalHue <= greenHigh) + eqValues(5);
    %imageHue(originalHue >= redHigh) = eqValues(1).*RGHShift(originalHue >= redHigh).^4 + eqValues(2).*RGHShift(originalHue >= redHigh).^3 + eqValues(3).*RGHShift(originalHue >= redHigh).^2 + eqValues(4).*RGHShift(originalHue >= redHigh) + eqValues(5);

    
    imageSat(imageHue > greenHigh & imageHue < redHigh) = 0;
    
end




%% displaying filter results
% Setting values
HSVimage(:,:,1) = imageHue;
HSVimage(:,:,2) = imageSat;
HSVimage(:,:,3) = imageValues;
filteredImage = hsv2rgb(HSVimage);
figure
imshow(RGBimage)
figure
imshow(filteredImage)

%% Original Image grouping
% Hue Grouping
hueGrouping = linspace(0,1,(numberOfHueOriginalGroups+1));
hueSectionsOriginal = zeros(size(originalHue,1),size(originalHue,2));
for i = 1:numberOfHueOriginalGroups-1
    hueSection = zeros(size(originalHue,1),size(originalHue,2));
    hueSection(originalHue >= hueGrouping(i) & originalHue < hueGrouping(i+1)) = 1;
    hueSectionsOriginal = hueSectionsOriginal+hueSection*i;
end
hueSection = zeros(size(originalHue,1),size(originalHue,2));
hueSection(originalHue >= hueGrouping(end-1)) = 1;
hueSectionsOriginal = hueSectionsOriginal+hueSection.*numberOfHueOriginalGroups;

% Sat grouping
satGrouping = linspace(0,1,(numberOfSatOriginalGroups+1));
satSectionsOriginal = zeros(size(originalSat,1),size(originalSat,2));
for i = 1:numberOfSatOriginalGroups-1
    satSection = zeros(size(originalSat,1),size(originalSat,2));
    satSection(originalSat >= satGrouping(i) & originalSat < satGrouping(i+1)) = 1;
    satSectionsOriginal = satSectionsOriginal + satSection*i;
end
satSection = zeros(size(originalSat,1),size(originalSat,2));
satSection(originalSat >= satGrouping(end-1)) = 1;
satSectionsOriginal = satSectionsOriginal + satSection*numberOfSatOriginalGroups;

% Val grouping
valGrouping = linspace(0,1,(numberOfValOriginalGroups+1));
valSectionsOriginal = zeros(size(originalValues,1),size(originalValues,2));
for i = 1:numberOfValOriginalGroups-1
    valSection = zeros(size(originalValues,1),size(originalValues,2));
    valSection(originalValues >= valGrouping(i) & originalValues < valGrouping(i+1)) = 1;
    valSectionsOriginal = valSectionsOriginal + valSection*i;
end
valSection = zeros(size(originalValues,1),size(originalValues,2));
valSection(originalValues >= valGrouping(end-1)) = 1;
valSectionsOriginal = valSectionsOriginal + valSection*numberOfValOriginalGroups;

%% Filtered Image grouping
% Hue Grouping
hueGroupingFilter = linspace(0,1,(numberOfHueFilterGroups+1));
hueSectionsFilter = zeros(size(imageHue,1),size(imageHue,2));
for i = 1:numberOfHueFilterGroups-1
    hueSection = zeros(size(imageHue,1),size(imageHue,2));
    hueSection(imageHue >= hueGroupingFilter(i) & imageHue < hueGroupingFilter(i+1)) = 1;
    hueSectionsFilter = hueSectionsFilter + hueSection*i;
end
hueSection = zeros(size(imageHue,1),size(imageHue,2));
hueSection(imageHue >= hueGroupingFilter(end-1)) = 1;
hueSectionsFilter = hueSectionsFilter + hueSection*numberOfHueFilterGroups;

% Sat grouping
satGroupingFilter = linspace(0,1,(numberOfSatFilterGroups+1));
satSectionsFilter = zeros(size(imageSat,1),size(imageSat,2));
for i = 1:numberOfSatFilterGroups-1
    satSection = zeros(size(imageSat,1),size(imageSat,2));
    satSection(imageSat >= satGroupingFilter(i) & imageSat < satGroupingFilter(i+1)) = 1;
    satSectionsFilter = satSectionsFilter + satSection*i;
end
satSection = zeros(size(imageSat,1),size(imageSat,2));
satSection(imageSat >= satGroupingFilter(end-1)) = 1;
satSectionsFilter = satSectionsFilter + satSection*numberOfSatFilterGroups;


% Val grouping
valGroupingFilter = linspace(0,1,(numberOfValFilterGroups+1));
valSectionsFilter = zeros(size(imageValues,1),size(imageValues,2));
for i = 1:numberOfValFilterGroups-1
    valSection = zeros(size(imageValues,1),size(imageValues,2));
    valSection(imageValues >= valGroupingFilter(i) & imageValues < valGroupingFilter(i+1)) = 1;
    valSectionsFilter = valSectionsFilter+valSection*i;
end
valSection = zeros(size(imageValues,1),size(imageValues,2));
valSection(imageValues >= valGroupingFilter(end-1)) = 1;
valSectionsFilter = valSectionsFilter+valSection*numberOfValFilterGroups;


%% Combined Original Grouping
numberOfCombinedOriginalGroups = numberOfHueOriginalGroups * numberOfSatOriginalGroups * numberOfValOriginalGroups;
groupIDsOriginal = zeros(1,numberOfCombinedOriginalGroups);
groupPixelsOriginal = zeros(1,size(imageValues,1)*size(imageValues,2));
groupMatrixesOriginal = zeros(size(imageValues,1),size(imageValues,2));
groupIndex = 1;
tic
for h = 1:numberOfHueOriginalGroups
    if any(any(hueSectionsOriginal==h))
        for s = 1:numberOfSatOriginalGroups
            if any(any(hueSectionsOriginal==h & satSectionsOriginal==s))
                for v = 1:numberOfValOriginalGroups
                    if any(any(hueSectionsOriginal==h & satSectionsOriginal==s & valSectionsOriginal==v))
                        groupMatrix = (hueSectionsOriginal==h & satSectionsOriginal==s & valSectionsOriginal==v); 
                        groupID = h*1000000+s*1000+v;
                        groupMatrixesOriginal(:,:) = groupMatrixesOriginal + groupMatrix*groupID;
                        pixelCount = sum(sum(groupMatrix));
                        groupPixelsOriginal(groupIndex) = pixelCount;
                        groupIDsOriginal(groupIndex) = groupID;
                        groupIndex = groupIndex+1;
                   end
                end
            end
        end
    end
end
toc
groupIDsOriginal(groupIDsOriginal==0) = [];
groupPixelsOriginal(groupPixelsOriginal==0) = [];

% Group Number Matrix
originalNumberMatrix = groupMatrixesOriginal;
for i = 1:length(groupIDsOriginal)
    originalNumberMatrix(originalNumberMatrix==groupIDsOriginal(i)) = i;
end

%% Combined Filtered Grouping
numberOfCombinedFilterGroups = numberOfHueFilterGroups * numberOfSatFilterGroups * numberOfValFilterGroups;
groupIDsFilter = zeros(1,numberOfCombinedFilterGroups);
groupPixelsFilter = zeros(1,size(imageValues,1)*size(imageValues,2));
groupMatrixesFilter = zeros(size(imageValues,1),size(imageValues,2));
groupIndex = 1;
%tic
for h = 1:numberOfHueFilterGroups
    if any(any(hueSectionsFilter==h))
        for s = 1:numberOfSatFilterGroups
            if any(any(hueSectionsFilter==h & satSectionsFilter==s))
                for v = 1:numberOfValFilterGroups
                    if any(any(hueSectionsFilter==h & satSectionsFilter==s & valSectionsFilter==v))
                        groupMatrix = (hueSectionsFilter==h & satSectionsFilter==s & valSectionsFilter==v); 
                        groupID = h*1000000+s*1000+v;
                        groupMatrixesFilter(:,:) = groupMatrixesFilter + groupMatrix*groupID;
                        pixelCount = sum(sum(groupMatrix));
                        groupPixelsFilter(groupIndex) = pixelCount;
                        groupIDsFilter(groupIndex) = groupID;
                        groupIndex = groupIndex+1;
                   end
                end
            end
        end
    end
end
%toc
groupIDsFilter(groupIDsFilter==0) = [];
groupPixelsFilter(groupPixelsFilter==0) = [];

% Group Number Matrix
filterNumberMatrix = groupMatrixesFilter;
for i = 1:length(groupIDsFilter)
    filterNumberMatrix(filterNumberMatrix==groupIDsFilter(i)) = i;
end

%% Difficult sections
sortedPixelCountFilter = sort(groupPixelsFilter);
if numberOfDifficultGroups > length(sortedPixelCountFilter)
    numberOfDifficultGroups = length(sortedPixelCountFilter);
end
DifficultGroupIDs = find(groupPixelsFilter>=sortedPixelCountFilter(end-(numberOfDifficultGroups-1)));

difficultMatrix = groupMatrixesFilter;
for i = 1:numberOfDifficultGroups
    difficultMatrix(difficultMatrix==groupIDsFilter(DifficultGroupIDs(i))) = DifficultGroupIDs(i);
end
difficultMatrix(difficultMatrix>max(DifficultGroupIDs)) = 0;

figure
for i = 1:numberOfDifficultGroups
    currentDifficultID = find(groupPixelsFilter==sortedPixelCountFilter(end-(i-1)));
    disp("Filter Group "+currentDifficultID+" with "+sortedPixelCountFilter(end-(i-1))+" pixels has "+(length(unique(unique(groupMatrixesOriginal(difficultMatrix==currentDifficultID)))))+" different original colors")
    
    difficultOriginalImage = RGBimage;
    difficultOriginalR = RGBimage(:,:,1);
    difficultOriginalG = RGBimage(:,:,2);
    difficultOriginalB = RGBimage(:,:,3);
    difficultOriginalR(difficultMatrix~=currentDifficultID) = 0;
    difficultOriginalG(difficultMatrix~=currentDifficultID) = 0;
    difficultOriginalB(difficultMatrix~=currentDifficultID) = 0;
    difficultOriginalImage(:,:,1)=difficultOriginalR;
    difficultOriginalImage(:,:,2)=difficultOriginalG;
    difficultOriginalImage(:,:,3)=difficultOriginalB;

    subplot(numberOfDifficultGroups,2,(1+(i-1)*2))
    imshow(difficultOriginalImage)
    titleText = "Original Image Isolating Issue Group "+i;
    title(titleText)

    difficultFilterImage = filteredImage;
    difficultFilterR = filteredImage(:,:,1);
    difficultFilterG = filteredImage(:,:,2);
    difficultFilterB = filteredImage(:,:,3);
    difficultFilterR(difficultMatrix~=currentDifficultID) = 0;
    difficultFilterG(difficultMatrix~=currentDifficultID) = 0;
    difficultFilterB(difficultMatrix~=currentDifficultID) = 0;
    difficultFilterImage(:,:,1)=difficultFilterR;
    difficultFilterImage(:,:,2)=difficultFilterG;
    difficultFilterImage(:,:,3)=difficultFilterB;
    subplot(numberOfDifficultGroups,2,(2+(i-1)*2))
    imshow(difficultFilterImage)
    titleText = "Filtered Image Isolating Issue Group "+i;
    title(titleText)
end


%% Test Display of Original results with imageSC
if displayImageSC == 1
    groupRGBs = zeros(length(groupIDsOriginal),3);
    for i = 1:length(groupIDsOriginal)
        usedId = char(string(groupIDsOriginal(i)));
        aH = str2double(string(usedId(1:end-6)));
        bS = str2double(string(usedId(end-5:end-3)));
        cV = str2double(string(usedId(end-2:end)));
    
        AH = mean([hueGrouping(aH),hueGrouping(aH+1)]);
        BS = mean([satGrouping(bS),satGrouping(bS+1)]);
        CV = mean([valGrouping(cV),valGrouping(cV+1)]);
    
        usedRGB = hsv2rgb(cat(3,AH,BS,CV)); 
        groupRGBs(i,1) = usedRGB(1,1,1);
        groupRGBs(i,2) = usedRGB(1,1,2);
        groupRGBs(i,3) = usedRGB(1,1,3);
    end
    %disp(groupRGBs(1,1:3))
    
    figure
    imagesc(originalNumberMatrix)
    colormap(groupRGBs)
end


%% Test Display of Filtered results with imageSC
if displayImageSC == 1
    groupRGBs = zeros(length(groupIDsFilter),3);
    for i = 1:length(groupIDsFilter)
        usedId = char(string(groupIDsFilter(i)));
        aH = str2double(string(usedId(1:end-6)));
        bS = str2double(string(usedId(end-5:end-3)));
        cV = str2double(string(usedId(end-2:end)));
    
        AH = mean([hueGroupingFilter(aH),hueGroupingFilter(aH+1)]);
        BS = mean([satGroupingFilter(bS),satGroupingFilter(bS+1)]);
        CV = mean([valGroupingFilter(cV),valGroupingFilter(cV+1)]);
    
        usedRGB = hsv2rgb(cat(3,AH,BS,CV)); 
        groupRGBs(i,1) = usedRGB(1,1,1);
        groupRGBs(i,2) = usedRGB(1,1,2);
        groupRGBs(i,3) = usedRGB(1,1,3);
    end
    %disp(groupRGBs(1,1:3))
    
    figure
    imagesc(filterNumberMatrix)
    colormap(groupRGBs)
end

%% Test Display of grouping
% for j = 1:numberOfValFiltergroups
%     valGroupImage = filteredImage;
%     for i = 1:3
%         valSlice = filteredImage(:,:,i);
%         valSlice(~valSectionsFilter(:,:,j)) = 0;
%         valGroupImage(:,:,i) = valSlice;
%     end
%     figure
%     imshow(valGroupImage)
% end

%% Test Display of all groupings
% plotCol = 5;
% plotRows = ceil((numberOfCombinedOriginalGroups/numberOfHueOriginalGroups)/plotCol);
%         groupImage = RGBimage;
%         for i = 1:numberOfCombinedOriginalGroups
%             if groupPixelsOriginal(i) ==0
%                 disp(groupIDsOriginal(i)+" is blank")
%             else
%                 for rgb = 1:3
%                     groupSlice = RGBimage(:,:,rgb);
%                     groupSlice(~groupMatrixesOriginal(:,:,i)) = 0;
%                     groupImage(:,:,rgb) = groupSlice;
%                 end
%                 figure
%                 imshow(groupImage)
%             end
%         end

   
