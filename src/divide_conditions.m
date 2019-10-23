% function data_conditions = parse_conditions(filename, participant_id, VR_data)
%     
%     for data = loaded_data
%         if (data.name{:} == num2str(participant_id))
%             if (data.condition{:} == '1')
%                 data_conditions.C = append(data_conditions.C, data);
%             elseif (data.condition{:} == '2')
%                 data_conditions.CP = append(data_conditions.CP, data);
%             elseif (data.condition{:} == '3')
%                 data_conditions.CPHF = append(data_conditions.CPHF, data);
%             end
%         end
%     end
% end
% 
% 
% function divide_conditions(data_path_list)
% 
%     if (isempty(data_path_list))
%         return 
%     else
%         file_name = data_path_list(1);
%         data_path_list(1) = [];
%         
%         if (isfolder(filename))
%             data_path_list = [dir(file_name), data_path_list];
%             divide_conditions(data_path_list, new)
%         else
%             create_subfolders(path)
%         end
% 
%     end
% end

function divide_conditions(folder_path)
    create_subfolders(folder_path)
    list_files = dir(folder_path);
    
    for i = 1:length(list_files)
        file = list_files(i);
        if (contains(file.name, '.csv'))
            path = fullfile(folder_path, file.name);
            [file_condition, run_id, name] = read_header(path);
            new_filename_cell = strcat(name, '_', run_id, '_', file_condition, '.csv');

            if (file_condition == '1')
                movefile(path, fullfile(folder_path, 'C'));
                movefile(fullfile(folder_path, 'C', file.name), fullfile(folder_path, 'C', new_filename_cell{:}));
            elseif (file_condition == '2')
                movefile(path, fullfile(folder_path, 'CP'));
                movefile(fullfile(folder_path, 'CP', file.name), fullfile(folder_path, 'CP', new_filename_cell{:}));

            else
                movefile(path, fullfile(folder_path, 'CPHF'));
                movefile(fullfile(folder_path, 'CPHF', file.name), fullfile(folder_path, 'CPHF', new_filename_cell{:}));

            end
        end
    end
end


function create_subfolders(data_path)
    if (~exist(strcat(data_path, '/', 'CP'), 'dir'))
                            mkdir(strcat(data_path, '/', 'CP'))
    end

    if (~exist(strcat(data_path, '/', 'C'), 'dir'))
                            mkdir(strcat(data_path, '/', 'C'))
    end


    if (~exist(strcat(data_path, '/', 'CPHF'), 'dir'))
                            mkdir(strcat(data_path, '/', 'CPHF'))
    end             
end


function [condition, run_id, name] = read_header(filepath)
    file = fopen(filepath);
    header = fgetl(file);
    list_fields = split(header, ",");
    condition = extractAfter(list_fields(2), 12);
    name = extractAfter(list_fields(1), 6);
    run_id = extractAfter(list_fields(3), 6);
    condition = condition{:};
end