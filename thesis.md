---
title: "MUSIC vs ESPRIT"
author: "Andrea Feletto"
lang: "it-IT"
toc: true
bibliography: "thesis.bib"
citation-style: "assets/dsp.csl"
link-citations: true
linestretch: 1.25
header-includes:
    - \usepackage{siunitx}
---

\newpage

# Qualità dei Sistemi Elettrici di Potenza

Negli anni il numero di studi operati nell'area riguardante la qualità nei
sistemi elettrici di potenza è aumentato notevolmente [@dsp-pqd].
Questo è dovuto a nuove fonti di energia, diverse esigenze del consumatore e
alla liberalizzazione del settore energetico.

L'avvento di nuove fonti di energia rinnovabile, come impianti solari ed eolici,
porta con se alcune criticità dovute ai disturbi che queste generano quando
allacciate alla rete elettrica.
L'interconnessione alla rete elettrica di fonti di energia caratterizzate da
una capacità produttiva variabile nel tempo è infatti causa di disturbi come
il *voltage swell* e il *voltage dip* [@effective-power-quality]. 
Inoltre, l'utilizzo di inverters per convertire la corrente continua generata
dai pannelli solari e dalle turbine eoliche in corrente alternata causa
l'inserimento di armoniche e inter-armoniche nella rete, dovute alla
natura non lineare di questi dispositivi [@impact-inverters].

Un'altra fonte di disturbi armonici e inter-armonici sono i dispositivi non
lineari necessari al funzionamento dei dispositivi alimentati in corrente
continua in uso al giorno d'oggi.
In ambito civile infatti, a differenza dei contesti industriali, buona
parte del fabbisogno energetico domestico è speso in illuminazione,
riscaldamento, aria condizionata e dispositivi elettronici come personal
computers e televisori [@losses-cables].
Nell'ultimo secolo si è quindi osservato un forte peggioramento della qualità
della rete, provocato da un uso sempre maggiore di inverters, raddrizzatori di
tensione e motori elettrici.

