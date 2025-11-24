RGBpepper = imread("Spectrum.jpg");
HSVpepper = rgb2hsv(RGBpepper);
untouchedHSV = HSVpepper;
pepperHue = HSVpepper(:,:,1);
pepperSat = HSVpepper(:,:,2);
pepperValues = HSVpepper(:,:,3);
originalHue = pepperHue;
originalValues = pepperValues;
originalSat = pepperSat;
method = 1;
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
    underYellowPepper = pepperHue;
    underYellowPepper(underYellowPepper==0) = -1;
    underYellowPepper(underYellowPepper>yellowHue) = 0;
    underYellowPepper(underYellowPepper>0) = yellowHue - underYellowPepper(underYellowPepper>0);
    underYellowPepper(underYellowPepper==-1) = yellowHue;
    pepperValues = pepperValues - underYellowPepper.*4.*originalSat;
    pepperValues(pepperValues<0) = 0;
    
    % Yellow to green value shift
    aboveYellowPepper = pepperHue;
    aboveYellowPepper(aboveYellowPepper<yellowHue | aboveYellowPepper>greenHigh) = 0;
    aboveYellowPepper(aboveYellowPepper>0) = aboveYellowPepper(aboveYellowPepper>0) - (yellowHue);
    pepperValues = pepperValues - aboveYellowPepper.*originalSat;
    pepperValues(pepperValues<0) = 0;
    
    % Dark Red to purple value
    overRedPepper = pepperHue;
    overRedPepper(overRedPepper<redHigh) = 0;
    overRedPepper(overRedPepper>0) = 1 - overRedPepper(overRedPepper>0);
    overRedExtra = ones(size(pepperValues)) * .5;
    overRedExtra(overRedPepper==0) = 0;
    pepperValues = pepperValues - overRedPepper.*7.*originalSat -overRedExtra.*originalSat;
    pepperValues(pepperValues<0) = 0;

    BPShift = pepperHue;
    BPShift(BPShift < greenHigh+25/360 | BPShift > blueHue) = 0;
    BPShift(BPShift>0) = abs(BPShift(BPShift>0) - blueHue);
    pepperSat = pepperSat - BPShift.*4.5.*originalValues.*originalSat;
    pepperSat(pepperSat<0) = 0;
    
    BPShift = pepperHue;
    BPShift(BPShift < blueHue | BPShift > redHigh-10/360) = 0;
    BPShift(BPShift>0) = abs(BPShift(BPShift>0) - blueHue);
    pepperSat = pepperSat - BPShift.*3.*originalValues.*originalSat;
    pepperSat(pepperSat<0) = 0;
    
    % Green Bright Blue sat shift
    GBBShift = pepperHue;
    GBBShift(GBBShift < greenHigh | GBBShift > greenHigh+25/360) = 0;
    GBBShift(GBBShift>0) = .25 - abs(180/360-GBBShift(GBBShift>0));
    pepperSat = pepperSat - GBBShift.*3.*originalValues.*originalSat;
    pepperSat(pepperSat<0) = 0;
    
    % Green val shift
    GShift = pepperHue;
    GShift(GShift < greenHigh | GShift > greenHigh+10/360) = 0;
    GShift(GShift>0) = GShift(GShift>0)-greenHigh;
    pepperSat = pepperSat - GShift.*12.*originalValues.*originalSat;
    pepperValues = pepperValues - GShift.*8.*originalValues.*originalSat;
    pepperValues(pepperValues<0) = 0;
    pepperSat(pepperSat<0) = 0;
    
    % Purple sat shift
    PShift = pepperHue;
    PShift(PShift < redHigh-10/360 | PShift > redHigh) = 0;
    PShift(PShift>0) = .20 - (redHigh - PShift(PShift>0));
    pepperSat = pepperSat - PShift.*4.75.*originalSat.*originalValues;
    pepperValues = pepperValues - PShift.*2.*originalValues.*originalSat;
    pepperSat(pepperSat<0) = 0;
    pepperValues(pepperValues<0) = 0;



    % Hue Shift
    % Major color shift
    pepperHue(pepperHue <= greenHigh) = yellowHue;
    pepperHue(pepperHue >= redHigh) = yellowHue;
    pepperHue(pepperHue > greenHigh & pepperHue < redHigh) = blueHue;
