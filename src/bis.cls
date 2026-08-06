% bis.cls -- documentklasse voor de lesbestanden van BIS-Basis
%
% Gebruik in een lesbestand:
%
%     \documentclass{bis}
%     \begin{document}
%     \les{7}{Breuken}
%     ...
%     \oplossingen
%     \end{document}
%
% Het sjabloon voor de commentaarkop bovenaan een lesbestand staat onderaan dit bestand.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bis}[2026/08/05 BIS-Basis lesbestand]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[a4paper,12pt]{article}

% --- bladspiegel ----------------------------------------------------------
% head=15pt: fancyhdr wil minstens 14.5pt, anders een waarschuwing per pagina.
\RequirePackage[a4paper,margin=2.5cm,head=15pt]{geometry}
\setlength{\parindent}{0pt}
\setlength{\parskip}{\medskipamount}

% --- taal en font ---------------------------------------------------------
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage[dutch]{babel}

% --- wiskunde -------------------------------------------------------------
\RequirePackage{amsmath,amssymb,amsthm,mathtools,cancel}

\RequirePackage{siunitx}
% Decimaal scheidingsteken is de punt (siunitx' standaard); als scheidingsteken
% voor duizendtallen dus geen komma maar een dunne spatie.
\sisetup{group-separator={\,},group-minimum-digits=4}
\DeclareSIUnit{\carat}{karaat}
\DeclareSIUnit{\are}{are}
% siunitx zet \litre als hoofdletter L; bij ons is dat een kleine l.
\DeclareSIUnit{\litre}{l}

% --- lijsten --------------------------------------------------------------
% shortlabels houdt de korte vorm \begin{enumerate}[(a)] van het oude
% enumerate-pakket in leven naast \setlist.
\RequirePackage[shortlabels]{enumitem}
\setlist[enumerate,1]{label=(\alph*)}

% itemize begint altijd een nieuwe paragraaf; topsep bovenop de globale
% \parskip (\medskipamount, zie hoger) geeft een te grote sprong tussen de
% inleidende tekst en het eerste bolletje, zeker in een smalle onthoud-box.
\setlist[itemize]{topsep=0pt}

% --- tekeningen -----------------------------------------------------------
\RequirePackage{xcolor}
\RequirePackage{tikz}
\usetikzlibrary{calc,arrows}

% --- overige --------------------------------------------------------------
\RequirePackage{graphicx}
\RequirePackage{multicol}
\RequirePackage{setspace}
\RequirePackage{mdframed}
\RequirePackage{ifthen}
\RequirePackage{etoolbox}
\RequirePackage{exsol}
\RequirePackage{fancyhdr}
\RequirePackage{hyperref}
% Geen gekleurde kaders rond links: de A.C.O.-titels blijven er in druk
% precies uitzien zoals voorheen, maar zijn in de pdf klikbaar. Wil je ze wel
% zichtbaar maken, vervang dit door bv.
% \hypersetup{colorlinks=true,linkcolor=blue}.
\hypersetup{hidelinks}

\pagestyle{fancy}

\renewcommand{\exercisename}{}
\renewcommand{\solutionname}{}

% --- titel van een oplossing ('A.C.O. <n>:') -------------------------------
% exsol zet die titel met \subparagraph. In article.cls is dat een kop met
% negatieve afterskip, dus een *inline* kop: \@xsect drukt hem niet meteen af
% maar parkeert hem in \everypar, zodat hij pas verschijnt zodra de eerste
% alinea van de oplossing begint. Gevolg: witruimte die je meteen na
% \subparagraph invoegt, komt in de verticale lijst terecht *voor* de titel en
% niet erna. De oude \vspace{-2\topsep} verkleinde daardoor precies de
% verkeerde afstand.
%
% Daarom zetten we de titel zelf, als gewone kop met expliciete ruimte boven
% en onder. \bissolboven en \bissolonder zijn de ruimte *bovenop* de gewone
% regelafstand; de 6pt \parskip van de titelalinea telt bij \bissolboven op.
\newlength{\bissolboven}\setlength{\bissolboven}{11pt \@plus 2pt \@minus 2pt}
\newlength{\bissolonder}\setlength{\bissolonder}{5pt \@plus 1pt \@minus 1pt}
\newcommand{\bis@soltitel}[1]{%
  \par
  % \if@nobreak: de titel volgt onmiddellijk op \section*{Oplossingen A.C.O.}.
  % Die kop zette zijn eigen afterskip al; die laten we staan, en we voegen
  % geen breekplaats toe (anders kan de sectiekop onderaan alleen achterblijven).
  \if@nobreak\else
    \removelastskip
    \penalty\@secpenalty
    \vskip\bissolboven
  \fi
  \noindent{\normalfont\normalsize\bfseries #1}%
  % \par\nobreak\vskip...\@afterheading is wat \@xsect voor een gewone kop
  % doet. \@afterheading zet \@nobreaktrue, waardoor de enumerate die volgt
  % zijn eigen \topsep overslaat: de ruimte na de titel is dus \bissolonder.
  \par\nobreak
  \vskip\bissolonder
  \@afterindenttrue
  \@afterheading}

% Ook de rest van de oplossing (na de titel) mag over een paginabreuk lopen,
% maar met sterk verhoogde penalties: enkel als het echt niet past, breekt
% LaTeX toch. Zelfde aanpak als bij de voorbeeld-omgeving.
% Een oplossing bestaat meestal uit een enumerate (de (a), (b), ... items).
% article.cls zet \@beginparpenalty, \@itempenalty en \@endparpenalty
% standaard op -\@lowpenalty (-51): een lichte uitnodiging om net vóór zo'n
% lijst te breken, goedkoper dan de \penalty\@secpenalty vóór de titel.
% \@beginparpenalty staat op 10000 (nooit): dat is precies de overgang van de
% titel naar het eerste item, en die mag nooit gesplitst worden. \@itempenalty
% (tussen de items) blijft eindig, zodat een oplossing die langer is dan een
% pagina toch nog kan breken.
% \predisplaypenalty niet aanraken: die staat standaard al op 10000 en
% verlagen zou net vóór elke display een breekplaats openen, ook meteen na de
% titel.
%
% Deze omgeving is de tegenhanger van \exsol@exercise (zie \ConfigureExSol
% onderaan): exsol schrijft ze naar \jobname.sol.tex met als argument het
% nummer van de bijhorende A.C.O. Wij zetten de titel zelf met \bis@soltitel
% in plaats van met \subparagraph, en maken hem klikbaar.
\renewenvironment{exsol@solution}[1]
{%
  \begingroup
  \clubpenalty=10000
  \widowpenalty=10000
  \interlinepenalty=9996
  \postdisplaypenalty=9996
  \interdisplaylinepenalty=9996
  \@beginparpenalty=10000
  \@itempenalty=9996
  \@endparpenalty=9996
  \bis@soltitel{\bis@acolabel{opl}{opg}{#1}{\solutionname}}%
}
{\par\endgroup}

% --- springen tussen opgave en oplossing -----------------------------------
% \bis@acolabel{<eigen kant>}{<andere kant>}{<nummer>}{<naam>}: zet het anker
% van deze kant (opg = opgave, opl = oplossing) en maakt het label meteen een
% link naar de andere kant. Klikken op 'A.C.O. 3:' bij de opgave springt dus
% naar de oplossing, en omgekeerd.
%
% Het nummer alleen volstaat als sleutel omdat een lesbestand precies één \les
% (en dus één sectie) bevat; de A.C.O.-nummering herbegint nergens binnen een
% bestand.
\newcommand{\bis@acolabel}[4]{%
  \hypertarget{aco:#1:#3}{}%
  \hyperlink{aco:#2:#3}{#4~#3:}}

% --- opmaak van les en oplossingen ----------------------------------------

% \les{<nr>}{<titel>}: zet de hoofding en zorgt dat het sectienummer
% gelijk is aan het lesnummer.
\newcommand{\les}[2]{%
  \lhead{}%
  \rhead{BIS-Basis -- Les #1}%
  \setcounter{section}{\numexpr#1-1\relax}%
  \section{#2}%
}

% \oplossingen: het standaardslot van een lesbestand. \loadSolutions komt uit
% exsol en doet \immediate\closeout\solutionstream + \input{\jobname.sol.tex}.
\newcommand{\oplossingen}{%
  \par
  % Enkel een pagina afsluiten als de huidige al echt iets bevat. Eindigt de
  % laatste oefening toevallig precies onderaan een pagina, dan staat er hier
  % al een verse pagina klaar met enkel een lege regel erop (\pagetotal is dan
  % net één \baselineskip); een kaal \newpage zou die als lege pagina met enkel
  % de hoofding uitleveren.
  \ifdim\pagetotal>1.5\baselineskip \newpage \fi
  \section*{Oplossingen A.C.O.}%
  \loadSolutions
}

% --- markeringen tijdens het schrijven ------------------------------------
\newcommand{\todo}[1]{\textcolor{red}{\##1\#}}
\newcommand{\question}[1]{\textcolor{blue}{\##1\#}}

\newcommand{\vraag}[2]{\begin{itemize}\item {\it #1} \vspace*{#2}\end{itemize}}

% --- wiskundige notatie ---------------------------------------------------
\newcommand{\degree}{\ensuremath{^\circ}}
\def\LRA{\Leftrightarrow\mkern40mu}

\newcommand\ggd{\qopname\relax o{\mathrm{ggd}}}
\newcommand\kgv{\qopname\relax o{\mathrm{kgv}}}

\newcommand{\vglproef}[2]{LL= #1\;${=\joinrel=}$\; RL= #2}

% \underwrite{<term>}{<pijl>}: onderstreepte term met een pijl eronder, om te
% tonen naar welk lid een term verhuist.
\newcommand{\underwrite}[2]{
\underset{#2}{\underline{#1}}
}

% --- menu's ---------------------------------------------------------------
\newcounter{menucount}\newcounter{curitem}% Counters
\newcommand{\menuitem}{\texttt}% Menu item formatting
\newcommand{\menusep}{\ensuremath{\rightarrow}}% Menu separator
\newcommand{\menuend}{\relax}% Menu end
\newcommand{\menulist}[1]{% \menulist{<menu list>}
  \setcounter{menucount}{0}\setcounter{curitem}{0}% Reset menucount & curitem
  \renewcommand*{\do}[1]{\stepcounter{menucount}}%
  \menulistparser{#1}% Count menu items
  \renewcommand*{\do}[1]{\menuitem{##1}\stepcounter{curitem}\ifnumless{\value{curitem}}{\value{menucount}}{\menusep}{\menuend}}%
  \menulistparser{#1}% Process list
}
\DeclareListParser{\menulistparser}{:}% List separator is ':'

%\graphicspath{{../figuren/}}

% --- invulruimte voor de leerling -----------------------------------------
\newcommand{\dotrule}[1]{%
   \parbox[t]{#1}{\vspace*{3pt}\dotfill}}

\newcommand{\dotFill}{\vspace*{6pt}\dotfill}

\newcommand{\dotlines}[1]{
\foreach \n in {1,...,#1}{

\vspace*{0.1cm}
\dotfill
\vspace*{0.1cm}
}}

\newcommand{\ruitjes}[1]{

\hskip-2.6cm
\begin{tikzpicture}[scale=1.075,x=1.0cm,y=1.0cm]
\draw [help lines, solid, gray, very thin, step=0.5cm] (0,-#1+0.1cm) grid (21.6,-0.1);
\end{tikzpicture}
\vspace*{-1cm}
}

\newcommand{\ruitjesxy}[2]{
\begin{tikzpicture}[scale=1.01,line cap=round,line join=round,>=triangle 45,x=1.0cm,y=1.0cm]
\draw [color=cqcqcq,dash pattern=on 1pt off 1pt, xstep=0.4.5cm, ystep=0.4.5cm] (0,-#2) grid (#1,0);
\end{tikzpicture}
}

\newcommand{\zrmbox}{\framebox{\phantom{EXE}}\phantom{X}}
\newcommand{\zrm}[1]{\framebox{#1}}

% arule* answerrules
\newcommand{\arules}[1]{
\color{lightgray}
\vspace*{0.10cm}
\foreach \n in {1,...,#1}{
  \vspace*{0.70cm}
  \hrule height 0.1pt\hfill
}\color{black}}
\newcommand{\arule}[1]{
\color{lightgray}{\raisebox{-0.1cm}{\rule[-0.05cm]{#1}{0.1pt}}}\color{black}
}

% --- omgevingen -----------------------------------------------------------

% environment oefening:
% houdt een teller bij die de oefeningen nummert
% probeert ook de oefening op één pagina te houden
\newcounter{noefening}
\setcounter{noefening}{0}
\newenvironment{oefening}
{
  \stepcounter{noefening}
  \begin{minipage}{\textwidth}
  \vspace*{8pt}{\large\bf Oefening \arabic{noefening}}
}{%
  \end{minipage}
}

% Een grens tussen twee alinea's is een breekplaats met penalty 0 (nagekeken
% met \tracingpages) en geen enkel penalty-register dekt ze af. Binnen een
% voorbeeld is dat net de plaats waar het misloopt: een korte introregel
% ('Controle:', 'Praktische werkwijze:') is een eigen alinea van één regel en
% bleef zo los onderaan de pagina achter, weg van de uitwerking die erbij
% hoort. Via de para/after-hook zetten we daar zelf een \penalty\@M neer.
% Die hook loopt in verticale mode meteen na de laatste regel van de alinea,
% dus vóór de \parskip-lijm van de volgende; de lijm erna is daardoor niet
% meer aanbreekbaar. (In para/before zou de penalty ná die lijm belanden en
% dus niets blokkeren.) Breken binnen een alinea en tussen de regels van een
% align blijft wel mogelijk, daar staan de penalties op 9996.
\newif\ifbis@keepgraf
\AddToHook{para/after}{\ifbis@keepgraf\penalty\@M\fi}

% environment voorbeeld:
% houdt een teller bij die de voorbeelden nummert
% nummering herbegint bij elke subsectie
% mag over een paginabreuk lopen, maar de verhoogde penalties zorgen
% ervoor dat LaTeX dat enkel doet als het echt niet anders kan.
% \predisplaypenalty blijft ongemoeid op zijn standaardwaarde 10000: verlagen
% zou net vóór elke display een breekplaats openen, ook meteen na de titel
% 'Voorbeeld <n>', die vaak door een align gevolgd wordt.
\newcounter{nvb}[subsection]
%\@addtoreset{nvb}{subsubsection}
\setcounter{nvb}{0}
\newenvironment{voorbeeld}
{
  \stepcounter{nvb}
  \begingroup
  \clubpenalty=10000
  \widowpenalty=10000
  \interlinepenalty=9996
  \postdisplaypenalty=9996
  \interdisplaylinepenalty=9996
  \@beginparpenalty=9996
  \@itempenalty=9996
  \@endparpenalty=9996
  \vspace*{4pt}
  % \nopagebreak is hier essentieel. \\[5pt] plaatst die 5pt via \vadjust
  % meteen ná de regel 'Voorbeeld <n>' in de verticale lijst, dus vóór de
  % penalty tussen de regels. Lijm die op een box volgt is een breekplaats met
  % penalty 0, en die zit dus buiten het bereik van \clubpenalty,
  % \widowpenalty en \predisplaypenalty: de titel bleef zo alleen onderaan de
  % pagina achter. \nopagebreak zet er een \penalty\@M vóór (ook via \vadjust,
  % en dus eerst in de lijst), waardoor de lijm niet meer aanbreekbaar is.
  \textit{Voorbeeld \arabic{nvb}}\nopagebreak\\[5pt]
  % Pas hierna aanzetten: breken vlak vóór het voorbeeld moet wel kunnen.
  \bis@keepgraftrue
}{%
  % Uitzetten vóór de afsluitende \par, anders blokkeert die laatste alinea
  % ook de breekplaats meteen ná het voorbeeld.
  \bis@keepgraffalse
  \par
  \endgroup
}

% environment voorbeeld*:
% mag over een paginabreuk lopen, maar de verhoogde penalties zorgen
% ervoor dat LaTeX dat enkel doet als het echt niet anders kan
\newenvironment{voorbeeld*}
{
  \begingroup
  \clubpenalty=10000
  \widowpenalty=10000
  \interlinepenalty=9996
  \postdisplaypenalty=9996
  \interdisplaylinepenalty=9996
  \@beginparpenalty=9996
  \@itempenalty=9996
  \@endparpenalty=9996
  \vspace*{4pt}
  \textit{Voorbeeld}
  \bis@keepgraftrue
}{%
  \bis@keepgraffalse
  \par
  \endgroup
}

% environment meerkeuze:
% de antwoordmogelijkheden van een meerkeuzevraag, gelabeld (A), (B), ...
% Een eigen lijstsoort, zodat het label niet afhangt van de diepte waarop de
% vraag staat: in L31 zit een meerkeuze binnen een gewone enumerate.
% nosep haalt de witruimte tussen de items weg, zodat de vraag als één blok
% leest; topsep en itemsep zetten daarna enkel het hoogstnodige terug: een
% volle regel voor de vraagtekst, en 5pt tussen de items, want antwoorden met
% een \dfrac zijn hoger dan de regelafstand en raken elkaar anders bijna.
% Die volgorde is nodig, enumitem verwerkt de sleutels op volgorde.
\newlist{meerkeuze}{enumerate}{1}
\setlist[meerkeuze]{label=(\Alph*), ref=(\Alph*), nosep,
                    topsep=8pt, itemsep=5pt}

\newenvironment{onthoud}
{
\begin{mdframed}[nobreak=true,frametitle={Te onthouden}]
}{%
\end{mdframed}
}

\newtheorem{definition}{Definitie}
\newtheorem{eigenschap}{Eigenschap}

% --- tikz-hulpmiddelen ----------------------------------------------------
\newcommand{\tikzmark}[1]{\tikz[overlay,remember picture] \node (#1) {};}

\newcommand{\drawbox}[4]
{
\draw [line width=1.6pt] (#1,#2) -- (#3,#2) -- (#3,#4) -- (#1,#4) -- cycle;
}
\newcommand{\fillbox}[4]
{
\draw [line width=1.6pt] (#1,#2) -- (#3,#2) -- (#3,#4) -- (#1,#4) -- cycle;
\fill [fill opacity=0.23] (#1,#2) -- (#3,#2) -- (#3,#4) -- (#1,#4) -- cycle;
}

\newcommand{\getallenas}[3][1]{
\definecolor{cqcqcq}{rgb}{0.65,0.65,0.65}
\begin{tikzpicture}[scale=#1,line cap=round,line join=round,>=triangle 45,x=1.0cm,y=1.0cm]
\draw [color=cqcqcq,dash pattern=on 1pt off 1pt, xstep=1.0cm,ystep=1.0cm] (#2,-0.2) grid (#3,0.2);
\draw[->,color=black] (#2,0) -- (#3,0);
\draw[shift={(0,0)},color=black] (0pt,2pt) -- (0pt,-2pt) node[below] {\footnotesize $0$};
\draw[shift={(1,0)},color=black] (0pt,2pt) -- (0pt,-2pt) node[below] {\footnotesize $1$};
\draw[color=black] (#3.25,0.07) node [anchor=south west] {$\mathbb{R}$};
\end{tikzpicture}
}

\newcommand{\assenstelsel}[5][1]{
\definecolor{cqcqcq}{rgb}{0.65,0.65,0.65}
\begin{tikzpicture}[scale=#1,line cap=round,line join=round,>=triangle 45,x=1.0cm,y=1.0cm]
\draw [color=cqcqcq,dash pattern=on 1pt off 1pt, xstep=1.0cm,ystep=1.0cm] (#2,#4) grid (#3,#5);
\draw[->,color=black] (#2,0) -- (#3,0);
\draw[shift={(1,0)},color=black] (0pt,2pt) -- (0pt,-2pt) node[below] {\footnotesize $1$};
\draw[color=black] (#3.25,0.07) node [anchor=south west] { x};
\draw[->,color=black] (0,#4) -- (0,#5);
\draw[shift={(0,1)},color=black] (2pt,0pt) -- (-2pt,0pt) node[left] {\footnotesize $1$};
\draw[color=black] (0.09,#5.25) node [anchor=west] { y};
\draw[color=black] (0pt,-10pt) node[right] {\footnotesize $0$};
\end{tikzpicture}
}

\newcommand{\visgraad}[1]{\begin{tabular}{p{0.5cm}|p{#1}}&\\\hline\\\end{tabular}}

\newcommand{\opdracht}{{\bf Opdracht }}

% --- tabellen en formules -------------------------------------------------
% geef tabular iets meer ruimte
\setlength{\tabcolsep}{15pt}
\renewcommand{\arraystretch}{1.5}

% geef align iets meer ruimte:
\addtolength{\jot}{0.5em}

\onehalfspacing
%singlespacing
%doublespacing

% --- exsol ----------------------------------------------------------------
% Nummer de A.C.O.'s per sectie doorlopend vanaf 1, in plaats van met de
% samengestelde nummers die exsol standaard maakt. De klasse roept dit zelf
% aan bij \begin{document}; een lesbestand hoeft dat niet meer te doen.
\newcommand{\ConfigureExSol}{
\renewcommand{\exercisename}{A.C.O.}
\renewcommand{\solutionname}{A.C.O.}
\newcounter{exercise2}[section]
\setcounter{exercise2}{0}
\renewcommand{\theexercise}{%
    \arabic{exercise2}%
}
% Ook het hyperref-anker moet uniek zijn. Het standaardanker van exsol's
% exercise-teller herbegint bij elke subsubsectie, wat dubbele bestemmingen
% oplevert; sectienummer + eigen teller is wel uniek.
\def\theHexercise{\thesection.\arabic{exercise2}}
% Het argument #1 is het nummer dat exsol zelf uitrekende; we nummeren met een
% eigen teller en negeren het. Vangt de omgeving dat argument niet op, dan komt
% het als zwevend cijfer vooraan de opgave in de tekst terecht.
\renewenvironment{exsol@exercise}[1]
{%
\refstepcounter{exercise2}
  \begin{minipage}[t]{\textwidth}%
    \ifthenelse{\boolean{exsol@exerciseaslist}}
               {\begin{list}%
                   {%
                   }%
                   {%
                     \setlength{\topsep}{0pt}%
                     \setlength{\leftmargin}{1em}%
                     \setlength{\rightmargin}{1em}%
                     \setlength{\listparindent}{0em}%
                     \setlength{\itemindent}{0em}%
                     \setlength{\parsep}{\parskip}}%
                 \item[\hspace*{\leftmargin}\textit{%
                     \bis@acolabel{opg}{opl}{\theexercise}{\exercisename}}]
               }%
               {
                 \textbf{\bis@acolabel{opg}{opl}{\theexercise}{\exercisename}}~
               }
}
{%
  \ifthenelse{\boolean{exsol@exerciseaslist}}
             {\end{list}}{}
  \end{minipage}
  \vspace{1ex}\par
}
}

\AtBeginDocument{\ConfigureExSol}

% --------------------------------------------------------------------------
% Sjabloon voor de commentaarkop van een lesbestand. Altijd bovenaan, vóór
% \documentclass:
%
%     % Basiscursus Wiskunde - Lespakket <N>      <- het lespakket enkel vermelden
%     % Les <nr>. <Titel>                            als het nummer bekend is
%     %
%     % Wijzigingen t.o.v. de originele bis-basis:
%     % * ...
%     %
%     % Openstaande opmerkingen:
%     % * ...
% --------------------------------------------------------------------------
