%% NOTE: "REFRACT DIRECTION OF RAY"
function [result tir] = refract(surfNormal, I, nRatio)
	result = [0 0 0];
    tir = 0;
    
    cosI = -(dot(surfNormal,I));
	sinT2 = nRatio* nRatio * ( 1 - cosI*cosI );
	if sinT2 > 1
		tir = 1;      
    end
	cosT = sqrt(1-sinT2);
	result = nRatio*I + (nRatio*cosI-cosT)*surfNormal;
    result = result/norm(result);
end