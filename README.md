# Optimal-strategy-for-roulette

V projektu obravnavamo igro rulete pri čemer je kolo nepošteno oz. neuravnoteženo, kar pomeni, da so nekatere številke verjetnejše od drugih. Pri taki igri se izkaže, da lahko igralec izoblikuje strategijo s katero premaga hišo. Še več igralec lahko izoblikuje strategijo s katero maksimizira svoj dobiček. Obstaja ne malo primerov, kjer so igralci izkoristili neuravnoteženost kolesa in si priigrali velike vsote. Optimalno strategijo, ki jo je predlagal Klotz v [članku](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.49.3373&rep=rep1&type=pdf) bomo implementirali v R-u.

### Navodila za zagon

Program se zažene z zagonom datoteke `roulette.R`. V tej datoteki se naložijo vse potrebne knjižnice, hkrati se še poženeta datoteki `server.R` in `ui.r` v katerih se nahaja koda, ki poganja aplikacijo. Igralec ob začetku igre prejme 10 €, vendar lahko v katerem koli trenutku igre naloži dodaten denar.

### Splošno o igri rulete

Igra rulete poteka tako, da igralec stavi na številke ali posamezne skupine številk za katere misli, da bojo ob naslednjem vrtenju kolesa padle. Poznamo dve vrsti rulete ameriško in evropsko. Razlikujete se v tem da ima ameriška ruleta dve ničli, kar pomeni, da so verjetnosti številk manjše kot pri evropski ruleti. Kar pomeni, da igralec še težje pride do pozitivnega izkupička. Spodaj sta prikazana miza in kolo ameriške rulete.

![Miza ameriške rulete](/images/american-roulette.png)

Stavimo lahko na vsa polja, ki so prikazana na mizi. Prav tako lahko stavimo še na posebne kombinacije številk, ki so na mizi sosede ali se nahajajo v istem stolpcu ali vrstici. Stave delimo na notranje stave in zunanje stave. Ta analogija temelji na tem kje na mizi se nahaja polje na katerega stavimo. Notranje stave so vse stave na številke in njihove kombinacije, medtem ko so zunanje stave stave na polja, ki se nahajajo ob robu mize, npt. stava na barvo. Vse možne notranje stave:
- Igralec lahko stavi na **posamično število**;
- Igralec  lahko stavi na kakršen koli **par števil**, ki sta na mizi sosedi, npr. 3 in 6;
- Igralec lahko stavi na **stolpec števil** oz. na tri števila hkrati, npr. 1, 2 in 3;
- Igralec lahko stavi stavi na kombinacijo **štirih števil**, ki so na mizi sosede, npr. 2, 5, 3 in 6;
- Igralec lahko stavi na **dva stolpca hkrati** oz. na 6 števil naenkrat, npr. 1, 2, 3, 4, 5 in 6;
- Igralec lahko stavi na kombinacijo **petih števil**, ki je možna samo v ameriški ruleti. Tu igralec stavi na 0, 00, 1, 2 in 3

Vse možne zunanje stave:
- Stava na **barvo**;
- Stava na **sodost/lihost**;
- Stava na števila od 1 do 18 ali od 19 do 36;
- Stava na **ducat** števil tu so tri možnosti, ki so izrasane na mizi npr. 1-12;
- Stava na **vrstico** npr. 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36

Dobitki se seveda razlikuje na vrsto stave, vendar velja, da na manjšo kombinacijo kot stavimo večji so dobitki in obratno tj. največji dobitek je pri stavi na posamezno številko, ki je 35:1 najmanjši pa pri stavah kjer zajamemo skoraj polovico primerov npr. stava na barvo, kjer je dobitek glede na stavo 1:1, torej če stavimo na najbolj verjetno kombinacijo bomo v primeru zmage podvojili vložen denar. Vsi dobitki so prikazani spodaj:

|Vrsta stave|Dobitek|Verjetnost pri evropski|Verjetnost pri ameriški|
|------|---------|--------|-------|
|Barva|1:1|48,6 %|47,4 %|
|Sodost/lihost|1:1|48,6 %|47,4 %|
|1-18/19-36|1:1|48,6 %|47,4 %|
|Ducat|2:1|32,4 %|31,6 %|
|Vrstica|2:1|32,4 %|31,6 %|
|6 števil|5:1|16,2 %|15,8 %|
|5 števil|6:1|13,5 %|13,2 %|
|4 števila|8:1|10,8 %|10,5 %|
|3 števila| 11:1|8,1 %|7,9 %|
|2 števili|17:1|5,4 %|5,3 %|
|Posamezno število|35:1|2,7 %|2,6 %|