end
%% Method 2
if method == 2
    %------Value Shift------
    % Bright Red to yellow value shift
    underYellowPepper = pepperHue;
    underYellowPepper(underYellowPepper==0) = -1;
    underYellowPepper(underYellowPepper>yellowHue) = 0;
    underYellowPepper(underYellowPepper>0) = yellowHue - underYellowPepper(underYellowPepper>0);
    underYellowPepper(underYellowPepper==-1) = yellowHue;
    pepperValues = pepperValues - underYellowPepper.*3.*originalSat.*originalValues;
    pepperValues(pepperValues<0) = 0;
    
    % Yellow to green value shift
    aboveYellowPepper = pepperHue;
    aboveYellowPepper(aboveYellowPepper<yellowHue | aboveYellowPepper>greenHigh) = 0;
    aboveYellowPepper(aboveYellowPepper>0) = aboveYellowPepper(aboveYellowPepper>0) - yellowHue;
    pepperValues = pepperValues - aboveYellowPepper.*1.5.*originalSat.*originalValues;
    pepperValues(pepperValues<0) = 0;
    
    % Dark Red to purple value
    overRedPepper = pepperHue;
    overRedPepper(overRedPepper<redHigh) = 0;
    overRedPepper(overRedPepper>0) = 1 - overRedPepper(overRedPepper>0);
    overRedExtra = ones(size(pepperValues)) * .4;
    overRedExtra(overRedPepper==0) = 0;
    pepperValues = pepperValues - overRedPepper.*1.8.*originalSat.*originalValues -overRedExtra.*originalSat.*originalValues;
    pepperValues(pepperValues<0) = 0;
    
    %------Yellow Sat Shift------
    % Blue Green sat shift
    BGShift = pepperHue;
    BGShift(BGShift < 130/360 | BGShift > greenHigh) = 0;
    BGShift(BGShift>0) = BGShift(BGShift>0) - 130/360;
    pepperSat = pepperSat - BGShift.*10.*originalSat;
    pepperValues = pepperValues + BGShift.*2.*originalValues;
    pepperSat(pepperSat<0) = 0;
    
    % Red Purple sat Shift
    RPShift = pepperHue;
    RPShift(RPShift < redHigh) = 0;
    RPShift(RPShift>0) = 1 - RPShift(RPShift>0);
    pepperSat = pepperSat - RPShift.*10.*originalSat;
    pepperValues = pepperValues + RPShift.*1.75.*originalValues.*originalSat;
    pepperSat(pepperSat<0) = 0;
    pepperValues(pepperValues>1) = 1;
    
    %------Blue Sat Shift------
    % Blue Purple sat shift
    BPShift = pepperHue;
    BPShift(BPShift < greenHigh+25/360 | BPShift > blueHue) = 0;
    BPShift(BPShift>0) = abs(BPShift(BPShift>0) - blueHue);
    pepperSat = pepperSat - BPShift.*4.5.*originalValues.*originalSat;
    pepperSat(pepperSat<0) = 0;
    
    BPShift = pepperHue;
    BPShift(BPShift < blueHue | BPShift > redHigh-10/360) = 0;
    BPShift(BPShift>0) = abs(BPShift(BPShift>0) - blueHue);
    pepperSat = pepperSat - BPShift.*3.*originalValues.*originalSat;
    pepperSat(pepperSat<0) = 0;
    
    % Green Bright Blue sat shift
    GBBShift = pepperHue;
    GBBShift(GBBShift < greenHigh | GBBShift > greenHigh+25/360) = 0;
    GBBShift(GBBShift>0) = .25 - abs(180/360-GBBShift(GBBShift>0));
    pepperSat = pepperSat - GBBShift.*3.*originalValues.*originalSat;
    pepperSat(pepperSat<0) = 0;
    
    % Green val shift
    GShift = pepperHue;
    GShift(GShift < greenHigh | GShift > greenHigh+10/360) = 0;
    GShift(GShift>0) = GShift(GShift>0)-greenHigh;
    pepperSat = pepperSat - GShift.*12.*originalValues.*originalSat;
    pepperValues = pepperValues - GShift.*8.*originalValues.*originalSat;
    pepperValues(pepperValues<0) = 0;
    pepperSat(pepperSat<0) = 0;
    
    % Purple sat shift
    PShift = pepperHue;
    PShift(PShift < redHigh-10/360 | PShift > redHigh) = 0;
    PShift(PShift>0) = .20 - (redHigh - PShift(PShift>0));
    pepperSat = pepperSat - PShift.*4.75.*originalSat;
    pepperValues = pepperValues - PShift.*2.*originalValues.*originalSat;
    pepperSat(pepperSat<0) = 0;
    pepperValues(pepperValues<0) = 0;

    %------Hue Shift------
    % Major color shift
    pepperHue(pepperHue <= greenHigh) = yellowHue;
    pepperHue(pepperHue >= redHigh) = yellowHue-5/360;
    pepperHue(pepperHue > greenHigh & pepperHue < redHigh) = blueHue;
