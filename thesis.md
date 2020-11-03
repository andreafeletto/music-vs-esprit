---
lang: "it-IT"
toc: true
bibliography: "thesis.bib"
link-citations: true
linestretch: 1.25
---

\newpage

# Qualità dei Sistemi Elettrici di Potenza

Negli anni il numero di studi operati nell'area riguardante la qualità nei
sistemi elettrici di potenza è aumentato notevolmente [@dsp-pqd].
Questo è dovuto principalmente all'impiego di nuove fonti di energia, diverse
esigenze del consumatore e alla liberalizzazione del settore energetico.

L'avvento di nuove fonti di energia rinnovabile, come impianti solari ed eolici,
porta con se alcune criticità dovute ai disturbi che queste generano quando
allacciate alla rete elettrica.
L'interconnessione alla rete elettrica di fonti di energia caratterizzate da
una capacità produttiva variabile nel tempo è infatti causa di disturbi come
il *voltage swell* e il *voltage dip* [@effective-power-quality]. 
Lo standard *IEEE 1159* definisce questi due disturbi [@ieee-1159]
rispettivamente come un aumento e un calo di tensione per un tempo inferiore
al minuto.

L'utilizzo di inverters, al fine di convertire la corrente continua
generata dai pannelli solari e dalle turbine eoliche in corrente alternata,
causa l'inserimento di armoniche e inter-armoniche nella rete, dovute alla
natura non lineare di questi dispositivi [@impact-inverters].

Un'altra fonte di disturbi armonici e inter-armonici sono i dispositivi non
lineari, necessari al funzionamento dei dispositivi alimentati in corrente
continua in uso al giorno d'oggi.
In ambito civile infatti, a differenza dei contesti industriali, buona
parte del fabbisogno energetico domestico è speso in illuminazione,
riscaldamento, aria condizionata e dispositivi elettronici, come personal
computers e televisori [@losses-cables].
Nell'ultimo secolo si è quindi osservato un forte peggioramento della qualità
della rete, provocato da un uso sempre maggiore di inverters, raddrizzatori di
tensione e motori elettrici.

Una distorsione armonica è la presenza nel segnale di componenti armoniche
con frequenze multiple della frequenza di rete $f_0$, mentre una distorsione
inter-armonica è caratterizzata da frequenze che deviano da quelle armoniche.
Le problematiche dovute a questi tipi di disturbo sono molteplici.

Una ricerca svolta dall'*Institute of Electrical and Electronics Engineers*
ha studiato gli effetti delle armoniche ad alta frequenza sul funzionamento
dei trasformatori monofase. È stata individuata una proporzionalità
tra le dissipazioni dovute a correnti parassite e il quadrato della frequenza
dell'armonica considerata [@transformer-harmonic-loss].
Questo significa che un buon algoritmo di stima delle armoniche deve essere
in grado di individuare anche le frequenze più alte, in quanto queste sono
responsabili per la maggior parte delle dissipazioni di questo tipo.
Lo stesso Istituto ha svolto un ulteriore studio, il quale dimostra che le
perdite di carico nei cavi e nei trasformatori di un impianto elettrico, dovute
ad un'elevata presenza di armoniche, possono essere sufficientemente alte da
giustificare modifiche all'impianto, come l'aumento della sezione dei cavi
o l'installazione di condensatori per il rifasamento [@losses-cables].

Al fine di caratterizzare l'entità dei disturbi armonici e inter-armonici
all'interno di un segnale elettrico di potenza, risulta utile il concetto di
**Distorsione Armonica Totale**, la quale, note le componenti del segnale,
si può calcolare come segue:
$$
THD^2 = \frac{\sum_{k=2}^{K} V_k^2}{V_1^2}
$$
Dove $V_1$ è la tensione di linea e $V_k$ è la tensione della $k$-esima
armonica. Il THD è quindi la percentuale di energia presente nel segnale non
dovuta alla componente fondamentale [@dsp-pqd].

