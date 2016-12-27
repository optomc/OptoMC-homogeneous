%% NOTE: "RAY-PLANE INTERSECTION TEST"
function t = rayPlaneIntersects(plane, position, direction)
    % This function performs ran/plane intersection test on the boundary
    dotProduct = dot(direction, plane.normal);
    
    if ((dotProduct < 1E-8) && (dotProduct > -1E-8))
        t = 0;
        return;    
    end
    t = dot(plane.normal, (plane.pos - position)) / dotProduct;  
    if (t < -1E-8)
        t = 0;
        return;
    end
end