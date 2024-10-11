classdef autocontrast_utils
    methods (Static)
        function norm = autocontrast(image)
            image = double(image); 
            num = image - min(image(:)); %subtrai pelo mínimo para o menor pixel ser igual a zero
            den = abs(max(image(:))-min(image(:))); %divide pela diferença de maneira que o máximo seja igual a 1
            norm = num./den; %aplica o autocontraste I' = [I-min(I)]/[abs(max(I)-min(I))]
        end
    end
end