end
%% Method 3
if method == 3
    satCutOff = originalSat;
    satCutOff(satCutOff>.5) = 1;
    satCutOff(satCutOff<=.5) = satCutOff(satCutOff<=.5).*2;
    %Red orange Sat shift
    ROSShift = pepperHue;
    eqValues = [2397.8442,718.1918,-177.2063,10.1309,0.0029];
    ROSShift(ROSShift >= redHigh) = ROSShift(ROSShift >= redHigh)-1;
    ROSShift(ROSShift > 45/360) = 0;
    RGSShiftArea = ROSShift;
    RGSShiftArea(RGSShiftArea~=0) = 1;
    pepperSat = pepperSat + (eqValues(1).*ROSShift.^4 + eqValues(2).*ROSShift.^3 + eqValues(3).*ROSShift.^2 + eqValues(4).*ROSShift + eqValues(5).*RGSShiftArea).*satCutOff;
    pepperSat(pepperSat>1) = 1;
    pepperSat(pepperSat<0) = 0;

    % Red orange Val shift
    shiftValues = pepperHue;
    eqValues = [1354.0773,139.1387,-32.5140,3.1049,-0.4417];
    shiftValues(shiftValues >= 348/360) = shiftValues(shiftValues >= 348/360)-1;
    shiftValues(shiftValues ==0) = 1/720;
    shiftValues(shiftValues > 45/360) = 0;
    shiftArea = shiftValues;
    shiftArea(shiftArea~=0) = 1;
    pepperValues = pepperValues + (eqValues(1).*shiftValues.^4 + eqValues(2).*shiftValues.^3 + eqValues(3).*shiftValues.^2 + eqValues(4).*shiftValues + eqValues(5).*shiftArea).*satCutOff;
    pepperValues(pepperValues>1) = 1;
    pepperValues(pepperValues<0) = 0;

    % Red transition Val shift part one
    shiftValues = pepperHue;
    shiftValues(shiftValues >= 348/360 | shiftValues <= 346/360) = 0;
    shiftValues(shiftValues~=0) = shiftValues(shiftValues~=0)-1;
    shiftArea = shiftValues;
    shiftArea(shiftArea~=0) = 1;
    shiftFirstAmount = (eqValues(1).*shiftValues.^4 + eqValues(2).*shiftValues.^3 + eqValues(3).*shiftValues.^2 + eqValues(4).*shiftValues + eqValues(5).*shiftArea).*satCutOff;

    % Red purple Val shift
    shiftValues = pepperHue;
    eqValues = [2930.919,1541.738,337.554,24.995,0.000];
    shiftValues(shiftValues >= redHigh & shiftValues <= 346/360) = shiftValues(shiftValues >= redHigh & shiftValues <= 346/360)-1;
    shiftValues(shiftValues>0) = 0;
    shiftArea = shiftValues;
    shiftArea(shiftArea~=0) = 1;
    pepperValues = pepperValues + (eqValues(1).*shiftValues.^4 + eqValues(2).*shiftValues.^3 + eqValues(3).*shiftValues.^2 + eqValues(4).*shiftValues + eqValues(5).*shiftArea).*satCutOff;
    pepperValues(pepperValues>1) = 1;
    pepperValues(pepperValues<0) = 0;

    % Red transition Val shift part two
    shiftValues = pepperHue;
    shiftValues(shiftValues >= 348/360 | shiftValues <= 346/360) = 0;
    shiftValues(shiftValues~=0) = shiftValues(shiftValues~=0)-1;
    shiftArea = shiftValues;
    shiftArea(shiftArea~=0) = 1;
    shiftSecondAmount = (eqValues(1).*shiftValues.^4 + eqValues(2).*shiftValues.^3 + eqValues(3).*shiftValues.^2 + eqValues(4).*shiftValues + eqValues(5).*shiftArea).*satCutOff;
    
    % Adding red Val transition
    shiftValues = pepperHue;
    shiftValues(shiftValues >= 348/360 | shiftValues <= 346/360) = 0;
    shiftValues(shiftValues~=0) = (shiftValues(shiftValues~=0) - 346/360).*(360/2);
    pepperValues = pepperValues+shiftFirstAmount.*shiftValues;
    shiftValues(shiftValues~=0) = abs(shiftValues(shiftValues~=0)-1);
    pepperValues = pepperValues+shiftSecondAmount.*shiftValues;
    pepperValues(pepperValues>1) = 1;
    pepperValues(pepperValues<0) = 0;

    
    
    % Yellow green Sat shift
    YGSShift = pepperHue;
    eqValues = [-11.2504,13.0523,-3.4541,0.2652];
    YGSShift(YGSShift < 45/360 | YGSShift > greenHigh) = 0;
    YGSArea = YGSShift;
    YGSArea(YGSArea~=0) = 1;
    pepperSat = pepperSat + (eqValues(1).*YGSShift.^3 + eqValues(2).*YGSShift.^2 + eqValues(3).*YGSShift + eqValues(4).*YGSArea).*satCutOff;
    pepperSat(pepperSat>1) = 1;
    pepperSat(pepperSat<0) = 0;

    %------Hue Shift------
    % Major color shift
    pepperHue(pepperHue <= greenHigh) = yellowHue;
    pepperHue(pepperHue >= redHigh) = yellowHue;

    % RGHShift = pepperHue;
    % RGHShift(RGHShift>=redHigh) = 1-RGHShift(RGHShift >= redHigh);
    %eqValues = [-29.1968,17.5030,-3.0967,0.1798,0.1443];
    %pepperHue(originalHue <= greenHigh) = eqValues(1).*RGHShift(originalHue <= greenHigh).^4 + eqValues(2).*RGHShift(originalHue <= greenHigh).^3 + eqValues(3).*RGHShift(originalHue <= greenHigh).^2 + eqValues(4).*RGHShift(originalHue <= greenHigh) + eqValues(5);
    %pepperHue(originalHue >= redHigh) = eqValues(1).*RGHShift(originalHue >= redHigh).^4 + eqValues(2).*RGHShift(originalHue >= redHigh).^3 + eqValues(3).*RGHShift(originalHue >= redHigh).^2 + eqValues(4).*RGHShift(originalHue >= redHigh) + eqValues(5);

    
    pepperSat(pepperHue > greenHigh & pepperHue < redHigh) = 0;
    
