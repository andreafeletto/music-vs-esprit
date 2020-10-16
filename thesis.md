---
title: "MUSIC vs ESPRIT"
author: "Andrea Feletto"
lang: "it-IT"
toc: true
bibliography: "thesis.bib"
citation-style: "digital-signal-processing.csl"
link-citations: true
linestretch: 1.25
header-includes:
    - \usepackage{siunitx}
---

\newpage
# Richiami di Algebra Lineare e Statistica

La **speranza matematica** $\mathbb{E}[X]$ di una *variabile aleatoria* discreta $X$ associata ad una *funzione di probabilità* $p_X(x)$ e ad uno *spazio campionario* $\Omega$, è definita [@intro-probability] come la somma dei valori che $X$ può assumere, ponderati per la probabilità che si manifestino:
$$
\mathbb{E}[X] = \sum_{x \in \Omega} x \, p_X(x)
$$

Data una trasformazione lineare $A$, il vettore non nullo $x_i$ è [@finite-dim-vecspace] **autovettore** di $A$ se e solo se esiste uno scalare $\lambda_i$, detto **autovalore** di $A$ corrispondente a $x_i$, tale che sia rispettata l'equazione:
$$
A x_i = \lambda_i x_i
$$
La trasformazione $A$, quando applicata ad un suo autovettore, ha quindi lo stesso comportamento dell'autovalore corrispondente.

Data una successione di $N$ misurazioni $n$-dimensionali $\mathbb{x}_i = \left( x_i^{(1)}, \ldots, x_i^{(n)} \right)$ con $i \in [0, N - 1]$, sia $x^{(k)}$ il vettore delle $k$-esime componenti delle misurazioni $\mathbb{x}_i$:
$$
x^{(k)} = \left( x_0^{(k)}, \ldots, x_{N-1}^{(k)} \right)
$$
e sia [@math-methods] $s_k$ la **deviazione standard** di $x^{(k)}$:
$$
s_k = \sqrt{\mathbb{E} \left(
      \left( x^{(k)} - \mathbb{E} \left( x^{(k)} \right) \right)^2
      \right)}
$$
Si definiscono [@math-methods] quindi la **matrice di covarianza campionaria**, i cui elementi rappresentano la covarianza tra le rispettive misurazioni:
$$
V_{kl} = \mathbb{E} \left(
         \left( x^{(k)} - \mathbb{E} \left( x^{(k)} \right) \right)
         \left( x^{(l)} - \mathbb{E} \left( x^{(l)} \right) \right)
         \right)
$$
e la **matrice di correlazione campionaria** che analogamente rappresenta la correlazione tra le misurazioni:
$$
r_{kl} = \frac{V_{kl}}{s_k s_l}
$$
Covarianza e correlazione sono strumenti statistici che permettono di quantificare la dipendenza da due misurazioni. La correlazione, a differenza della covarianza, è confrontabile in quanto invariante a traslazioni e dilatazioni delle misurazioni.

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
Dato una sequenza di campioni $v[n]$ di lunghezza $L = N + M - 1$, si definisce il vettore dei campionamenti $\mathbb{v}[n]$ come la finestra di ampiezza $M$ da $v[n]$ a $v[n + M - 1]$.
Il vettore $\mathbb{v}[n]$ è quindi un campionamento $M$-dimensionale del segnale.

Isolando le componenti di segnale e di rumore, utilizzando una notazione analoga a quella del vettore dei campionamenti, si ha:
$$
\mathbb{v}[n] = \sum_{k=1}^K \mathbb{s}_k[n] + \mathbb{w}[n]
$$
Studiando il contributo $\mathbb{s}_k[n]$ della $k$-esima componente armonica e applicando le proprietà del modello armonico, è possibile esprimere ogni elemento $\mathbb{s}_{k,i}[n]$ in funzione di $s[n]$:
$$
\begin{split}
\mathbb{s}_{k,i} &= s_k[n + i] \\
                 &= A_k e^{j \phi_k} e^{j (n + i) \omega_k} \\
                 &= s_k[n] e^{j i \omega_k}
\end{split}
$$
E riscrivendo $\mathbb{s}_k[n]$ in forma matriciale si ottiene:
$$
\mathbb{s}_k = s_k[n]
\begin{bmatrix}
    1 \\
    e^{j \omega_k} \\
    \vdots \\
    e^{j (M-1) \omega_k}
\end{bmatrix}
$$

Si costruisce [@dsp-pqd] quindi la matrice $\mathbb{V}$, di dimensioni $N \times M$, ponendo sulle righe i vettori di campionamento $\mathbb{v}[n]$
$$
\mathbb{V} =
\begin{bmatrix}
    \mathbb{v}^t[0] \\
    \vdots \\
    \mathbb{v}^t[N - 1]
\end{bmatrix}
=
\begin{bmatrix}
v[0]   & \dots  & v[M - 1] \\
\vdots & \ddots & \vdots   \\
v[N - 1] & \dots & v[N + M - 2]
\end{bmatrix}
$$
ottenendo quindi una sequenza di $N$ misurazioni.

Assumendo che il rumore $w[n]$, e di conseguenza il segnale $v[n]$, abbia media nulla, si osserva che migliore è la scelta di $M$, tale che ogni vettore di campionamento $\mathbb{v}[n]$ includa periodi interi di ogni armonica, più la media di $\mathbb{v}[n]$ tende ad annullarsi.

Ciò comporta che la correlazione campionaria $\mathbb{R}_{kl}$ tra i vettori di campionamento $\mathbb{v}[k]$ e $\mathbb{v}[l]$ può essere approssimata da
$$
\hat{\mathbb{R}}_{kl} = \mathbb{E} \left(
                        \mathbb{v}^{(k)} \, \mathbb{v}^{(l)}
                        \right)
                      = \frac{1}{2} \, \mathbb{v}^{(k)} \cdot \mathbb{v}^{(l)}
$$
, dove $\mathbb{v}^{(k)}$ è la $k$-esima colonna di $\mathbb{V}$.

Ne risulta quindi la seguente stima della matrice di autocorrelazione:
$$
\hat{\mathbb{R}} = \frac{1}{2} \, \mathbb{V}^t \, \mathbb{V}
$$

\newpage
# Riferimenti

