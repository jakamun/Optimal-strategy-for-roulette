# Optimal-strategy-for-roulette

V projektu obravnavamo igro rulete pri čemer je kolo nepošteno oz. neuravnoteženo, kar pomeni, da so nekatere številke verjetnejše od drugih. Pri taki igri se izkaže, da lahko igralec izoblikuje strategijo s katero premaga hišo. Še več igralec lahko izoblikuje strategijo s katero maksimizira svoj dobiček. Obstaja ne malo primerov, kjer so igralci izkoristili neuravnoteženost kolesa in si priigrali velike vsote. 

### Predstavitev problema

Denimo, da kolo zavrtimo n-krat. Igre so med sabo neodvisne in enako porazdeljene. Izid i-te igre označimo z <img src="https://render.githubusercontent.com/render/math?math=X_i=(X_{i1},\dots,X_{iK})^T">. Pri klasični ameriški ruleti je K=38 saj so možne številke, ki lahko padejo 00,0,1,2, ...,36. Torej <img src="https://render.githubusercontent.com/render/math?math=X_{ij}"> za j=1, ...,K je slučajna spremenljivka v i-ti igri za j-to številko na kolesu rulete in je enaka 1, če ta številka pade ali 0, če ne. Verjetnosti, da padejo posamezne številke pa označimo z vektorjem verjetnosti <img src="https://render.githubusercontent.com/render/math?math=p=(p_1,\dots,p_K)">. Torej <img src="https://render.githubusercontent.com/render/math?math=X_{ij}=1">, če številka pade z verjetnostjo <img src="https://render.githubusercontent.com/render/math?math=p_j"> in <img src="https://render.githubusercontent.com/render/math?math=X_{ij}=0">, če ne pade z verjetnostjo <img src="https://render.githubusercontent.com/render/math?math=1-p_j">. 

V i-ti igri imamo za stavo 1 evra na k-to število možnost izplačila <img src="https://render.githubusercontent.com/render/math?math=M_k">, če stavljena številka pade v tej igri. Naj bo <img src="https://render.githubusercontent.com/render/math?math=C_0"> začetni kapital in <img src="https://render.githubusercontent.com/render/math?math=C_n"> kapital ob koncu n-te igre. Označimo še strategijo n-te igre z <img src="https://render.githubusercontent.com/render/math?math=\gamma_n=(\gamma_{n0},\gamma_{n1},\dots,\gamma_{nK})^T">. Tu <img src="https://render.githubusercontent.com/render/math?math=\gamma_{n0}"> predstavlja kolikšen delež kapitala, ki ga imamo na voljo v n-ti igri torej <img src="https://render.githubusercontent.com/render/math?math=C_{n-1}"> ne stavimo. Delež kapitala, ki ga stavimo j-to številko v n-ti igri za j=1, ..., K pa predstavlja <img src="https://render.githubusercontent.com/render/math?math=\gamma_{nj}">. Denar, ki ga imamo na voljo po koncu n-te igre je enak:

<a href="https://www.codecogs.com/eqnedit.php?latex=C_n&space;=&space;C_{n-1}(\gamma_{n0}&space;&plus;&space;\sum_{j=1}^K\gamma_{nj}(M_k&plus;1)X_{nj})=C_0\prod_{i=1}^n(\gamma_{i0}&space;&plus;&space;\sum_{j=1}^K\gamma_{ij}(M_k&plus;1)X_{ij})" target="_blank"><img src="https://latex.codecogs.com/gif.latex?C_n&space;=&space;C_{n-1}(\gamma_{n0}&space;&plus;&space;\sum_{j=1}^K\gamma_{nj}(M_k&plus;1)X_{nj})=C_0\prod_{i=1}^n(\gamma_{i0}&space;&plus;&space;\sum_{j=1}^K\gamma_{ij}(M_k&plus;1)X_{ij})" title="C_n = C_{n-1}(\gamma_{n0} + \sum_{j=1}^K\gamma_{nj}(M_k+1)X_{nj})=C_0\prod_{i=1}^n(\gamma_{i0} + \sum_{j=1}^K\gamma_{ij}(M_k+1)X_{ij})" /></a>

V projektu obravnavamo primer, ko poznamo verjetnsoti in primer, ko ne poznamo verjetnosti. Obe strategiji bomo podrobneje obravnavali in implementirali v R-u tako, da bo lahko uporabnik pri simulirani igri rulete testiral strategiji.

### Optimalna strategija za znane verjetnosti

Za znano verjetnost je strategija v vsaki igri enaka. Torej v vsaki igri stavimo isti delež denarja na iste številke.