Zgornja tabela prikazuje verjetnosti pri pošteni igri rulete za katere obstaja kar nekaj različnih strategij igranja, ki maksimizirajo dobiček igralca. Nekaj od teh strategij je opisanih [tukaj](https://www.roulettesites.org/strategies/). Nas pa zanima kakšne strategije se da izoblikovati pri igri rulete, ko je kolo neuravnoteženo oz. verjetnosti niso enake za vsa števila.

### Predstavitev problema

Denimo, da kolo zavrtimo n-krat. Igre so med sabo neodvisne in enako porazdeljene. Izid i-te igre označimo z <img src="https://render.githubusercontent.com/render/math?math=X_i=(X_{i1},\dots,X_{iK})^T">. Pri klasični ameriški ruleti je K=38 saj so možne številke, ki lahko padejo 00,0,1,2, ...,36. Torej <img src="https://render.githubusercontent.com/render/math?math=X_{ij}"> za j=1, ...,K je slučajna spremenljivka v i-ti igri za j-to številko na kolesu rulete in je enaka 1, če ta številka pade ali 0, če ne. Verjetnosti, da padejo posamezne številke pa označimo z vektorjem verjetnosti <img src="https://render.githubusercontent.com/render/math?math=p=(p_1,\dots,p_K)">. Torej <img src="https://render.githubusercontent.com/render/math?math=X_{ij}=1">, če številka pade z verjetnostjo <img src="https://render.githubusercontent.com/render/math?math=p_j"> in <img src="https://render.githubusercontent.com/render/math?math=X_{ij}=0">, če ne pade z verjetnostjo <img src="https://render.githubusercontent.com/render/math?math=1-p_j">. 

V i-ti igri imamo za stavo 1 evra na k-to število možnost izplačila <img src="https://render.githubusercontent.com/render/math?math=M_k">, če stavljena številka pade v tej igri. Naj bo <img src="https://render.githubusercontent.com/render/math?math=C_0"> začetni kapital in <img src="https://render.githubusercontent.com/render/math?math=C_n"> kapital ob koncu n-te igre. Označimo še strategijo n-te igre z <img src="https://render.githubusercontent.com/render/math?math=\gamma_n=(\gamma_{n0},\gamma_{n1},\dots,\gamma_{nK})^T">. Tu <img src="https://render.githubusercontent.com/render/math?math=\gamma_{n0}"> predstavlja kolikšen delež kapitala, ki ga imamo na voljo v n-ti igri torej <img src="https://render.githubusercontent.com/render/math?math=C_{n-1}"> ne stavimo. Delež kapitala, ki ga stavimo j-to številko v n-ti igri za j=1, ..., K pa predstavlja <img src="https://render.githubusercontent.com/render/math?math=\gamma_{nj}">. Denar, ki ga imamo na voljo po koncu n-te igre je enak:

<a href="https://www.codecogs.com/eqnedit.php?latex=C_n&space;=&space;C_{n-1}(\gamma_{n0}&space;&plus;&space;\sum_{j=1}^K\gamma_{nj}(M_k&plus;1)X_{nj})=C_0\prod_{i=1}^n(\gamma_{i0}&space;&plus;&space;\sum_{j=1}^K\gamma_{ij}(M_k&plus;1)X_{ij})" target="_blank"><img src="https://latex.codecogs.com/gif.latex?C_n&space;=&space;C_{n-1}(\gamma_{n0}&space;&plus;&space;\sum_{j=1}^K\gamma_{nj}(M_k&plus;1)X_{nj})=C_0\prod_{i=1}^n(\gamma_{i0}&space;&plus;&space;\sum_{j=1}^K\gamma_{ij}(M_k&plus;1)X_{ij})" title="C_n = C_{n-1}(\gamma_{n0} + \sum_{j=1}^K\gamma_{nj}(M_k+1)X_{nj})=C_0\prod_{i=1}^n(\gamma_{i0} + \sum_{j=1}^K\gamma_{ij}(M_k+1)X_{ij})" /></a>

V projektu obravnavamo primer, ko poznamo verjetnsoti in primer, ko ne poznamo verjetnosti. Obe strategiji bomo podrobneje obravnavali in implementirali v R-u tako, da bo lahko uporabnik pri simulirani igri rulete testiral strategiji.

### Optimalna strategija za znane verjetnosti

Če poznamo verjetnosti potem igramo ves čas z enako strategijo, torej na posamezne številke stavimo v vsaki igri enake deleže denarja, saj se nam tekom igre ne razkrivajo nove informacije o verjetnostih in zato ne rabimo spreminjati strategije. [Kelley](https://www.princeton.edu/~wbialek/rome/refs/kelly_56.pdf) je ugotovil, da dobimo z maksimizacijo logaritma dobitka optimalnejšo strategijo. Zato maksimiziramo pričakovano vrednost logaritma dobitka po eni igri. Dobitek po eni igri bi lahko zapisali kot <img src="https://render.githubusercontent.com/render/math?math=C_1">, vendar raje zapišemo dobitek po eni igri kot:

<p align="center">
  <a href="https://www.codecogs.com/eqnedit.php?latex=\prod_{k=1}^K(\gamma_0&plus;(M_k&plus;1)\gamma_k)^{X_k}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\prod_{k=1}^K(\gamma_0&plus;(M_k&plus;1)\gamma_k)^{X_k}" title="\prod_{k=1}^K(\gamma_0+(M_k+1)\gamma_k)^{X_k}" /></a>
</p>

Sedaj je upanje dobitka veliko lažeje izračunati in dobimo:

<p align="center">
<a href="https://www.codecogs.com/eqnedit.php?latex=\sum_{k=1}^Kp_kln(\gamma_0&plus;(M_k&plus;1)\gamma_k)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\sum_{k=1}^Kp_kln(\gamma_0&plus;(M_k&plus;1)\gamma_k)" title="\sum_{k=1}^Kp_kln(\gamma_0+(M_k+1)\gamma_k)" /></a>
</p>

Imamo še dva pogoja <img src="https://render.githubusercontent.com/render/math?math=\gamma_k\geq 0"> za k=0,1,...,K in <img src="https://render.githubusercontent.com/render/math?math=\sum_{k=0}^K\gamma_k=1">. Z uporabo Kuhn_Tucker-jevih pogojev dobimo maksimalno pričakovano vrednost logaritma ene igre:

<p align="center">
<a href="https://www.codecogs.com/eqnedit.php?latex=\sum_{k=1}^{r}p_{k}ln(p_{k}(M_{k}&plus;1))&plus;p_{0}ln(\gamma_{0})" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\sum_{k=1}^{r}p_{k}ln(p_{k}(M_{k}&plus;1))&plus;p_{0}ln(\gamma_{0})" title="\sum_{k=1}^{r}p_{k}ln(p_{k}(M_{k}+1))+p_{0}ln(\gamma_{0})" /></a>
</p>

Kjer je 
<p align="center">
<a href="https://www.codecogs.com/eqnedit.php?latex=p_{0}&space;=&space;\sum_{k=r&plus;1}^{K}&space;p_{k}" target="_blank"><img src="https://latex.codecogs.com/png.latex?p_{0}&space;=&space;\sum_{k=r&plus;1}^{K}&space;p_{k}" title="p_{0} = \sum_{k=r+1}^{K} p_{k}" /></a>
</p>
Za `r` pa velja <img src="https://render.githubusercontent.com/render/math?math=K\geq r\geq 1"> in je največje število za katero veljata naslednja pogoja:

<p align="center">
<a href="https://www.codecogs.com/eqnedit.php?latex=\begin{align*}&space;1&space;-&space;\sum_{k=1}^{r}&space;\frac{1}{M_{k}&plus;1}&space;>&space;0&space;\\&space;p_{r}(M_{r}&plus;1)&space;>&space;\gamma_{0}[r]&space;\end{align*}" target="_blank"><img src="https://latex.codecogs.com/png.latex?\begin{align*}&space;1&space;-&space;\sum_{k=1}^{r}&space;\frac{1}{M_{k}&plus;1}&space;>&space;0&space;\\&space;p_{r}(M_{r}&plus;1)&space;>&space;\gamma_{0}[r]&space;\end{align*}" title="\begin{align*} 1 - \sum_{k=1}^{r} \frac{1}{M_{k}+1} > 0 \\ p_{r}(M_{r}+1) > \gamma_{0}[r] \end{align*}" /></a>
</p>

Kjer je:

<p align="center">
<a href="https://www.codecogs.com/eqnedit.php?latex=\gamma_{0}[k]&space;=&space;\frac{1-\sum_{j=1}^{k}&space;p_{j}}{1-\sum_{t=1}^{k}&space;\frac{1}{M_{t}&plus;1}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\gamma_{0}[k]&space;=&space;\frac{1-\sum_{j=1}^{k}&space;p_{j}}{1-\sum_{t=1}^{k}&space;\frac{1}{M_{t}&plus;1}}" title="\gamma_{0}[k] = \frac{1-\sum_{j=1}^{k} p_{j}}{1-\sum_{t=1}^{k} \frac{1}{M_{t}+1}}" /></a>
</p>

In tako je <img src="https://render.githubusercontent.com/render/math?math=\gamma_0 = \gamma_0[r]"> in:

<p align="center">
<a href="https://www.codecogs.com/eqnedit.php?latex=\gamma_{k}&space;=&space;p_{k}&space;-&space;\frac{\gamma_{0}}{M_{k}&plus;1}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\gamma_{k}&space;=&space;p_{k}&space;-&space;\frac{\gamma_{0}}{M_{k}&plus;1}" title="\gamma_{k} = p_{k} - \frac{\gamma_{0}}{M_{k}+1}" /></a>
</p>

#### Primer

Denimo, da imamo 7 možnih stav tj. K=7, ki pokrijejo vsa možna števila pri ameriški ruleti. Prva stava, ki jo označimo z k=1 je stava na prvih 6 števil {1,...,6} izplačilo je 5:1. Do k=6 imamo stave na naslednjih 6 števil, kot si sledijo po vrsti. Stava k=6 predstavlja stavo na obe ničli {0, 00} z izplačilom 17:1. Zadnja možna stava pa je stava na zadnjih 6 števil {31,...,36}. Verjetnosti so naslednje p=(11/38, 9/38, 7/38, 5/38, 3/38, 1/38, 2/38)

|k|Verjetnost|Izplačilo (M_k)|p_k(M_k+1)|y_0[k]|y_k|
|--|--|--|--|--|--|
|1|11/38|5|66/38|81/95|4/19|
|2|9/38|5|54/38|27/38|3/19|
|3|7/38|5|42/38|11/19|2/19|
|4|5/38|5|30/38|9/19|1/19|
|5|3/38|5|18/38|9/19|0|
|6|1/38|17|18/38|-|0|
|7|2/38|5|12/38|-|0|

V tem primeru je r=4, saj pri k=5 ne velja 18/38 > 9/19 vendar velja enakost in tako eden izmed dveh pogojev ni izpolnjen. Opazimo, da velik delež denarja ne stavimo vendar ga zadržimo.


#### Pričakovana vrendnost dobitka in varianca



### Nepoznane verjetnosti

Seveda v realnem svetu ni za pričakovati, da bomo poznali verjetnosti. Zato poiščimo optimalno strategijo za n iger <img src="https://render.githubusercontent.com/render/math?math=\gamma[n]=(\gamma_{1},\dots ,\gamma_{n})^{(K %2B 1)\times n}">. Kot lahko opazimo iz oznake imamo v vsaki igri novo strategijo, ki jo postavimo na podlagi prejšnjih iger. Strategijo v vsaki igri določimo na enak način, kot smo jo določili pri poznani verjetnosti s to razliko, da moramo verjetnosti sedaj oceniti. Verjetnosti v vsaki igri ocenimo znova z upoštevanje števil, ki so padla v prejšnjih igrah.


Verjetnosti ocenimo z uporabo `bayesove statistike`, katere natančen opis se lahko najde na [wiki](https://en.wikipedia.org/wiki/Bayesian_inference). Osnovna ideja ocenjevanja parametrov z bayesovo statistiko je, da se izračuna pričakovano vrednost ocenjevanega parametra iz aposteriorne gostote in to uporabimo, kot oceno parametra. Aposteriorna gostota je sestavljena iz apriorne gostote, ki predstavlja naše predhodno prepričanje o ocenjevanem parametru in iz vzorčne gostote (X|p). Torej aposteriorna gostota je oblike:

<p align"center">
<img src="https://render.githubusercontent.com/render/math?math=\pi(p|x)=f(x|p)\pi(p)">
</p>

S takim postopkom izračunamo cenilko za **p** v n-ti igri. Cenilka verjetnosti v n-ti igri za k-to številko je enaka:

<p align="center">
  <img src="https://render.githubusercontent.com/render/math?math=\hat{p}_{n,k}=E(p_k|X[n-1])=\frac{\alpha_k %2B S_k[n-1]}{\alpha_{%2B}%2B n-1}">
</p>

kjer je:
<p align="center">
  <img src="https://render.githubusercontent.com/render/math?math=S_k[n-1]=\sum_{i=1}^{n-1}X_{ik}">
</p>

Seveda `S` je za n=0 enak 0.