end




%% displaying filter results
% Setting values
HSVpepper(:,:,1) = pepperHue;
HSVpepper(:,:,2) = pepperSat;
HSVpepper(:,:,3) = pepperValues;
repepper = hsv2rgb(HSVpepper);
figure
imshow(RGBpepper)
figure
imshow(repepper)

%% Original Image grouping
% Hue Grouping
numberOfHueOriginalGroups = 20;
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
numberOfSatOriginalGroups = 7;
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
numberOfValOriginalGroups = 7;
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
numberOfHueFilterGroups = 3;
hueGrouping = linspace(0,1,(numberOfHueFilterGroups+1));
hueSectionsFiltered = zeros(size(pepperHue,1),size(pepperHue,2));
for i = 1:numberOfHueFilterGroups-1
    hueSection = zeros(size(pepperHue,1),size(pepperHue,2));
    hueSection(pepperHue >= hueGrouping(i) & pepperHue < hueGrouping(i+1)) = 1;
    hueSectionsFiltered = hueSectionsFiltered + hueSection*i;
end
hueSection = zeros(size(pepperHue,1),size(pepperHue,2));
hueSection(pepperHue >= hueGrouping(end-1)) = 1;
hueSectionsFiltered = hueSectionsFiltered + hueSection*numberOfHueFilterGroups;

