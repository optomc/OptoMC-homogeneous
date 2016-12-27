%% NOTE: "CALCULATE STEP SIZE"
function s = stepSize(MC)
% sample a new step size for photons
mus=MC.mus;
if (mus ~= 0)    
    s=-log(rand)/mus;
else
    s=10;
end

