% root locus/step response demo

% Build on top of resource at:
% https://se.mathworks.com/help/control/ug/build-app-with-interactive-plot-updates.html
s=tf('s');

Q=s^2+4*s+3;
P=s^3+2*s^2+s+2;

%Q=s^2+s+3;
%P=s*(s^2+2*0.2*1*s+1^2);

K = 1;
Kmax=500;
max_slider=100;
f = figure;
f.Position = [100 50 900 500]; 
ax = axes('Parent',f,'position',[0.1 0.3 0.35 0.6]);
ax2 = axes('Parent',f,'position',[0.55 0.3 0.35 0.6]);

b = uicontrol('Parent',f,'Style','slider','Position',[81,54,719,23],...
              'value', K, 'min',0, 'max', max_slider);

bgcolor = f.Color;
bl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],...
                'String','0','BackgroundColor',bgcolor);
bl2 = uicontrol('Parent',f,'Style','text','Position',[800,54,23,23],...
                'String',num2str(Kmax),'BackgroundColor',bgcolor);
bl3 = uicontrol('Parent',f,'Style','text','Position',[400,25,100,23],...
                'String','Gain (logarithmically spaced)','BackgroundColor',bgcolor);

b.Callback = @(es,ed) drawroot(Q,P, es.Value, Kmax, ax, ax2, max_slider);

drawroot(Q,P, 1, Kmax, ax, ax2, max_slider);

function drawroot(Q, P, ix, Kmax, ax, ax2, max_slider)
    Ks=logspace(-1,log10(Kmax),max_slider);
    K = Ks(round(ix));
    h2 = stepplot(ax2, (K*Q/P)/(1+K*Q/P));
    setoptions(h2,'XLim',[0,10],'YLim',[0,3]);
    title(['Step response, K=',num2str(K)])
    h = rlocusplot(ax, Q/P);
    setoptions(h,'XLim',[-10,10],'YLim',[-10,10]);
    r = rlocus(Q/P, K);

    hold on
    x=real(r);
    y=imag(r);
    plot(x, y, 'm*','MarkerSize',10)
    xlim([-10,10]);
    ylim([-5,5]);
    title(['Root locus, K=',num2str(K)])
    hold off
end