% Sat grouping
numberOfSatFilterGroups = 3;
satGrouping = linspace(0,1,(numberOfSatFilterGroups+1));
satSectionsFiltered = zeros(size(pepperSat,1),size(pepperSat,2));
for i = 1:numberOfSatFilterGroups-1
    satSection = zeros(size(pepperSat,1),size(pepperSat,2));
    satSection(pepperSat >= satGrouping(i) & pepperSat < satGrouping(i+1)) = 1;
    satSectionsFiltered = satSectionsFiltered + satSection*i;
end
satSection = zeros(size(pepperSat,1),size(pepperSat,2));
satSection(pepperSat >= satGrouping(end-1)) = 1;
satSectionsFiltered = satSectionsFiltered + satSection*numberOfSatFilterGroups;


% Val grouping
numberOfValFiltergroups = 3;
valGrouping = linspace(0,1,(numberOfValFiltergroups+1));
valSectionsFiltered = zeros(size(pepperValues,1),size(pepperValues,2));
for i = 1:numberOfValFiltergroups-1
    valSection = zeros(size(pepperValues,1),size(pepperValues,2));
    valSection(pepperValues >= valGrouping(i) & pepperValues < valGrouping(i+1)) = 1;
    valSectionsFiltered = valSectionsFiltered+valSection*i;
end
valSection = zeros(size(pepperValues,1),size(pepperValues,2));
valSection(pepperValues >= valGrouping(end-1)) = 1;
valSectionsFiltered = valSectionsFiltered+valSection*numberOfValFiltergroups;


%% Combined Original Grouping
numberOfCombinedOriginalGroups = numberOfHueOriginalGroups * numberOfSatOriginalGroups * numberOfValOriginalGroups;
groupIDsOriginal = zeros(1,numberOfCombinedOriginalGroups);
groupPixelsOriginal = zeros(1,size(pepperValues,1)*size(pepperValues,2));
groupMatrixesOriginal = zeros(size(pepperValues,1),size(pepperValues,2));
groupIndex = 1;
tic
for h = 1:numberOfHueOriginalGroups
    if any(any(hueSectionsOriginal==h))
        for s = 1:numberOfSatOriginalGroups
            if any(any(hueSectionsOriginal==h & satSectionsOriginal==s))
                for v = 1:numberOfValOriginalGroups
                    if any(any(hueSectionsOriginal==h & satSectionsOriginal==s & valSectionsOriginal==v))
                        groupMatrix = (hueSectionsOriginal==h & satSectionsOriginal==s & valSectionsOriginal==v); 
                        groupID = 1000000000+h*1000000+s*1000+v;
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

figure
imagesc(originalNumberMatrix)
colormap("hsv")
%% Test Display of grouping
% for j = 1:numberOfValFiltergroups
%     valGroupImage = repepper;
%     for i = 1:3
%         valSlice = repepper(:,:,i);
%         valSlice(~valSectionsFiltered(:,:,j)) = 0;
%         valGroupImage(:,:,i) = valSlice;
%     end
%     figure
%     imshow(valGroupImage)
% end

%% Test Display of all groupings
% plotCol = 5;
% plotRows = ceil((numberOfCombinedOriginalGroups/numberOfHueOriginalGroups)/plotCol);
%         groupImage = RGBpepper;
%         for i = 1:numberOfCombinedOriginalGroups
%             if groupPixelsOriginal(i) ==0
%                 disp(groupIDsOriginal(i)+" is blank")
%             else
%                 for rgb = 1:3
%                     groupSlice = RGBpepper(:,:,rgb);
%                     groupSlice(~groupMatrixesOriginal(:,:,i)) = 0;
%                     groupImage(:,:,rgb) = groupSlice;
%                 end
%                 figure
%                 imshow(groupImage)
%             end
%         end

   
