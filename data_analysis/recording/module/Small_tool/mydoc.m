function mydoc(topic)
%查找topic，（不要用路径）
% function mydoc(topic)
% 
    % Make sure that we can support the doc command on this platform.
    if ~usejava('mwt')
        error(message('MATLAB:doc:UnsupportedPlatform', upper(mfilename)));
    end
    
    %% 优先级0, 打开 <补充软件> 对话窗体
    if nargin ==0; 
        com.mathworks.mlservices.MLHelpServices.invokeClassicHelpBrowser();
        return;
    end
    
    %% 优先级1, demo
    if showDemo(topic)
        return;
    end
    
    %% 优先级2， 内置函数 如 doc('plot')
    if com.mathworks.mlservices.MLHelpServices.showReferencePage(topic, 0)
        return;
    end
    
    %% 优先级3， 内置产品页 如 doc('MATLAB')
    if com.mathworks.mlservices.MLHelpServices.showProductPage(topic)
        return;
    end
    
    %% 优先级4， 把m文件中注释 全部提取到web中
    if helpwin(topic, '', '', '-doc')
        return;
    end
    
    %% 优先级5， 在doc的搜索框中搜索
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
%docsearch(topic)  在doc的搜索框中搜索
%com.mathworks.mlservices.MLHelpServices.invokeClassicHelpBrowser() %自定义doc主页
%com.mathworks.mlservices.MLHelpServices.invoke(); %doc的主页
%success = helpwin(topic, '', '', '-doc'); %把m文件中注释 全部提取到web中
%success = com.mathworks.mlservices.MLHelpServices.showProductPage(topic) %大页，产品页
%success = com.mathworks.mlservices.MLHelpServices.showReferencePage(topic, 0); %doc('plot')内置函数