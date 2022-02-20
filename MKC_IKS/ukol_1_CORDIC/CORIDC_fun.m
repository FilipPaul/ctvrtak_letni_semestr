function [last_iteration,last_Error,last_vector] = CORDIC_fun(input_vector,angle,MAX_ERROR,print_flag)
    n_iterations = 30;
    angle_rad = angle*pi/180;
    MAX_ERROR_RAD = MAX_ERROR*pi/180;
    %alocate memmory
    output_vectors = zeros(n_iterations,2);
    output_angles = zeros(1,n_iterations);
    scale_factor_K = zeros(1,n_iterations);
    table_of_iters = zeros(1,n_iterations);
    ERROR = zeros(1,n_iterations);
    format_str = "Iterace: %d -> K: %0.4f; add_angle: %0.4f° ; out_angle: %0.4f° ; ERROR: %0.4f° ; vector:[%0.4f,%0.4f]";
    for i = 1:1:n_iterations
        if i == 1
            table_of_iters(i) = 0;
            scale_factor_K(i) = 1;
            output_angles(i) = acos(input_vector(1)/sqrt(input_vector(1)^2 + input_vector(2)^2));
            output_vectors(i,:) = input_vector;
            ERROR(i) = -angle_rad;
            txt = sprintf(format_str,i-1,scale_factor_K(i), table_of_iters(i), output_angles(i)*180/pi,...
            ERROR(i)*180/pi,output_vectors(i,1), output_vectors(i,2));
            if print_flag == 1
                disp(txt)
            end

        else
            table_of_iters(i) = atan(2^(-i+1));
            scale_factor_K(i) = cos(atan(2^(-i+1)));

            if (ERROR(i-1) < 0)
               output_angles(i) = output_angles(i-1) + table_of_iters(i);
            elseif (ERROR(i-1) > 0)
               output_angles(i) = output_angles(i-1) - table_of_iters(i);
            end
            output_vectors(i,:) = scale_factor_K(i).*[cos(output_angles(i)),sin(output_angles(i))]; 
            ERROR(i) = output_angles(i) - (angle_rad+output_angles(1))  ;

            txt = sprintf(format_str,i-1,scale_factor_K(i), table_of_iters(i)*180/pi, output_angles(i)*180/pi,...
            ERROR(i)*180/pi, output_vectors(i,1), output_vectors(i,2));
            if print_flag == 1
                disp(txt)
            end

            if abs(ERROR(i)) < MAX_ERROR_RAD
                last_iteration = i-1;
                last_Error = ERROR;
                last_vector = output_vectors(i,:);
                
                break
            end
        end

    end
end