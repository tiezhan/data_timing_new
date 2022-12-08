classdef Stat <handle
    % [h, p] = Stat.__static_func__(...)
    % ����ͳ��������������, �г���������: Stat.help();
    % -----------�������---------
    % mu     : ��, �����ֵ.   scalar num.
    % sigma  : ��, �����׼��. scalar num.
    % mean1  : ����1 �ľ�ֵ.   scalar num. @(data_v)mean(data_v)
    % std1   ������1 �ı�׼��. scalar num. @(data_v)std(data_v)
    % v1     : ����1 �����ɶ�. scalar num. @(data_v)length(data_v)-1
    % alpha  ��Ҫ����������̶�, ȡֵ [0~1] (Ĭ��=0.05).
    % tail   : Ҫ�����β, ȡֵ ['both'(Ĭ��) | 'left' | 'right' | 'one']
    %
    % -----------�������---------
    % h      ���������, ȡֵ [0(������) | 1(����)], �ܵ�alpha��tailӰ��
    % p      : p-value, ȡֵ [0~1], �ܵ�tailӰ�죬���ܵ�alphaӰ�졣
    
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
            % �Ƚ�������ֵmean1 �� �����ֵmu ֮��Ĳ��졣 �ҡ���
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
            % �Ƚ�������ֵmean1 �� ��������ֵmean2 ֮��Ĳ��졣 ��1��2 ����
            narginchk(6, 8);
            if ~exist('alpha', 'var');alpha =Stat.alpha; end
            if ~exist('tail', 'var');tail =Stat.tail; end
			%% �������
			n1 = v1+1; n2 = v2+1;
			h = Stat.vartest2(std1, std2, v1, v2);
			%% ͬ/�� ����
			if h==1
				disp('������������ͬ�����ͬ����˫����t����!');
				v_t = v1+v2;
				varia = (v1*std1^2 + v2*std2^2)/(v1+v2)*(1/n1+1/n2);
			else
				disp('�������������췽����췽��˫����t����!');
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
            % �Ƚ�������ֵmean1 �� �����ֵmu ֮��Ĳ��졣 �ҡ� ��
            narginchk(3, 5);
            if ~exist('alpha', 'var');alpha =Stat.alpha; end
            if ~exist('tail', 'var');tail =Stat.tail; end
            xscore = (mean1 - mu)/sigma;
            ycdf = normcdf(xscore);
            [h, p] = tail_hp(ycdf, alpha, tail);
        end
		function [h, p] = ztest2(mean1, mean2, sigma1, sigma2, v1, v2, alpha, tail)
            % [h, p] = Stat.ztest2(mean1, mean2, sigma1, sigma2, v1, v2, alpha, tail)
            % �Ƚ�������ֵmean1 �� ��������ֵmean2 ֮��Ĳ��졣 ��1��2 �̡�
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
            % �Ƚ���������std1 �� ���뷽��sigma ֮��Ĳ��졣
            narginchk(3, 5);
            if ~exist('alpha', 'var');alpha =Stat.alpha; end
            if ~exist('tail', 'var');tail =Stat.tail; end
			xscore = v1 * (std1 / sigma)^2;
            ycdf = chi2cdf(xscore, v1);
            [h, p] = tail_hp(ycdf, alpha, tail);
        end
        function [h, p] = vartest2(std1, std2, v1, v2,alpha, tail)
            % [h, p] = Stat.vartest2(std1, std2, v1, v2,alpha, tail)
            % �Ƚ���������std1 �� ����������std2 ֮��Ĳ��졣
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
