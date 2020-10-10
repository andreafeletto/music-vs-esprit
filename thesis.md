---
title: "MUSIC vs ESPRIT"
author: "Andrea Feletto"
bibliography: "thesis.bib"
citation-style: "digital-signal-processing.csl"
link-citations: true
reference-section-title: "Bibliografia"
lang: "it"
linestretch: 1.25
header-includes:
    - \usepackage{siunitx}
---

# Richiami

La **speranza matematica** $\mathbb{E}[X]$ di una *variabile aleatoria* discreta $X$ associata ad una *funzione di probabilità* $p_X(x)$ e ad uno *spazio campionario* $\Omega$, è definita [@intro-probability] come la somma dei valori che $X$ può assumere, ponderati per la probabilità che si manifestino:
$$
\mathbb{E}[X] = \sum_{x \in \Omega} x \, p_X(x)
$$

Data una trasformazione lineare $A$, il vettore non nullo $x_i$ è [@finite-dim-vecspace] **autovettore** di $A$ se e solo se esiste uno scalare $\lambda_i$, detto **autovalore** di $A$, tale che sia rispettata l'equazione:
$$
A x_i = \lambda_i x_i
$$

Una matrice $A$ di dimensione $n \times m$ è detta **matrice di Toeplitz** se ogni sua diagonale discendente è costante:
$$
A_{ij} = A_{i+1, j+1} \quad \forall \, i \in [0, n-1] ,\, j \in [0, m-1]
$$

# Stima di Armoniche e Interarmoniche

## Modello Sinusoidale
Il segnale a tempo discreto $v[n]$ viene espresso [@dsp-pqd] come la somma di $K$ componenti sinusoidali più una componente di rumore.
$$
v[n] = s[n] + w[n] = \sum_{k=1}^K s_k[n] + w[n]
$$
Le componenti sinusoidali sono caratterizzate dall'ampiezza $a_k \geq 0$, dalla fase $\phi_k \in [-\pi, \pi]$ e dalla pulsazione $\omega_k$.
$$
s_k[n] = a_k \, cos \left( n \omega_k + \phi_k \right)
$$
Le componenti $s_k[n]$ vengono distinte in segnale di potenza, armoniche e interarmoniche in funzione della loro pulsazione.

La $\tilde{k}$-esima armonica ha pulsazione $\omega_k = \tilde{k} \tau f_0$ per $\tilde{k} \in \left[ 0, K-1 \right]$.
Si noti che le frequenze sono normalizzate rispetto alla frequenza di campionamento secondo la relazione $f_k = \tilde{f_k} / f_s$, dove $\tilde{f_k}$ è la frequenza in $\si{\hertz}$ e $f_s$ è la frequenza di campionamento.
Pertanto, se viene rispettato il limite inferiore dettato dalla frequenza di Nyquist $f_c > 2 \, max\{f_k\}$ ne deriva che $\omega_k \in \left[ -\pi, \pi \right]$.

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

Dato una sequenza di campioni $v(n)$ di lunghezza $L = N + M - 1$, si definisce [@dsp-pqd] la matrice $\mathbb{V}$ ponendo sulle righe le finestre di campionamento $\mathbb{v}(n)$ di lunghezza $M$ definite come l'intervallo di campioni da $v(n)$ a $v(n + M - 1)$.
$$
\mathbb{V} =
\begin{bmatrix}
    \mathbb{v}^t(0) \\
    \vdots \\
    \mathbb{v}^t(N - 1)
\end{bmatrix}
=
\begin{bmatrix}
v(0)   & \dots  & v(M - 1) \\
\vdots & \ddots & \vdots   \\
v(N - 1) & \dots & v(N + M - 2)
\end{bmatrix}
$$

## Multiple Signal Classification (MUSIC)
MUSIC è un algoritmo per la stima di frequenze e ampiezze delle armoniche di un segnale, basato sul sottospazio del rumore.

