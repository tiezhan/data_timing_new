classdef Stat <handle
    % [h, p] = Stat.__static_func__(...)
    % 利用统计量做显著检验, 列出各个函数: Stat.help();
    % -----------输入参数---------
    % mu     : μ, 总体均值.   scalar num.
    % sigma  : σ, 总体标准差. scalar num.
    % mean1  : 样本1 的均值.   scalar num. @(data_v)mean(data_v)
    % std1   ：样本1 的标准差. scalar num. @(data_v)std(data_v)
    % v1     : 样本1 的自由度. scalar num. @(data_v)length(data_v)-1
    % alpha  ：要检验的显著程度, 取值 [0~1] (默认=0.05).
    % tail   : 要检验的尾, 取值 ['both'(默认) | 'left' | 'right' | 'one']
    %
    % -----------输出参数---------
    % h      ：显著结果, 取值 [0(不显著) | 1(显著)], 受到alpha和tail影响
    % p      : p-value, 取值 [0~1], 受到tail影响，不受到alpha影响。
    
    properties(Constant)
        alpha = 0.05;
        tail = 'both' % 'both' | 'left' | 'right' | 'one'
    end
    methods(Static)
        function help()
            mc = metaclass(Stat);
            mc_m = mc.MethodList;
            mc_m_name = {mc_m.Name};
            mc_m_ind = [mc_m.Static];
            names = mc_m_name(mc_m_ind);
            exceptNames = {'empty', 'help'};
            names = setdiff(names, exceptNames);
            for i=1:length(names)
                help(['Stat.', names{i}])
            end
        end
        function [h, p] = ttest(mu, mean1, std1, v1, alpha, tail)
            % [h, p] = Stat.ttest(mu, mean1, std1, v1, alpha, tail)
            % 比较样本均值mean1 和 理想均值mu 之间的差异。 σ×。
            narginchk(4, 6);
            if ~exist('alpha', 'var');alpha =Stat.alpha; end
            if ~exist('tail', 'var');tail =Stat.tail; end
            n1 = v1 +1;
            xscore = (mean1 - mu) / std1 * sqrt(n1);
            ycdf = tcdf(xscore, v1);
            [h, p] = tail_hp(ycdf, alpha, tail);
        end
        function [h, p] = ttest2(mean1, mean2, std1, std2, v1, v2, alpha, tail)
            % [h, p] = Stat.ttest2(mean1, mean2, std1, std2, v1, v2, alpha, tail)
            % 比较样本均值mean1 和 另样本均值mean2 之间的差异。 σ1、2 ×。
            narginchk(6, 8);
            if ~exist('alpha', 'var');alpha =Stat.alpha; end
            if ~exist('tail', 'var');tail =Stat.tail; end
			%% 方差检验
			n1 = v1+1; n2 = v2+1;
			h = Stat.vartest2(std1, std2, v1, v2);
			%% 同/异 方差
			if h==1
				disp('两个样本符合同方差，做同方差双样本t检验!');
				v_t = v1+v2;
				varia = (v1*std1^2 + v2*std2^2)/(v1+v2)*(1/n1+1/n2);
			else
				disp('两个样本符合异方差，做异方差双样本t检验!');
				a1 = std1^2/n1; a2 = std2^2/n2;
				v_t = (a1 + a2)^2 / (a1^2/v1 + a2^2/v2);
				varia = a1 + a2;
			end
            xscore = (mean2 - mean1)/sqrt(varia);
            ycdf = tcdf(xscore, v_t);
            [h, p] = tail_hp(ycdf, alpha, tail);
        end
        function [h, p] = ztest(mu, mean1, sigma, alpha, tail)
            % [h, p] = Stat.ztest(mu, mean1, sigma, alpha, tail)
            % 比较样本均值mean1 和 理想均值mu 之间的差异。 σ√ 。
            narginchk(3, 5);
            if ~exist('alpha', 'var');alpha =Stat.alpha; end
            if ~exist('tail', 'var');tail =Stat.tail; end
            xscore = (mean1 - mu)/sigma;
            ycdf = normcdf(xscore);
            [h, p] = tail_hp(ycdf, alpha, tail);
        end
		function [h, p] = ztest2(mean1, mean2, sigma1, sigma2, v1, v2, alpha, tail)
            % [h, p] = Stat.ztest2(mean1, mean2, sigma1, sigma2, v1, v2, alpha, tail)
            % 比较样本均值mean1 和 另样本均值mean2 之间的差异。 σ1、2 √。
            narginchk(6, 8);
            if ~exist('alpha', 'var');alpha =Stat.alpha; end
            if ~exist('tail', 'var');tail =Stat.tail; end
			n1 = v1+1; n2 = v2+1;
            xscore = (mean1 - mean2)/ sqrt(sigma1^2/n1 + sigma2^2/n2);
            ycdf = normcdf(xscore);
            [h, p] = tail_hp(ycdf, alpha, tail);
        end
        function [h, p] = vartest(sigma, std1, v1, alpha, tail)
            % [h, p] = Stat.vartest(sigma, std1, v1, alpha, tail)
            % 比较样本方差std1 和 理想方差sigma 之间的差异。
            narginchk(3, 5);
            if ~exist('alpha', 'var');alpha =Stat.alpha; end
            if ~exist('tail', 'var');tail =Stat.tail; end
			xscore = v1 * (std1 / sigma)^2;
            ycdf = chi2cdf(xscore, v1);
            [h, p] = tail_hp(ycdf, alpha, tail);
        end
        function [h, p] = vartest2(std1, std2, v1, v2,alpha, tail)
            % [h, p] = Stat.vartest2(std1, std2, v1, v2,alpha, tail)
            % 比较样本方差std1 和 另样本方差std2 之间的差异。
            narginchk(3, 5);
            if ~exist('alpha', 'var');alpha = Stat.alpha; end
            if ~exist('tail', 'var');tail =Stat.tail; end
			xscore = std1^2 / std2^2;
			ycdf   = fcdf(xscore, v1, v2);
			[h, p] = tail_hp(ycdf, alpha, tail);
        end
    end
end

function [h, p] = tail_hp(cdf, alpha, tail)
    switch tail
        case 'both'
			p = 1-2*abs(cdf-0.5);
        case 'one'
			p = 0.5 - abs(cdf-0.5);
		case 'left'
			p = cdf;
		case 'right'
			p = 1-cdf;
        otherwise
            error('tail should be ''one'' or ''two''!')
    end
    h = p<alpha;
end