È importante precisare che i disturbi di tensione sono prodotti dal generatore,
mentre i disturbi di corrente sono causati dagli utilizzatori.
Tuttavia, se questi ultimi non vengono opportunamente compensati, una volta
raggiunta la sorgente provocano ulteriori disturbi di tensione.

La liberalizzazione del mercato dell'energia ha delle notevoli conseguenze
nel campo della qualità dei segnali di potenza [@power-quality-deregulation].
La necessità di aumentare i margini di guadagno porta le compagnie operanti
nel settore dell'energia a ridurre la manutenzione e lo sviluppo dei
sistemi di distribuzione.
Ciò comporta un inevitabile peggioramento della qualità.
Inoltre, la ridotta cooperazione tra società in concorrenza tra loro impatta
negativamente lo sviluppo di tecnologie e standards.

# Algoritmi per la stima dei disturbi armonici

Esistono numerosi algoritmi che permettono di stimare frequenza, ampiezza e
fase delle componenti sinusoidali di un segnale.
Si noti che non esiste un algoritmo adatto ad ogni contesto.
Spesso infatti, la precisione sulle misurazioni è correlata alla complessità
computazionale.

Il primo metodo basato sullo studio della matrice di covarianza è la
*Pisarenko Harmonic Decomposition* (PHD) [@pisarenko-single-tone], risalente
al 1973 [@pisarenko-original].
La PHD, basandosi sull'autovalore minore della matrice di covarianza, e
all'autovettore associato [@pisarenko-stat-analysis], permette di stimare le
frequenza di una sinusoide addizionata a rumore bianco gaussiano:
$$
\hat{\omega} = cos^{-1} \left(
    \frac{r_2 + \sqrt{r_2^2 + 8 r_1^2}}{4 r_1}
\right)
$$
dove $r_k$ è la covarianza campionaria:
$$
r_k = \frac{1}{N - k} \sum_{n=1}^{N-k} x(n) x(n + k)
$$
Questo algoritmo permette la stima solamente dell'armonica principale e non è
quindi utile nello studio dei disturbi armonici.