![Voltage dip dovuto ad un cortocircuito](assets/voltage-dip.png){#fig:swell-dip width=60%}

Il *voltage swell* e il *voltage dip* sono rispettivamente un aumento e una
riduzione del valore efficace della tensione per un lasso di tempo che può
durare da metà del periodo dell'armonica principale fino ad 1 minuto
[@ieee-1159].
Il loro effetto sul segnale di una linea monofase si può osservare in
[@fig:swell-dip].

Una distorsione armonica è la presenza nel segnale di componenti armoniche
con frequenze multiple della frequenza di rete $f_0$, mentre una distorsione
inter-armonica è caratterizzata da frequenze che deviano da quelle armoniche.

# Stima di Armoniche e Interarmoniche

## Modello Sinusoidale
Ogni segnale a tempo discreto $v[n]$ ottenuto da una rete elettrica può essere espresso come la sovrapposizione di $K$ componenti sinusoidali, più una componente di rumore.
$$
v[n] = s[n] + w[n] = \sum_{k=1}^K s_k[n] + w[n]
$$
Le componenti sinusoidali sono caratterizzate dall'ampiezza $a_k \geq 0$, dalla fase $\phi_k \in [-\pi, \pi]$ e dalla pulsazione $\omega_k$.
$$
s_k[n] = a_k \, cos \left( n \omega_k + \phi_k \right)
$$
Le componenti $s_k[n]$ sono chiamate **armoniche** quando la loro pulsazione è un multiplo della pulsazione fondamentale $\omega_0$, altrimenti sono dette **interarmoniche**.

La $\tilde{k}$-esima armonica ha pulsazione $\omega_k = 2 \tilde{k} \pi f_0$.
Si noti che le frequenze sono normalizzate rispetto alla frequenza di campionamento secondo la relazione $f_k = \tilde{f_k} / f_s$, dove $\tilde{f_k}$ è la frequenza in $\si{\hertz}$ e $f_s$ è la frequenza di campionamento.
Pertanto, se viene rispettato il Teorema del Campionamento di Nyquist-Shannon:
$$
f_c > 2 \, max\{f_k\}
$$
ne deriva che $\omega_k \in \left[ -\pi, \pi \right]$.

La $0$-esima armonica, avendo pulsazione nulla, è detta componente di corrente continua e il suo valore di tensione è $V_{DC} = a_0 \, cos(\phi_0)$.
L'armonica fondamentale è detta invece componente di potenza ed ha pulsazione $\omega_0 = \tau \tilde{f}_0 / f_c$ e ampiezza $a_0 = \sqrt{2} \, V_{rms}$, dove $\tilde{f}_0$ è la frequenza della rete e $V_{rms}$ è la tensione efficace di fase.

## Modello Armonico
Il segnale $v[n]$ può essere espresso anche sotto forma di esponenziali complessi. La $k$-esima componente ha quindi la seguente forma:
$$
v_k[n] = A_k e^{j \phi_k} e^{j n \omega_k}
$$

Due campioni successivi della componente $v_k[n]$ sono legati da uno sfasamento pari alla sua pulsazione $\omega_k$.
$$
v_k[n+1] = v_k[n] e^{j \omega_k}
         = A_k e^{j \phi_k} e^{j (n+1) \omega_k}
$$

## Riduzione Dimensionale del Segnale
Dato un segnale $v[n]$ di lunghezza $L = N + M - 1$, si definisce il vettore dei campionamenti $\mathbf{v}[n]$ come la finestra di ampiezza $M$ da $v[n]$ a $v[n + M - 1]$.
Il vettore $\mathbf{v}[n]$ è quindi un campionamento $M$-dimensionale del segnale.

Si costruisce [@dsp-pqd] la matrice $\mathbf{V}$, di dimensioni $N \times M$, ponendo sulle righe i vettori di campionamento $\mathbf{v}[n]$
$$
\mathbf{V} =
\begin{bmatrix}
    \mathbf{v}^t[0] \\
    \vdots \\
    \mathbf{v}^t[N - 1]
\end{bmatrix}
=
\begin{bmatrix}
v[0]   & \dots  & v[M - 1] \\
\vdots & \ddots & \vdots   \\
v[N - 1] & \dots & v[N + M - 2]
\end{bmatrix}
$$
ottenendo quindi una sequenza di $N$ misurazioni $M$-dimensionali.

Assumendo che il rumore $w[n]$, e di conseguenza il segnale $v[n]$, abbia media nulla, si osserva che migliore è la scelta di $M$, tale che ogni vettore di campionamento $\mathbf{v}[n]$ includa periodi interi di ogni armonica, più la media di $\mathbf{v}[n]$ tende ad annullarsi.

Ciò permette di stimare la matrice di correlazione campionaria $\mathbf{R}_{kl}$
$$
\hat{\mathbf{R}}_{kl} = \mathit{E} \left\{
    \mathbf{v}^{(k)} \circ \mathbf{v}^{(l)}
\right\}
  = \frac{1}{N} \, \mathbf{v}^{(k)} \cdot \mathbf{v}^{(l)}
$$
, dove $\mathbf{v}^{(k)}$ è la $k$-esima colonna di $\mathbf{V}$.
Riscrivendo l'equazione in forma matriciale si ottiene:
$$
\hat{\mathbf{R}} = \frac{1}{N} \, \mathbf{V}^t \, \mathbf{V}
$$

## Algoritmo MUSIC
Per il principio della sovrapposizione degli effetti la matrice di correlazione del segnale $\mathbf{R}$ può essere espressa come somma della matrici di correlazione $\mathbf{R}_s$ e $\mathbf{R}_n$ dovute rispettivamente alle componenti armoniche e al rumore.

Assumendo che il rumore sia di natura gaussiana con varianza $\sigma_w^2$, la sua matrice di correlazione vale:
$$
\mathbf{R}_w = \sigma_w^2 I
$$
dove $I$ è la matrice identità di dimensione $M \times M$ e $\sigma_w^2$ coincide con la potenza del rumore.

## Algoritmo ESPRIT

Isolando le componenti di segnale e di rumore, utilizzando una notazione analoga a quella del vettore dei campionamenti, si ha:
$$
\mathbf{v}[n] = \sum_{k=1}^K \mathbf{s}_k[n] + \mathbf{w}[n]
$$ {#eq:sig:sampleform}
Studiando il contributo $\mathbf{s}_k[n]$ della $k$-esima componente armonica e applicando le proprietà del modello armonico, è possibile esprimere ogni elemento $\mathbf{s}_{k,i}[n]$ in funzione di $s_k[n]$:
$$
\mathbf{s}_{k,i}[n] = s_k[n + i] = s_k[n] e^{j i \omega_k}
$$
E riscrivendo $\mathbf{s}_k[n]$ in forma vettoriale si ottiene:
$$
\mathbf{s}_{k}[n] = s_k[n]
\begin{bmatrix}
    1 \\
    e^{j \omega_k} \\
    \vdots \\
    e^{j (M-1) \omega_k}
\end{bmatrix} =
s_k[n] \, \mathbf{e}_k
$$
dove $\mathbf{e}_k$ è detto *vettore steering*, il quale è formato dagli sfasamenti successivi associati alla pulsazione $\omega_k$.

È quindi possibile riscrivere l'equazione {@eq:sig:sampleform} come trasformazione lineare del vettore delle ampiezze complesse $\mathbf{A}$:
$$
\mathbf{v}[n] = \mathbf{E} \Phi^n \mathbf{A} + \mathbf{w}[n]
$$
dove $\mathbf{E}$ è una matrice $M \times K$ le cui $k$-esima colonna è il vettore steering associato alla pulsazione $\omega_k$
$$
\mathbf{E} = \left[ \mathbf{e}_1, \ldots, \mathbf{e}_K \right]
$$
, $\Phi$ è una matrice diagonale i cui elementi sono gli esponenziali complessi associati alle $K$ diverse pulsazioni
$$
\mathbf{\Phi} = diag \left\{ e^{j \omega_1}, \ldots, e^{j \omega_K} \right\}
$$
mentre $A$ è il vettore delle ampiezze complesse
$$
\mathbf{A} = \begin{bmatrix}
    A_1 e^{j \phi_1} \\
    \vdots \\
    A_K e^{j \phi_K}
\end{bmatrix}
$$

\newpage
# Riferimenti

