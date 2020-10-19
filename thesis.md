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
# Richiami di Algebra Lineare e Statistica

Data una trasformazione lineare $A$, il vettore non nullo $x_i$ è [@finite-dim-vecspace] **autovettore** di $A$ se e solo se esiste uno scalare $\lambda_i$, detto **autovalore** di $A$ corrispondente a $x_i$, tale che sia rispettata l'equazione:
$$
A x_i = \lambda_i x_i
$$
La trasformazione $A$, quando applicata ad un suo autovettore, ha quindi lo stesso comportamento dell'autovalore corrispondente.

La **speranza matematica** $\mathbf{E}[X]$ di una *variabile aleatoria* discreta $X$ associata ad una *funzione di probabilità* $p_X(x)$ e ad uno *spazio campionario* $\Omega$, è definita [@intro-probability] come la somma dei valori che $X$ può assumere, ponderati per la probabilità che si manifestino:
$$
\mathit{E}\{X\} = \sum_{x \in \Omega} x \, p_X(x)
$$
Nel caso di una serie a valori reali $x[n]$ equiprobabili la speranza coincide con la media dei valori:
$$
\mathit{E} \left\{ x[n] \right\} = \frac{1}{N} \sum_{k=0}^{N-1} x[k]
$$

La **covarianza campionaria** tra le serie $\mathbf{x}$ e $\mathbf{y}$ è definita come il valore atteso del prodotto puntuale tra gli scarti delle due serie:
$$
cov \left\{ \mathbf{x}, \mathbf{y} \right\} = \mathit{E} \left\{   
    \left( \mathbf{x} - \mathit{E} \left\{ \mathbf{x} \right\} \right)
    \circ
    \left( \mathbf{y} - \mathit{E} \left\{ \mathbf{y} \right\} \right)
\right\}
$$
dove l'operatore $\circ$ indica il *prodotto puntuale*. Si noti che la somma di uno scalare ad un vettore è da considerarsi come applicata ad ogni elemento del vettore.
Quando le due serie coincidono, questo operatore prende il nome di **varianza**, la cui radice quadrata è la **deviazione standard** $\sigma_x$.

Poiché la covarianza è influenzata da traslazioni e dilatazioni delle serie, essa viene normalizzata rispetto alle deviazioni standard delle due serie, ottenendo la **correlazione campionaria**:
$$
corr \left\{ \mathbf{x}, \mathbf{y} \right\} = \frac{
    cov \left\{ \mathbf{x}, \mathbf{y} \right\}
    }{
    \sigma_x \sigma_y
}
$$

Data una successione di $N$ misurazioni $n$-dimensionali $\mathbf{x}_i = \left[ x_i^{(1)}, \ldots, x_i^{(n)} \right]$, sia $\mathbf{x}^{(k)}$ il vettore delle $k$-esime componenti delle misurazioni $\mathbf{x}_i$
$$
\mathbf{x}^{(k)} = \left[ x_0^{(k)}, \ldots, x_{N-1}^{(k)} \right]
$$

Si definisce [@math-methods] quindi la **matrice di correlazione campionaria**, i cui elementi rappresentano la *correlazione* tra le rispettive misurazioni:
$$
\mathbf{R}_{kl} = corr \left\{
    \mathbf{x}^{(k)}, \mathbf{x}^{(l)}
\right\}
$$

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