L'algoritmo più usato è la *Fast Fourier Transform* (FFT) che permette
di calcolare la *Discrete Fourier Transform* (DFT) ([@eq:dft]) di un segnale
a tempo discreto di lunghezza finita $N$.
$$
X[k] = \sum_{n=0}^{N-1} x[n] \, e^{-j \frac{2\pi}{N}kn}
$$ {#eq:dft}
È un algoritmo di tipo *Divide and Conquer* ed ha quindi una complessità
asintotica $\mathcal{O}(N\log{}N)$ [@fourier-alg-machine].
È un algoritmo veloce e di facile implementazione, ma ha molte limitazioni.

La risoluzione dello spettro generato è inversamente proporzionale alla
lunghezza del segnale campionato [@alg-comp-quality]
$$
\Delta f = \frac{1}{t_w}
$$
dove $t_w$ è la durata temporale del campionamento.
Se il segnale contiene armoniche la cui frequenza cambia nel tempo, $t_w$
deve essere sufficientemente piccolo da permettere una risoluzione temporale
che consenta di osservare la variazione delle frequenze.
Questo però implica una bassa risoluzione spettrale, la quale implica un
notevole errore sulla stima della frequenza.

La FFT soffre inoltre dell'effetto di *spectral leakage*
[@fft-time-domain-window].
Se la lunghezza del segnale non è tale da includere esclusivamente periodi
interi di ogni componente sinusoidale, lo spettro presenta errori di frequenza,
ampiezza e fase.
Poiché non è possibile conoscere a priori la lunghezza necessaria per non
ottenere questo effetto, ogni applicazione reale della FFT presenterà errori
di misura dovuti al *leakage*.

L'*Interpolated Fast Fourier Transform* (IFFT) è un algoritmo sviluppato al
al fine di ottenere misurazioni precise di frequenza, ampiezza e fase da
segnali affetti da *spectral leakage* [@ifft-comp].
L'algoritmo è basato sull'applicazione al segnale di una funzione finestra
opportunamente scelta [@ifft-original].
Due funzioni finestra spesso utilizzate sono la *Hanning window*
([@eq:hanning-window]) e la *Rife-Vincent window*.
$$
w[n] = sin^2 \left( \frac{\pi n}{N} \right)
$$ {#eq:hanning-window}
Uno studio pubblicato dalla IEEE [@ifft-comp] ha confrontato le prestazioni di
queste due funzioni finestra.
La *Hanning window* è risultata la scelta più adeguata per segnali con
un basso rapporto segnale/rumore (SNR) e dei quali non si hanno informazioni
sulle frequenze contenute.

Questo algoritmo è poco adatto all'analisi di segnali contenenti armoniche
o inter-armoniche vicine alla frequenza di rete e con ampiezza simile.
Queste possono infatti distorcere l'interpolazione dello spettro risultante
[@alg-comp-quality].

![Pseudospettro generato da MUSIC](assets/music-odd-even.png){#fig:music-odd-even width=60%}

*Multiple Signal Classification* (MUSIC) è un algoritmo basato sull'analisi
della matrice di autocorrelazione, in particolare sulla sua decomposizione
in autovettori [@multiple-emitter-location].
MUSIC prevede di ricavare uno pseudo-spettro ([@fig:music-odd-even]) stimando
il sottospazio del rumore, e di ottenere le informazioni sulle frequenze dai
massimi locali.
Al fine di stimare la matrice di correlazione $R$, una matrice $\mathbf{V}$
viene costruita mediante scorrimento di una finestra rettangolare larga $M$
sul segnale campionato di lunghezza $N$.
$$
R = \frac{1}{N} \mathbf{V}^t \, \mathbf{V}
$$
La scelta di $M$ influenza la precisione della misurazione.
In particolare $M$ deve essere tale da far sì che una finestra includa
solamente periodi interi della componente principale [@sliding-window-esprit].

Gli autovettori $\mathbf{s}_i$ della matrice di autocorrelazione $R$ formano
il sottospazio del segnale e il sottospazio del rumore.
Quest'ultimo è formato dagli autovettori associati agli $M - K$ autovalori
minori.
Le frequenze sono quindi stimate individuando i picchi dello pseudo-spettro
dato dal sottospazio del rumore:
$$
P_{music} \left( e^{j \omega} \right) =
\frac{1}{\sum_{i=K+1}^{M} \left| \mathbf{e}^H \mathbf{s}_i  \right|^2}
$$
dove $\mathbf{e}^H$ è il vettore di *steering* trasposto e coniugato.

Il metodo ESPRIT, a differenza di MUSIC, sfrutta il sottospazio del segnale
[@dsp-pqd].
L'algoritmo permette di individuare la matrice diagonale di rotazione $\Phi$
[@esprit-original], i cui elementi sono gli esponenziali complessi di fase
pari alle pulsazioni delle $K$ componenti sinusoidali del segnale.
$$
\Phi = diag \left\{ e^{j \omega_1}, \, \ldots, \, e^{j \omega_K} \right\}
$$
Una matrice $\Psi$, i cui autovettori coincidono con gli elementi sulla
diagonale di $\Phi$, viene stimata grazie alla decomposizione ai valori
singolari (SVD) della matrice $\mathbf{V}$ usata in MUSIC.
ESPRIT permette anche la stima del decadimento (se presente) delle sinusoidi
modellando opportunamente i gli esponenziali complessi:
$$
\Phi = diag \left\{
    e^{-\beta_1 + j \omega_1}, \, \ldots, \, e^{- \beta_K + j \omega_K}
\right\}
$$
dove $\beta_k$ è il decadimento della $k$-esima armonica.

Spesso la componente principale del segnale ha un'ampiezza uno o due ordini
di grandezza superiore a quella delle componenti armoniche.
In questi casi è quindi necessario applicare un filtro passa-alto al segnale
prima di stimarne i disturbi armonici.
La sproporzione nel contenuto energetico comporta infatti un aumento
dell'errore di stima [@dsp-pqd].

Una diversa rappresentazione matematica del segnale è quella in spazio di
stato. Nel caso di un segnale stazionario, questo può essere rappresentato da
due equazioni [@dsp-pqd]:
$$
\begin{cases}
\mathbf{x}[n] = A \, \mathbf{x}[n-1] + \mathbf{w}[n] \\
\mathbf{z}[n] = C \, \mathbf{x}[n] + \mathbf{v}[n]
\end{cases}
$$
dove $\mathbf{x}$ è il vettore di stato, $A$ la matrice di transizione,
$\mathbf{w}$ il vettore del rumore, $\mathbf{z}$ il vettore delle misurazioni,
$C$ la matrice di misurazione e $\mathbf{v}$ il vettore del rumore dovuto alla
misurazione.

Sfruttando questa rappresentazione è possibile stimare il contenuto armonico
(e altri tipi di disturbi) applicando il filtro di Kalman.
L'algoritmo si basa sulla minimizzazione dell'errore $\mathbf{e}$ nella stima
del vettore di stato $\mathbf{x}$ [@state-est-kalman].
$$
\mathbf{e}[n] = \mathbf{x}[n] - \hat{\mathbf{x}}[n]
$$
L'applicazione del filtro prevede la conoscenza a priori delle pulsazioni
$\omega_k$ delle quali si vuole conoscere ampiezza e fase.
Se è possibile assumere la sola presenza di armoniche, è sufficiente
stimare un valore di $K$ sufficientemente alto da verificare l'assunzione
che i rumori $\mathbf{w}$ e $\mathbf{v}$ siano gaussiani a media nulla.
Nel caso di presenza di inter-armoniche non è realisticamente possibile
assumere i valori delle pulsazioni, il che rende il filtro di Kalman inadatto
a misurazioni di questo tipo.

# Stima di Armoniche e Interarmoniche

## Modello Sinusoidale
Ogni segnale a tempo discreto $v[n]$ ottenuto da una rete elettrica può essere
espresso come la sovrapposizione di $K$ componenti sinusoidali, più una
componente di rumore.
$$
v[n] = s[n] + w[n] = \sum_{k=1}^K s_k[n] + w[n]
$$
Le componenti sinusoidali sono caratterizzate dall'ampiezza $a_k \geq 0$, dalla
fase $\phi_k \in [-\pi, \pi]$ e dalla pulsazione $\omega_k$.
$$
s_k[n] = a_k \, cos \left( n \omega_k + \phi_k \right)
$$
Le componenti $s_k[n]$ sono chiamate **armoniche** quando la loro pulsazione è
un multiplo della pulsazione fondamentale $\omega_0$, altrimenti sono dette
**interarmoniche**.

La $\tilde{k}$-esima armonica ha pulsazione $\omega_k = 2 \tilde{k} \pi f_0$.
Si noti che le frequenze sono normalizzate rispetto alla frequenza di
campionamento secondo la relazione $f_k = \tilde{f_k} / f_s$, dove $\tilde{f_k}$
è la frequenza in $\si{\hertz}$ e $f_s$ è la frequenza di campionamento.
Pertanto, se viene rispettato il Teorema del Campionamento di Nyquist-Shannon:
$$
f_c > 2 \, max\{f_k\}
$$
ne deriva che $\omega_k \in \left[ -\pi, \pi \right]$.

La $0$-esima armonica, avendo pulsazione nulla, è detta componente di corrente
continua e il suo valore di tensione è $V_{DC} = a_0 \, cos(\phi_0)$.
L'armonica fondamentale è detta invece componente di potenza ed ha pulsazione
$\omega_0 = \tau \tilde{f}_0 / f_c$ e ampiezza $a_0 = \sqrt{2} \, V_{rms}$, dove
$\tilde{f}_0$ è la frequenza della rete e $V_{rms}$ è la tensione efficace di
fase.

## Modello Armonico
Il segnale $v[n]$ può essere espresso anche sotto forma di esponenziali
complessi. La $k$-esima componente ha quindi la seguente forma:
$$
v_k[n] = A_k e^{j \phi_k} e^{j n \omega_k}
$$

Due campioni successivi della componente $v_k[n]$ sono legati da uno sfasamento
pari alla sua pulsazione $\omega_k$.
$$
v_k[n+1] = v_k[n] e^{j \omega_k}
         = A_k e^{j \phi_k} e^{j (n+1) \omega_k}
$$

## Riduzione Dimensionale del Segnale
Dato un segnale $v[n]$ di lunghezza $L = N + M - 1$, si definisce il vettore dei
campionamenti $\mathbf{v}[n]$ come la finestra di ampiezza $M$ da $v[n]$ a
$v[n + M - 1]$.
Il vettore $\mathbf{v}[n]$ è quindi un campionamento $M$-dimensionale del
segnale.

Si costruisce [@dsp-pqd] la matrice $\mathbf{V}$, di dimensioni $N \times M$,
ponendo sulle righe i vettori di campionamento $\mathbf{v}[n]$
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

Assumendo che il rumore $w[n]$, e di conseguenza il segnale $v[n]$, abbia media
nulla, si osserva che migliore è la scelta di $M$, tale che ogni vettore di
campionamento $\mathbf{v}[n]$ includa periodi interi di ogni armonica, più la
media di $\mathbf{v}[n]$ tende ad annullarsi.

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
Per il principio della sovrapposizione degli effetti la matrice di correlazione
del segnale $\mathbf{R}$ può essere espressa come somma della matrici di
correlazione $\mathbf{R}_s$ e $\mathbf{R}_n$ dovute rispettivamente alle
componenti armoniche e al rumore.

Assumendo che il rumore sia di natura gaussiana con varianza $\sigma_w^2$, la
sua matrice di correlazione vale:
$$
\mathbf{R}_w = \sigma_w^2 I
$$
dove $I$ è la matrice identità di dimensione $M \times M$ e $\sigma_w^2$
coincide con la potenza del rumore.

## Algoritmo ESPRIT

Isolando le componenti di segnale e di rumore, utilizzando una notazione
analoga a quella del vettore dei campionamenti, si ha:
$$
\mathbf{v}[n] = \sum_{k=1}^K \mathbf{s}_k[n] + \mathbf{w}[n]
$$ {#eq:sig:sampleform}
Studiando il contributo $\mathbf{s}_k[n]$ della $k$-esima componente armonica
e applicando le proprietà del modello armonico, è possibile esprimere ogni
elemento $\mathbf{s}_{k,i}[n]$ in funzione di $s_k[n]$:
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
dove $\mathbf{e}_k$ è detto *vettore steering*, il quale è formato dagli
sfasamenti successivi associati alla pulsazione $\omega_k$.

È quindi possibile riscrivere l'equazione {@eq:sig:sampleform} come
trasformazione lineare del vettore delle ampiezze complesse $\mathbf{A}$:
$$
\mathbf{v}[n] = \mathbf{E} \Phi^n \mathbf{A} + \mathbf{w}[n]
$$
dove $\mathbf{E}$ è una matrice $M \times K$ le cui $k$-esima colonna è il
vettore steering associato alla pulsazione $\omega_k$
$$
\mathbf{E} = \left[ \mathbf{e}_1, \ldots, \mathbf{e}_K \right]
$$
, $\Phi$ è una matrice diagonale i cui elementi sono gli esponenziali complessi
associati alle $K$ diverse pulsazioni
$$
\Phi = diag \left\{ e^{j \omega_1}, \ldots, e^{j \omega_K} \right\}
$$
mentre $A$ è il vettore delle ampiezze complesse
$$
\mathbf{A} = \begin{bmatrix}
    A_1 e^{j \phi_1} \\
    \vdots \\
    A_K e^{j \phi_K}
\end{bmatrix}
$$

# Implementazione in Python

Diverse librerie sono state utilizzate per l'implementazione e la
visualizzazione degli algoritmi MUSIC e ESPRIT.
La lettura e la memorizzazione di dati tabulari è gestita da *pandas*.
*numpy* permentte invece la memorizzazione di array contigui in memoria,
garantendo ottime prestazioni di calcolo nonostante il livello di astrazione.
Le routines per i calcoli di algebra lineare e per la localizzazione di massimi
locali sono formite dalla libreria *scipy*.
Per la visualizzazione è stata usata *matplotlib*.

Per garantire la riproducibilità delle stime, il generatore di numeri
pseudo-casuali incluso in *numpy* è stato inizializzato con un seme scelto
arbitrariamente.

```python
from math import tau

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import scipy as sp
import scipy.linalg as LA
import scipy.signal as ss

from utils import *

plt.style.use('seaborn-notebook')
np.random.seed(293710966)
```

Come primo esempio si sceglie un segnale contenente solo le prime 6 armoniche
dispari della frequenza di rete $f_0 = \SI{50}{\hertz}$.
Il segnale viene campionato a $f_c = \SI{2400}{\hertz}$ consentendo la stima di
armoniche fino a $\SI{1200}{\hertz}$.
La frequenza di campionamento scelta è sufficiente poiché l'armonica più alta
ha frequenza $f_{13} = \SI{650}{\hertz}$.
$$
x(n) = \sum_{k=2}^7 a_{2k-1} \, cos \left(2 \pi n (2k-1)
       \frac{f_0}{f_s} + \phi_{2k-1} \right) + w(n)
$$

Il campionamento inizia al tempo $t_0 = 0$ e termina una volta raccolti
$2^{12}$ campioni.
I campionamenti sono memorizzati come *IEEE 754 double-precision floating-point
numbers* i quali occupano $\SI{64}{\bit}$ di memoria.
La memorizzazione del segnale richiede quindi $\SI{32}{\kibi\byte}$ di memoria.

```python
magnitudes = pd.read_csv('./harmonic-voltage-magnitude.csv',
    index_col='number')['typical']
phases = np.radians(pd.read_csv('./phases.csv',
    index_col='number'))['3.8']

power_freq = 50
sampling_freq = 2400
harmonic_numbers = np.arange(3, 14, 2)
no_of_harmonics = harmonic_numbers.max()

time = np.arange(4096.)

noise = np.random.normal(0, 0.1, time.size)
signal = noise.copy()

for n in harmonic_numbers:
    amp = magnitudes[n]
    phase = phases[n]
    omega = tau * n * power_freq / sampling_freq
    signal += amp * np.cos(omega * time + phase)
```

Al fine di scegliere opportunamente la larghezza della finestra di
campionamento, si calcola la lunghezza del periodo $T_0$ della frequenza di
rete.
$$
T_0 = \frac{f_s}{f_0}
$$
La larghezza $M$ della finestra viene quindi calcolata pari a $10$ volte il
periodo $T_0$

```python
power_period = np.around(sampling_freq / power_freq).astype(int)
time_window = power_period * 10
data_size = signal.size - time_window + 1

windows = [signal[i : i + time_window] for i in range(data_size)]
data_matrix = np.vstack(windows)
```
Poiché la matrice di autocorrelazione stimata $\hat{R}$ è reale simmetrica, gli
autovettori e autovalori vengono calcolati con un algoritmo fornito da *scipy*
in grado di sfruttare questa proprietà.
$$
\hat{R} = \frac{1}{N} \mathbf{V}^t \mathbf{V}
$$

```python
correlation = data_matrix.conj().T @ data_matrix / data_matrix.shape[0]

signal_space_index = (time_window - no_of_harmonics, time_window - 1)
noise_space_index = (0, time_window - no_of_harmonics - 1)

signal_pca = LA.eigh(correlation, subset_by_index=signal_space_index)
noise_pca = LA.eigh(correlation, subset_by_index=noise_space_index)

signal_eigvecs = signal_pca[1].T
noise_eigvecs = noise_pca[1].T
```

L'algoritmo MUSIC fornisce l'equazione dello pseudo-spettro in funzione della
pulsazione normalizzata. L'intervallo in cui ha senso valutare lo spettro
è $\omega \in \left[ 0, \pi \right]$, in accordo con la teoria di
Nyquist-Shannon.

A differenza della DFT, la risoluzione spettrale può essere scelta arbitrariamente.
Bisogna però tenere in considerazione che una bassa risoluzione
comporta un'errore sulla stima della frequenza, mentre un'alta risoluzione
richiede maggior tempo di calcolo.
In questo caso si è scelta una risoluzione $\Delta f = \SI{1}{\hertz}$.

```python
omegas = np.linspace(0, np.pi, sampling_freq // 2)
freqs = omegas * sampling_freq / tau
```

Viene definita la matrice di *steering*, le cui righe sono i vettori di
*steering* calcolati per ogni pulsazione $\omega$ dello pseudo-spettro
$$
\mathbf{E}_{k} = \mathbf{e}_k^t
$$
dove $\mathbf{e}_k$ è il vettore di *steering* con pulsazione
$\omega = k \Delta\omega$.

```python
steering_matrix = np.exp(1j * np.outer(omegas, np.arange(time_window)))
pseudo_power = 1 / np.sum(
    np.abs(noise_eigvecs @ steering_matrix.conj().T) ** 2,
    axis=0
)
```

I massimi locali dello pseudo-spettro vengono individuati grazie alla
routine *find_peaks* fornita da *scipy*.
I dati ricavati vengono memorizzati in un *DataFrame* gestito dalla libreria
*pandas* in modo da poter estrarre i $K$ picchi di maggior potenza.

```python
peaks_idx, _ = ss.find_peaks(pseudo_power)

peaks = pd.DataFrame()
peaks['omega'] = omegas[peaks_idx]
peaks['freq'] = freqs[peaks_idx]
peaks['power'] = pseudo_power[peaks_idx]
peaks = peaks.sort_values('power').tail(harmonic_numbers.size).sort_values('omega')

est_freqs = peaks.freq.values
est_omegas = peaks.omega.values
real_freqs = power_freq * harmonic_numbers
err_freqs = (est_freqs - real_freqs) / real_freqs
```

Le ampiezze vengono stimate utilizzando gli autovettori appartenenti al
sottospazio del segnale.
Poiché la dimensione del sottospazio del segnale è maggiore del numero di
frequenze stimate, si usano gli autovettori ordinatamente associati ai numeri
armonici delle frequenze stimate.

```python
est_steering_matrix = np.exp(1j * np.outer(est_omegas, np.arange(time_window)))
est_noise_power = noise_pca[0].mean()

b = signal_pca[0][harmonic_numbers - 1] - est_noise_power
A = np.abs(
    signal_eigvecs[harmonic_numbers - 1] @ est_steering_matrix.conj().T
) ** 2

est_powers = LA.solve(A, b)

est_amplitudes = np.sqrt(2 * est_powers)
real_amplitudes = magnitudes[harmonic_numbers].values
err_amplitudes = (est_amplitudes - real_amplitudes) / real_amplitudes
```

Nella seguente tabella sono presentati i risultati delle stime di frequenza e
ampiezza.

\begin{center}
\begin{tabular}{lcccccc}
    \toprule
    &
    \multicolumn{3}{c}{Frequenza [\si{\hertz}]} &
    \multicolumn{3}{c}{Ampiezza [\si{\volt}]} \\
    \cmidrule(lr){2-4} \cmidrule(lr){5-7}
    k  & Reale & Stimata & Errore & Reale & Stimata & Errore \\
    \midrule
    3  & 150 & 150.13 & 0.08 \% & 1.5 & 1.498 & 0.11 \% \\
    5  & 250 & 250.21 & 0.08 \% & 4.0 & 4.025 & 0.63 \% \\
    7  & 350 & 350.29 & 0.08 \% & 4.0 & 4.012 & 0.31 \% \\
    9  & 450 & 450.38 & 0.08 \% & 0.8 & 0.804 & 0.53 \% \\
    11 & 550 & 550.46 & 0.08 \% & 2.5 & 2.533 & 1.33 \% \\
    13 & 650 & 649.54 & 0.07 \% & 2.0 & 2.025 & 1.26 \% \\
    \bottomrule
\end{tabular}
\end{center}

\newpage
# Riferimenti

