%-------------------------------------------------------------------------
% Matteo Interlenghi (IBFM-CNR)
% matteo.interlenghi@ibfm.cnr.it
%-------------------------------------------------------------------------

function [surface, N] = compute__surface(M, voxel__dimension)

    x__size = size(M,1); % Size in terms of # voxels
    y__size = size(M,2); % Size in terms of # voxels
    z__size = size(M,3); % Size in terms of # voxels
    dx = voxel__dimension(1,1)/10; % Convert from mm to cm
    dy = voxel__dimension(1,2)/10; % Convert from mm to cm
    dz = voxel__dimension(1,3)/10; % Convert from mm to cm
    
    surface = 0;
    N = zeros(x__size,y__size,z__size);
    for k = 1:z__size
        for j = 1:y__size
            if M(1,j,k) > 0
                surface = surface+(dz*dy);
                N(1,j,k) = 1;
            end
            if M(x__size,j,k) > 0
                surface = surface+(dz*dy);
                N(x__size,j,k) = 1;
            end
        end
    end
    
    for k = 1:z__size
        for i = 1:x__size
            if M(i,1,k) > 0
                surface = surface+(dz*dx);
                N(i,1,k) = 1;
            end
            if M(i,y__size,k) > 0
                surface = surface+(dz*dx);
                N(i,y__size,k) = 1;
            end
        end
    end
    
    for j = 1:y__size
        for i = 1:x__size
            if M(i,j,1) > 0
                surface = surface+(dy*dx);
                N(i,j,1) = 1;
            end
            if M(i,j,z__size) > 0
                surface = surface+(dy*dx);
                N(i,j,z__size) = 1;
            end
        end
    end
    
    for i = 1:x__size
        for j = 1:y__size
            for k = 1:z__size
                if k > 1 && M(i,j,k) > 0 && M(i,j,k-1) == 0
                    surface = surface+(dx*dy);
                    N(i,j,k) = 1;
                end
                if k < z__size && M(i,j,k) > 0 && M(i,j,k+1) == 0
                    surface = surface+(dx*dy);
                    N(i,j,k) = 1;
                end
                if i > 1 && M(i,j,k) > 0 && M(i-1,j,k) == 0
                    surface = surface+(dz*dy);
                    N(i,j,k) = 1;
                end
                if i < x__size && M(i,j,k) > 0 && M(i+1,j,k) == 0
                    surface = surface+(dz*dy);
                    N(i,j,k) = 1;
                end
                if j > 1 && M(i,j,k) > 0 && M(i,j-1,k) == 0
                    surface = surface+(dz*dx);
                    N(i,j,k) = 1;
                end
                if j < y__size && M(i,j,k) > 0 && M(i,j+1,k) == 0
                    surface = surface+(dz*dx);
                    N(i,j,k) = 1;
                end
            end
        end
    end
    
end
