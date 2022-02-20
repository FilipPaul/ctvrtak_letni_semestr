function [last_iteration,vectors,angles] = CORDIC_fun(input_vector,angle,MAX_ERROR,MAX_iterations,print_flag)
    n_iterations = MAX_iterations;
    angle_rad = angle*pi/180;
    MAX_ERROR_RAD = MAX_ERROR*pi/180;
    %alocate memmory
    output_vectors = zeros(n_iterations,2);
    output_angles = zeros(1,n_iterations);
    scale_factor_K = zeros(1,n_iterations);
    table_of_iters = zeros(1,n_iterations);
    ERROR = zeros(1,n_iterations);
    format_str = "Iterace: %d -> add_angle: (%d)*%0.4f° ; out_angle: %0.4f°;"+...
    "ERROR: %0.4f° ; vector:[%0.4f,%0.4f]";
    for i = 1:1:n_iterations
        if i == 1
            table_of_iters(i) = 0;
            scale_factor_K(i) = 1;
            l_init = sqrt(input_vector(1)^2 + input_vector(2)^2);
            output_angles(i) = acos(input_vector(1)/l_init);
            output_vectors(i,:) = input_vector;
            if angle_rad == 0 %For translation mode
                ERROR(i) = output_angles(i);
                if abs(ERROR(i)) > 45*pi/180 %ALL quadrants
                    output_angles(i) = output_angles(i) + sign(ERROR(i))*45*pi/180;
                    ERROR(i) = output_angles(i);
                    output_vectors(i,:) = [cos(output_angles(i)),sin(output_angles(i))];
                end
            else %Rotation MOde
                ERROR(i) = -angle_rad;
                while abs(ERROR(i)) > 45*pi/180 %ALL quadrants
                    disp(sign(ERROR(i)) + "45°")
                    output_angles(i) = output_angles(i) - sign(ERROR(i))*45*pi/180;
                    (angle_rad - sign(ERROR(i))*45*pi/180)*180/pi
                    angle_rad = (angle_rad + sign(ERROR(i))*45*pi/180);
                    ERROR(i) = - angle_rad ;
                    output_vectors(i,:) = [cos(output_angles(i)),sin(output_angles(i))];
                    l = sqrt(output_vectors(i,1)^2 + output_vectors(i,2)^2);
                    output_vectors(i,:) = output_vectors(i,:)/l *l_init;
                    
                end
            end
            txt = sprintf(format_str,i-1, sign(ERROR(i)*(-1)),...
            table_of_iters(i),output_angles(i)*180/pi,...
            ERROR(i)*180/pi,output_vectors(i,1), output_vectors(i,2));
            if print_flag == 1
                disp(txt)
            end

        else
            table_of_iters(i) = atan(2^(-i+1));
            if (ERROR(i-1) < 0)
               output_angles(i) = output_angles(i-1) + table_of_iters(i);
            elseif (ERROR(i-1) > 0)
               output_angles(i) = output_angles(i-1) - table_of_iters(i);
            end
            output_vectors(i,:) = [cos(output_angles(i)),sin(output_angles(i))];
            l = sqrt(output_vectors(i,1)^2 + output_vectors(i,2)^2);
            scale_factor_K(i) = l_init/l;
            output_vectors(i,:) = output_vectors(i,:)/l *l_init;
            
            if angle_rad == 0 %For translation mode
                ERROR(i) = output_angles(i);
            else %rotation mode
               ERROR(i) = output_angles(i) - (angle_rad+output_angles(1));
            end

            txt = sprintf(format_str,i-1,sign(ERROR(i))*(-1),...
            table_of_iters(i)*180/pi,output_angles(i)*180/pi,...
            ERROR(i)*180/pi, output_vectors(i,1), output_vectors(i,2));
            if print_flag == 1
                disp(txt)
            end

            if (abs(ERROR(i)) < MAX_ERROR_RAD) || (i == n_iterations) 
                last_iteration = i-1;
                last_Error = ERROR(i);
                angles = output_angles;
                vectors = output_vectors;
                
                break
            end
        end

    end
end