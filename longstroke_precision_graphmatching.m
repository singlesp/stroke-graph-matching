% load remapping indices (row = subject, columns = original node, element
% in cells = which node the original node was mapped to. starts at 0
% because python indexing starts at 0.

curr_dir=pwd;

results_dir=strcat(curr_dir, '/results/jupyter/precision/stroke/');
info=dir(results_dir);

S1S2_np=load(strcat(results_dir, 'cols_S1S2.txt'));
S2S3_np=load(strcat(results_dir, 'cols_S2S3.txt'));
S3S4_np=load(strcat(results_dir, 'cols_S3S4.txt'));
S4S5_np=load(strcat(results_dir, 'cols_S4S5.txt'));

S2S3_np=[S2S3_np(1:19,:);zeros(1,268); S2S3_np(20:22,:)];
S3S4_np=[S3S4_np(1:11,:);zeros(1,268); S3S4_np(12:18,:);zeros(1,268); S3S4_np(19:21,:)];
S4S5_np=[S4S5_np(1:5,:);zeros(1,268); S4S5_np(6:10,:);zeros(1,268); S4S5_np(11:17,:);zeros(1,268); S4S5_np(18:20,:)];


%% Get remapping matrices (1/0)
order=0:267;

for j=1:23
    for i=1:268
        if (S1S2_np(j,i)==order(i))
            remappings_12(j,i)=0;
        else
            remappings_12(j,i)=1;
        end
         if (S2S3_np(j,i)==order(i))
            remappings_23(j,i)=0;
        else
            remappings_23(j,i)=1;
         end
         if (S3S4_np(j,i)==order(i))
            remappings_34(j,i)=0;
         else
            remappings_34(j,i)=1;
         end
         if (S4S5_np(j,i)==order(i))
            remappings_45(j,i)=0;
        else
            remappings_45(j,i)=1;
        end
    end
end

% display remappings across time for all subjects
figure(2);
tiledlayout(1,4)
nexttile;
imagesc(remappings_12)
title('S1-S2')
ylabel('subject')
xlabel('Node')
set(gca, 'FontSize', 20)

nexttile;
remappings_23(20,:)=0.5;
imagesc(remappings_23)
title('S2-S3')
ylabel('subject')
xlabel('Node')
set(gca, 'FontSize', 20)

nexttile;
remappings_34(12,:)=0.5;
remappings_34(20,:)=0.5;
imagesc(remappings_34)
title('S3-S4')
ylabel('subject')
xlabel('Node')
set(gca, 'FontSize', 20)

nexttile;
remappings_45(6,:)=0.5;
remappings_45(12,:)=0.5;
remappings_45(20,:)=0.5;
imagesc(remappings_45)
title('S4-S5')
ylabel('subject')
xlabel('Node')
colorbar('Ticks', [0 0.5 1], 'TickLabels', {'Same node', 'No data', 'Different node'})
set(gcf,'Position',[0 0 2500 700])
set(gca, 'FontSize', 20)

saveas(gcf, strcat(results_dir, 'figures/remapping_raster_allsubjects_overtime.png'))


%% Correlate remap frequency with chaco scores.
%log(chaco) vs remapping - can you make the points three colors indicating cerebellum
% motor/premotor/somatosensory and other cortex?

S1S2_np=load(strcat(results_dir, 'roichanges_S1S2.txt'));
S2S3_np=load(strcat(results_dir, 'roichanges_S2S3.txt'));
S3S4_np=load(strcat(results_dir, 'roichanges_S3S4.txt'));
S4S5_np=load(strcat(results_dir, 'roichanges_S4S5.txt'));

clear chacovol

for i=1:23
    chacovol{i}=load(strcat(curr_dir,'/chaco/SUB', num2str(i), '_lesion_1mmMNI_shen268_mean_chacovol.csv'));
end

mean_chacovol=mean(cell2mat(chacovol'));

[rho,p]=corr(S1S2_np,mean_chacovol');
rho1=rho;
p1=p;
[rho,p]=corr(S2S3_np,mean_chacovol');
rho2=rho;
p2=p;
[rho,p]=corr(S3S4_np,mean_chacovol');
rho3=rho;
p3=p;
[rho,p]=corr(S4S5_np,mean_chacovol');
rho4=rho;
p4=p;

results.corr_w_chaco.s1s2.p=p1;
results.corr_w_chaco.s1s2.rho=rho1;
results.corr_w_chaco.s2s3.p=p2;
results.corr_w_chaco.s2s3.rho=rho2;
results.corr_w_chaco.s3s4.p=p3;
results.corr_w_chaco.s3s4.rho=rho3;
results.corr_w_chaco.s4s5.p=p4;
results.corr_w_chaco.s4s5.rho=rho4;

figure('Position', [0 0 1000 500]) 

tiledlayout(1,4,'padding', 'none')
nexttile;
plot(S1S2_np,mean_chacovol, 'o')
xlabel('Remap frequency')
ylabel('Mean ChaCo')
title('S1-S2')
ylim([0 0.02])
b=polyfit(S1S2_np, mean_chacovol,1);
a=polyval(b,S1S2_np);
hold on;
plot(S1S2_np, a, '-b')
set(gca, 'FontSize', 13)

nexttile;
plot(S2S3_np,mean_chacovol, 'o')
xlabel('Remap frequency')
ylabel('Mean ChaCo')
title('S2-S3')
ylim([0 0.02])
b=polyfit(S2S3_np, mean_chacovol,1);
a=polyval(b,S2S3_np);
hold on;
plot(S2S3_np, a, '-b')
set(gca, 'FontSize', 13)

nexttile;
plot(S3S4_np,mean_chacovol, 'o')
xlabel('Remap frequency')
ylabel('Mean ChaCo')
title('S3-S4')
ylim([0 0.02])
b=polyfit(S3S4_np, mean_chacovol,1);
a=polyval(b,S3S4_np);
hold on;
plot(S3S4_np, a, '-b')
set(gca, 'FontSize', 13)

nexttile;
plot(S4S5_np,mean_chacovol, 'o')
xlabel('Remap frequency')
ylabel('Mean ChaCo score')
title('S4-S5')
ylim([0 0.02])
b=polyfit(S4S5_np, mean_chacovol,1);
a=polyval(b,S4S5_np);
hold on;
plot(S4S5_np, a, '-b')
set(gca, 'FontSize', 13)

saveas(gcf, strcat(results_dir, 'figures/corr_remapping_chaco.png'))


%%
% Mean ChaCo vs. mean remaps
figure('Position', [0 0 700 700])
all=S4S5_np+S3S4_np+S2S3_np+S1S2_np;
all_remaps=mean([remappings_12;remappings_23;remappings_34;remappings_45]);

[rho1,p1]=corr(all_remaps', mean_chacovol', 'Type', 'Spearman');
[rho2,p2]=corr(all_remaps', mean_chacovol', 'Type', 'Pearson');

results.corr_w_chaco_allsessions.spearman_p=p1;
results.corr_w_chaco_allsessions.spearman_rho=rho1;
results.corr_w_chaco_allsessions.pearson_p=p2;
results.corr_w_chaco_allsessions.pearson_rho=rho2;

plot(all_remaps,mean_chacovol, 'ok')
b=polyfit(all_remaps, mean_chacovol,1);
a=polyval(b,all_remaps);
hold on;
title('Remap frequency, averaged over all sessions vs. mean log(chaco) across subjects')
xlabel('Average remap freq. across time points')
ylabel('Mean log(ChaCo) score across subjects')
set(gca, 'FontSize', 13)
saveas(gcf, strcat(results_dir, 'figures/corr_remapping_chaco_allsessions.png'))

figure('Position', [0 0 700 700])
plot(all_remaps, log(mean_chacovol),'ok');
xlabel('Average remap freq. across time points')
ylabel('Mean log(ChaCo) score across subjects')
set(gca,'FontSize', 13)
saveas(gcf, strcat(results_dir, 'figures/corr_remapping_chaco_allsessions_log.png'))


%% remapping vs motor recovery
data_dir=strcat(pwd, '/data/')
fuglmeyer=readtable(strcat(data_dir, 'fuglmeyer_allpts.csv'))
fm_1=fuglmeyer.Var2;
fm_2=fuglmeyer.Var3;
fm_3=fuglmeyer.Var4;
fm_4=fuglmeyer.Var5;
fm_5=fuglmeyer.Var6;

fm_1(23)=NaN;
fm_1(22)=NaN;
fm_3(20)=NaN;
fm_4(12)=NaN;
fm_4(20)=NaN;
fm_5(20)=NaN;
fm_5(6)=NaN;

chacocol=cell2mat(chacovol');

sum12=sum(remappings_12,2);
sum23=sum(remappings_23,2);
sum34=sum(remappings_34,2);
sum45=sum(remappings_45,2);

sum23(20)=NaN;
sum34(12)=NaN;
sum34(20)=NaN;
sum45(20)=NaN;
sum45(12)=NaN;
sum45(6)=NaN;

sum_all_swaps=[sum12, sum23, sum34, sum45];
totalswap=sum(sum_all_swaps,2);

% baseline impairment vs. sum of swaps 1 to 2.
figure('Position', [0 0 700 700])
plot(sum12(1:21), fm_1(1:21), 'ko')
hold on;
b=polyfit(sum12(1:21), fm_1(1:21),1);
a=polyval(b,sum12(1:21));
plot(sum12(1:21), a, '-r')
[rho,p]=corr(sum12(1:21),fm_1(1:21), 'Type', 'Pearson')
title('Baseline Fugl-Meyer scores vs. Total n remaps S2-S1')
xlabel('Total # swaps')
ylabel('Baseline F-M score')
ylim([0 105])
set(gca, 'FontSize', 13)
results.baselineFM_remaps_s1s2.p=p;
results.baselineFM_remaps_s1s2.rho=rho;

saveas(gcf, strcat(results_dir, 'figures/baselineFM_remaps_s1s2.png'))

% 6 month recovery recovery vs S1-S2 swaps.
figure('Position', [0 0 700 700])
plot(sum12, fm_5-fm_1,'ko')
[rho,p]=corr(sum12,fm_5-fm_1,'rows', 'complete')
hold on;
recovery=fm_5-fm_1;
idx = isnan(recovery);
b=polyfit(sum12(~idx), recovery(~idx),1);
a=polyval(b,sum12);
plot(sum12, a, '-r')
xlabel('Total # swaps S1-S2')
ylabel('Change in Fugl-Meyer (last baseline-followup)')
title('Baseline # swaps vs. 6 month difference in FM')
set(gca, 'FontSize', 13)
results.baselineswaps_6monthFM.p=p;
results.baselineswaps_6monthFM.rho=rho;

saveas(gcf, strcat(results_dir, 'figures/baselineswaps_6monthFM.png'))

%%
% What we want to test is whether the number of swaps from Session k to Session k+1
% is correlated with the change in motor scores.
figure('Position', [0 0 700 700])
imagesc([fm_1,fm_2,fm_3,fm_4,fm_5])
yticks(1:23)
xticks([1 2 3 4 5])
set(gca,'FontSize', 13)
title('FM scores over time')
xlabel('Session')
saveas(gcf, strcat(results_dir, 'figures/FM_overtime.png'))

fm12=(fm_2-fm_1);
fm23=(fm_3-fm_2);
fm34=(fm_4-fm_3);
fm45=(fm_5-fm_4);

% all inter-scan changes in FM and # remaps
allrecover=[fm12;fm23;fm34;fm45];
allsum=[sum12;sum23;sum34;sum45];

sex=[0;1;1;1;1;0;1;1;1;1;1;0;1;1;0;0;1;1;0;0;1;1;0];
age=[54;57;59;48;63;34;60;61;56;68;62;74;55;54;73;62;60;56;64;55;42;40;56];
lesionvol=load(strcat(data_dir, 'allpts_lesionvol.txt'));
lesionvol=lesionvol(:,1);
lesion_all=[lesionvol;lesionvol;lesionvol;lesionvol];
sex_all=[sex;sex;sex;sex];
age_all=[age;age;age;age];

figure('Position', [0 0 700 700])
plot(allsum, allrecover,'ko')
[rho,p]=corr(allsum, allrecover, 'rows', 'complete', 'Type', 'Spearman')
xlabel('Sum inter-scan remaps')
ylabel('Change FM')
saveas(gcf, strcat(results_dir, 'figures/sum_remaps_recovery_allsessions.png'))

results.corr_recovery_remaps.spearman_p=p;
results.corr_recovery_remaps.spearman_rho=rho;

results.partialcorr_recovery_remaps.order={'sum remaps', 'recovery', 'sex', 'age'};

[rho,p]=partialcorr([allsum,allrecover,sex_all,age_all], 'rows', 'complete', 'Type', 'Spearman')
results.partialcorr_recovery_remaps.spearman_p=p;
results.partialcorr_recovery_remaps.spearman_corr=rho;

[rho,p]=partialcorr([allsum,allrecover,sex_all,age_all], 'rows', 'complete', 'Type', 'Pearson')
results.partialcorr_recovery_remaps.perason_p=p;
results.partialcorr_recovery_remaps.pearson_corr=rho;

[rho,p]=partialcorr([allsum,allrecover,sex_all,age_all,lesion_all], 'rows', 'complete', 'Type', 'Spearman')

%% 
figure('Position', [0 0 1000 900])
tiledlayout(2,2)
nexttile;
plot(sum12, fm12,'ko')
[rho,p]=corr(sum12,fm12, 'rows', 'complete', 'Type', 'Pearson')
results.corr_recovery_remap_sessionspecific.s1s2.p=p;
results.corr_recovery_remap_sessionspecific.s1s2.rho=rho;

hold on;
idx=isnan(fm12);
b=polyfit(sum12(~idx), fm12(~idx),1);
a=polyval(b,sum12);
plot(sum12, a, '-r')
title('S1-S2 recovery (FM2-FM1) vs. sum of remapps S1-S2')
xlabel('Sum of remaps')
ylabel('Change in FM score (followup - baseline')
text(60, -20, ['rho=', num2str(round(rho,3)), ', p=', num2str(round(p,3))], 'FontSize', 15)
ylim([-40 80])
xlim([0 150])
set(gca,'FontSize', 15)

nexttile;
plot(sum23, fm23,'ko')
[rho,p]=corr(sum23,fm23, 'rows', 'complete', 'Type', 'Pearson')
results.corr_recovery_remap_sessionspecific.s2s3.p=p;
results.corr_recovery_remap_sessionspecific.s2s3.rho=rho;
hold on;
idx=isnan(fm23);
b=polyfit(sum23(~idx), fm23(~idx),1);
a=polyval(b,sum23);
plot(sum23, a, '-r')
title('S2-S3 recovery (FM3-FM2) vs. sum of remapps S2-S3')
xlabel('Sum of remaps')
ylabel('Change in FM score (followup - baseline')
text(70, -20, ['rho=', num2str(round(rho,3)), ', p=', num2str(round(p,3))], 'FontSize', 15)
ylim([-40 80])
xlim([0 150])
set(gca,'FontSize', 15)

nexttile;
plot(sum34, fm34,'ko')
[rho,p]=corr(sum34,fm34, 'rows', 'complete', 'Type', 'Pearson')
results.corr_recovery_remap_sessionspecific.s3s4.p=p;
results.corr_recovery_remap_sessionspecific.s3s4.rho=rho;
hold on;
idx=isnan(fm34);
b=polyfit(sum34(~idx), fm34(~idx),1);
a=polyval(b,sum34);
plot(sum34, a, '-r')
title('S3-S4 recovery (FM4-FM3) vs. sum of remapps S3-S4')
xlabel('Sum of remaps')
ylabel('Change in FM score (followup - baseline')
text(90, -20, ['rho=', num2str(round(rho,3)), ', p=', num2str(round(p,3))], 'FontSize', 15)
ylim([-40 80])
xlim([0 150])
set(gca,'FontSize', 15)

nexttile
plot(sum45, fm45,'ko')
[rho,p]=corr(sum45,fm45, 'rows', 'complete', 'Type', 'Pearson')
results.corr_recovery_remap_sessionspecific.s4s5.p=p;
results.corr_recovery_remap_sessionspecific.s4s5.rho=rho;
hold on;
idx=isnan(fm45);
b=polyfit(sum45(~idx), fm45(~idx),1);
a=polyval(b,sum45);
plot(sum45, a, '-r')
title('S4-S5 recovery (FM5-FM4) vs. sum of remapps S4-S5')
xlabel('Sum of remaps')
ylabel('Change in FM score (followup - baseline')
text(80, -20, ['rho=', num2str(round(rho,3)), ', p=', num2str(round(p,3))], 'FontSize', 15)
ylim([-40 80])
xlim([0 150])
set(gca,'FontSize', 15)

saveas(gcf, strcat(results_dir, 'figures/remaps_recovery_sessionspecific.png'))


