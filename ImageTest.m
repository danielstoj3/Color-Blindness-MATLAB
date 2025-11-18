RGBpepper = imread("VisionSamples.jpeg");
HSVpepper = rgb2hsv(RGBpepper);
untouchedHSV = HSVpepper;
pepperHue = HSVpepper(:,:,1);
pepperSat = HSVpepper(:,:,2);
pepperValues = HSVpepper(:,:,3);
originalHue = pepperHue;
originalValues = pepperValues;
originalSat = pepperSat;
method = 3;
redHigh = 330/360;
if method == 1 || method == 3
    yellowHue = 52/360; %52 or 60
    blueHue = 220/360; %220 or 240
elseif method == 2
    yellowHue = 60/360; %52 or 60
    blueHue = 240/360; %220 or 240
end
greenHigh = 160/360;

if method == 1
    %% Main Value shift
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
    pepperSat = pepperSat - PShift.*4.75.*originalSat;
    pepperValues = pepperValues - PShift.*2.*originalValues.*originalSat;
    pepperSat(pepperSat<0) = 0;
    pepperValues(pepperValues<0) = 0;



    %% Hue Shift
    % Major color shift
    pepperHue(pepperHue <= greenHigh) = yellowHue;
    pepperHue(pepperHue >= redHigh) = yellowHue;
    pepperHue(pepperHue > greenHigh & pepperHue < redHigh) = blueHue;
end

if method == 2
    %% Main Value shift
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
    %% Yellow Sat Shift
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
    
    %% Blue Sat Shift
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

    %% Hue Shift
    % Major color shift
    pepperHue(pepperHue <= greenHigh) = yellowHue;
    pepperHue(pepperHue >= redHigh) = yellowHue-5/360;
    pepperHue(pepperHue > greenHigh & pepperHue < redHigh) = blueHue;
end

if method == 3
    % Red orange Sat shift
    ROSShift = pepperHue;
    eqValues = [2397.8442,718.1918,-177.2063,10.1309,0.0029];
    ROSShift(ROSShift > redHigh) = ROSShift(ROSShift > redHigh)-1;
    ROSShift(ROSShift > 45/360) = 0;
    RGSShiftArea = ROSShift;
    RGSShiftArea(RGSShiftArea~=0) = 1;
    pepperSat = pepperSat + eqValues(1).*ROSShift.^4 + eqValues(2).*ROSShift.^3 + eqValues(3).*ROSShift.^2 + eqValues(4).*ROSShift + eqValues(5).*RGSShiftArea;
    pepperSat(pepperSat>1) = 1;
    pepperSat(pepperSat<0) = 0;

    % Red orange Val shift
    ROVShift = pepperHue;
    eqValues = [1354.0773,139.1387,-32.5140,3.1049,-0.4417];
    ROVShift(ROVShift > redHigh) = ROVShift(ROVShift > redHigh)-1;
    ROVShift(ROVShift > 45/360) = 0;
    ROVShiftArea = ROVShift;
    ROVShiftArea(ROVShiftArea~=0) = 1;
    pepperValues = pepperValues + eqValues(1).*ROVShift.^4 + eqValues(2).*ROVShift.^3 + eqValues(3).*ROVShift.^2 + eqValues(4).*ROVShift + eqValues(5).*ROVShiftArea;
    pepperValues(pepperValues>1) = 1;
    pepperValues(pepperValues<0) = 0;

    %% Hue Shift
    % Major color shift
    RGHShift = pepperHue;
    RGHShift(RGHShift>=redHigh) = 1-RGHShift(RGHShift >= redHigh);
    pepperHue(pepperHue <= yellowHue) = 21.599.*RGHShift(pepperHue <= greenHigh).^3 - 3.8379.*RGHShift(pepperHue <= greenHigh).^2 + 0.1602.*RGHShift(pepperHue <= greenHigh) + 0.146;
    pepperHue(pepperHue >= redHigh) = 21.599.*RGHShift(pepperHue >= redHigh).^3 - 3.8379.*RGHShift(pepperHue >= redHigh).^2 + 0.1602.*RGHShift(pepperHue >= redHigh) + 0.146;
    pepperHue(pepperHue > yellowHue & pepperHue <= greenHigh) = .1151.*pepperHue(pepperHue > yellowHue & pepperHue <= greenHigh).^.213;
    pepperSat(pepperHue > greenHigh & pepperHue < redHigh) = 0;
    
end





% Setting values
HSVpepper(:,:,1) = pepperHue;
HSVpepper(:,:,2) = pepperSat;
HSVpepper(:,:,3) = pepperValues;
repepper = hsv2rgb(HSVpepper);
figure
imshow(RGBpepper)
figure
imshow(repepper)