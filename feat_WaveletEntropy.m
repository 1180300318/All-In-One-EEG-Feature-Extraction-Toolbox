%% �����ԣ�����ѧ������������ʱƵ���� | nonlinear features: time-frequency-based entropy
%% С���� | Wavelet Entropy (WE) (P226)
% 1.����ÿһ���źų߶ȵ�С������
% 2.����С�������������������Ի�ø��߶�j�����С������
% 3.WE����ͬ�߶ȼ�ֲ�����
% ���Ե��źű��ֳ���ǿ�Ĺ�����ʱ������Ԫ�����ͬ��������С����ֵ������
% WE��ֵȡ����С�����������ֽ����n�����ݳ���N
% ���У�С����������С����������Ϊ��Ҫ������ȱ���̶���׼��ʵ��Ӧ����ͨ������ֱ��ѡ����ʵ�С����������ͨ�����Ǹ���ʵ������ȷ���ú���
% X: single channel EEG signal (either a row vector or a column vector)
% opts.fs: sampling frequency �źŲ�����
% opts.wavefunc: wavelet basis function, default = 'db4'


%% Reference
%       [1] Bai, Y., Li, X., Liang, Z. (2019). Nonlinear Neural Dynamics. In: Hu, L., Zhang, Z. (eds) EEG Signal Processing and Feature Extraction. Springer, Singapore. https://doi.org/10.1007/978-981-13-9113-2_11


function wentropy = feat_WaveletEntropy(X, opts)
    
    fs = opts.fs;
    if isfield(opts,'wavefunc')	% ָ��
        wavefunc = opts.wavefunc; 
    else	% δָ�� default
        wavefunc = 'db4';
    end
    
    Nlayer=round(log2(fs))-3;   % �ֽ������fs=200ʱNlayer=5
    wentropy=0;
    E=waveletdecom_cwq(X,Nlayer,wavefunc);     % ����Ĭ��ѡ����db4С��������
    P=E/sum(E);
    P = P(find(P~=0));
    for j=1:size(P,2)
        wentropy=wentropy-P(1,j).*log(P(1,j));    %С����Swt=-sum(Pj*logPj)
    end

end

function [ E ] = waveletdecom_cwq( x,n,wpname )
[C,L]=wavedec(x,n,wpname);        %�����ݽ���С�����ֽ�
for k=1:n
      %wpcoef(wpt1,[n,i-1])�����n���i���ڵ��ϵ��
%       disp('ÿ���ڵ������E(i)');
      SRC(k,:)=wrcoef('a',C,L,'db4',k);%�߶�
      SRD(k,:)=wrcoef('d',C,L,'db4',k);%ϸ��ϵ��

  E(1,k)=norm(SRD(k,:))*norm(SRD(k,:));
      %���i���ڵ�ķ���ƽ������ʵҲ����ƽ����
end
E(1,n+1)=norm(SRC(n,:))*norm(SRC(n,:));
%  disp('С�����ֽ�������E_total');
E_total=sum(E);  %��������
y=E_total;
% disp('������ÿ���ڵ�ĸ���P');
% for i=1:n+1
%    p(i)= E(1,i)/E_total    %��ÿ���ڵ�ĸ���
% end

end
