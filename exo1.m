
Element = ["bottle","grid","leather"];
for type = Element
%type = "bottle";
    d = dir("C:\Users\Caroline\mvtec_anomaly_detection\00_data\" + type + "\train\good");
    Nbr = length(d([d.isdir]==0));
    for i=0:Nbr -1
        Nom = "B" + i;
        if (i < 10)
            i = "00" + i;
        elseif (i <100)
            i = "0" + i;
        end
        B = "C:\Users\Caroline\mvtec_anomaly_detection\00_data\" + type + "\train\good\"  + i + ".png";
        Nom = imread (B);
    end
end
imshow (Nom);



