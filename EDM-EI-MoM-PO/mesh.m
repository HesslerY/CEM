%��ȡFEKO�������ʷ��ļ�*.nas����
%���룺*.nas����GRID*��ͷ���ݡ���GRID.txt��*.nas����CTRIA3��ͷ���ݡ���CTRIA.txt
%����������ζ����������ݡ���NODE.txt��������Ƭ��Ӧ���������ݡ���FACE.txt
%By klingy@ahu.edu.cn

%��ȡFEKO�ʷ�������Ƭ�����������ݣ���ʽ��node x y z
fid = fopen('GRID.txt','r');
a = fscanf(fid, '%s %d %E %E %d %c %d %E', [12 inf]);
fclose(fid);
b = a([6,7,8,12],:);
fid = fopen('NODE.txt','wt');
count = fprintf(fid,'%8d % 1.9E % 1.9E % 1.9E\n',b);
fclose(fid);
%��ȡFEKO�ʷ�������Ƭ��Ӧ�������ݣ���ʽ��face node1 node2 node3
fid = fopen('CTRIA.txt','r');
a = fscanf(fid, '%s %d %d %d %d %d', [11 inf]);
fclose(fid);
b = a([7,9,10,11],:);
fid = fopen('FACE.txt','wt');
count = fprintf(fid,'%8d %8d %8d %8d\n',b);
fclose(fid);
