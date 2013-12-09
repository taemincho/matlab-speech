
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DEBUT DE LA FONCTION PRINCIPALE%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function gui_guidata_guihandles
data=guihandles(gcf);



% Cr�ation de l'objet Figure
figure('units','pixels',...
    'position',[250 250 500 500],...
    'color',[0.95 0.95 0.95],...
    'numbertitle','off',...
    'name','Projet Traitement de Signal : Speech Analysis',...
    'menubar','none',...
    'tag','interface');

% Cr�ation de l'objet Uicontrol Pushbutton -
uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[0.1 0.8 0.15 0.05],...
    'string','Enregistrer',...
    'callback',@record,...
    'tag','bouton_retrancher');

% Cr�ation de l'objet Uicontrol Pushbutton +
uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[0.3 0.8 0.1 0.05],...
    'string','Jouer',...    
    'callback',@ecouter,...
    'tag','bouton_ecouter');

uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[0.5 0.8 0.15 0.05],...
    'string','Reconnaitre',...    
    'callback',@match,...
    'tag','bouton_match');

% Cr�ation de l'objet Uicontrol Text r�sultat
uicontrol('style','text',...
    'units','normalized',...
    'position',[0.1 0.2 0.3 0.05],...
    'string','0',...
    'tag','resultat');

uicontrol('style','text',...
    'units','normalized',...
    'position',[0.35 0.9 0.3 0.03],... %[X,Y,Largeur,Hauteur]
    'string','Reconnaissance Vocal');
% G�n�ration de la structure contenant les identifiants des objects graphiques dont la 
% propri�t� Tag a �t� utilis�e.

% D'apr�s les Tag utilis�s pour les objets graphiques cr�es pr�c�demment, la structure data 
% contient les champs suivant :
%   data.interface
%   data.resultat
%   data.bouton_ajouter
%   data.bouton_retrancher
%


data.Fs = 8000;
data.nbits_sound=16;
data.nbits_channel=1;

%L'utilisateur enregistre un son
data.isListenning=0;
%Nombre de lettre que l'utilisateur a enregistr�
data.nbletter=0;
%Tableau contenant les lettres enregistr�es
data.tbcell = cell(data.nbletter,1);
data.tbsignaux=cell(data.nbletter,1);
%Alphabet
data.alphabet={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
for i=1:length(data.alphabet)
    path=strcat(data.alphabet{i},'.wav');
    if exist(path)
        data.nbletter=data.nbletter+1;
        data.tbcell{data.nbletter,1}=data.alphabet{i};
        data.tbsignaux{data.nbletter,1}=wavread(path);
    end;
end;

data.columnName = {'Lettre'};
data.tableau=uitable('ColumnName', data.columnName,'Data', data.tbcell);


%data.rec = audiorecorder(data.Fs,data.nbits_sound,data.nbits_channel);
%data.rec_save = audiorecorder(data.Fs,data.nbits_sound,data.nbits_channel);

% Enregistrement de data dans les donn�es d'application de l'objet Figure

guidata(gcf,data)

function record(obj,event)

% R�cup�ration des donn�es stock�es dans les donn�es d'application de l'objet Figure
% contenant l'objet graphique dont l'action est ex�cut�e (gcbf)
data=guidata(gcbf);
signal=record2data(1,1);
prompt=cell(1);
answer=inputdlg(prompt);
temp=answer{1,1};
%Cr�ation du nom du fichier sur base du nom donn� par l'utilisateur
pathname=strcat(temp,'.wav');
if exist(pathname)
    i=0;
    find=0;
    while(find==0)
        i=i+1;
        temp2=data.tbcell{i,1};
         if (temp2==temp)
            wavwrite(signal,pathname);
            data.tbsignaux{i,1}=signal; 
            find=1;
        end;
    end;
else
%Insertion 
data.nbletter=data.nbletter+1;
data.tbcell{data.nbletter,1}=answer{1,1};
data.tbsignaux{data.nbletter,1}=signal; 
wavwrite(signal,pathname);   
end;

%Rafraichissement du tableau
set(data.tableau, 'Data', data.tbcell);

    %data.tbcell{data.nbletter,2} = getaudiodata(data.rec)
    %data.rec = audiorecorder(data.Fs,data.nbits_sound,data.nbits_channel);

% Modification de sa propri�t� String
%set(data.resultat,'string',num2str(data.nCompteur));

% Enregistrement des donn�es modifi�es dans les donn�es d'application de l'objet Figure
% contenant l'objet graphique dont l'action est ex�cut�e (gcbf)
guidata(gcbf,data)


function ecouter(obj,event)
data=guidata(gcbf);
prompt=cell(1);
answer=inputdlg(prompt);
answer=answer{1,1};
temp=answer;
%answer=strcat(answer{1,1},'.wav')
i=0;
find=0;
while(find==0)
    i=i+1;
    if i>length(data.tbcell)
        disp('Signal non trouv�');
        break;
    end;
    if (data.tbcell{i,1}==temp)
        wavplay(data.tbsignaux{i,1},data.Fs);
        find=1;
    end;
end;
%signal=wavread(answer);
%wavplay(signal,data.Fs);


guidata(gcbf,data)

function match(obj,event)
data=guidata(gcbf);
signal=record2data(2,1);
a=diffBetweenSignals(signal,data.tbsignaux);
disp(a);
%prompt=cell(1);
%answer = inputdlg(prompt);
%data.answer=answer;
% Augmentation de la valeur de nCompteur
    %data.nCompteur=data.nCompteur+1;

% Modification de sa propri�t� String
    %set(data.resultat,'string',num2str(data.nCompteur));

% Enregistrement des donn�es modifi�es dans les donn�es d'application de l'objet Figure
% contenant l'objet graphique dont l'action est ex�cut�e (gcbf)
guidata(gcbf,data)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FIN DE LA SOUS-FONCTION AJOUTER%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
