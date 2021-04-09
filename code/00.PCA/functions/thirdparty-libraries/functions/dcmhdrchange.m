function dcmhdrchange(dcmpath,new__dcmpath,new__dcmname)
%DCMHDRCHANGE This function modifies specific fields of the hdr file of a
%dicom image

    files = dir(strcat(dcmpath,'/*.dcm'));
    for n = 1:size(files,1)
        pathtemp = files(n).name;
        info__temp = dicominfo(strcat(dcmpath,'/',pathtemp));
        dcm__temp = dicomread(strcat(dcmpath,'/',pathtemp));
        
        % Anonimize
        info__temp.PatientID = '1234567';
        info__temp.PatientName.FamilyName = 'Rossi';
        info__temp.PatientName.GivenName = 'Mario';
        info__temp.PatientBirthDate = '19551105';
        info__temp.PatientSex = 'M';
        info__temp.PatientAge = '064Y';
        info__temp.InstitutionName = 'MedicalImaging&BigData';
        
        % Save slice
        if n < 10
            dicomwrite(dcm__temp, strcat(new__dcmpath,'/',new__dcmname,'-00',num2str(n),'.dcm'), info__temp, 'CreateMode', 'copy');
        elseif n > 9 && n < 100
            dicomwrite(dcm__temp, strcat(new__dcmpath,'/',new__dcmname,'-0',num2str(n),'.dcm'), info__temp, 'CreateMode', 'copy');
        elseif n > 99 && n < 1000
            dicomwrite(dcm__temp, strcat(new__dcmpath,'/',new__dcmname,'-',num2str(n),'.dcm'), info__temp, 'CreateMode', 'copy');
        end
    end
    
end

