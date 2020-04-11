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

Če poznamo verjetnosti potem igramo ves čas z enako strategijo, torej na posamezne številke stavimo enake deleže denarja, saj se nam tekom igre ne razkrivajo nove informacije o verjetnostih in zato ne rabimo spreminjati strategije. Za izračun optimalne strategije 
