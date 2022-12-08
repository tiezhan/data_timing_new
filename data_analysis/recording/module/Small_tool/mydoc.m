function mydoc(topic)
%����topic������Ҫ��·����
% function mydoc(topic)
% 
    % Make sure that we can support the doc command on this platform.
    if ~usejava('mwt')
        error(message('MATLAB:doc:UnsupportedPlatform', upper(mfilename)));
    end
    
    %% ���ȼ�0, �� <�������> �Ի�����
    if nargin ==0; 
        com.mathworks.mlservices.MLHelpServices.invokeClassicHelpBrowser();
        return;
    end
    
    %% ���ȼ�1, demo
    if showDemo(topic)
        return;
    end
    
    %% ���ȼ�2�� ���ú��� �� doc('plot')
    if com.mathworks.mlservices.MLHelpServices.showReferencePage(topic, 0)
        return;
    end
    
    %% ���ȼ�3�� ���ò�Ʒҳ �� doc('MATLAB')
    if com.mathworks.mlservices.MLHelpServices.showProductPage(topic)
        return;
    end
    
    %% ���ȼ�4�� ��m�ļ���ע�� ȫ����ȡ��web��
    if helpwin(topic, '', '', '-doc')
        return;
    end
    
    %% ���ȼ�5�� ��doc��������������
    docsearch(topic)
end

function success = showDemo(fname)
    success = true;
    try
        showdemo(fname)
    catch
        success = false;
    end
end
%docsearch(topic)  ��doc��������������
%com.mathworks.mlservices.MLHelpServices.invokeClassicHelpBrowser() %�Զ���doc��ҳ
%com.mathworks.mlservices.MLHelpServices.invoke(); %doc����ҳ
%success = helpwin(topic, '', '', '-doc'); %��m�ļ���ע�� ȫ����ȡ��web��
%success = com.mathworks.mlservices.MLHelpServices.showProductPage(topic) %��ҳ����Ʒҳ
%success = com.mathworks.mlservices.MLHelpServices.showReferencePage(topic, 0); %doc('plot')���ú���