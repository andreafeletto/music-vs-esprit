
import numpy as np

def plotdb(axes, x, y, *args, **kwargs):
    axes.plot(x, 20 * np.log10(y), *args, **kwargs)