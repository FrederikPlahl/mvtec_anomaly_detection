clc;
clear;

Element = ["bottle","grid","leather"];
for type = Element
    d = dir("/Users/frederikplahl/mvtec_anomaly_detection/00_data/" + type + "/train/good");
    Nbr = length(d([d.isdir]==0));
    for i=0:Nbr-1
        Nom = "B" + i;
        if (i < 10)
            i = "00" + i;
        elseif (i <100)
            i = "0" + i;
        end
        B = "/Users/frederikplahl/mvtec_anomaly_detection/00_data/" + type + "/train/good/"  + i + ".png";
        image = imread(B);
    end
end
imshow(image);


