
import numpy as np

def plotdb(axes, x, y, *args, **kwargs):
    axes.plot(x, 20 * np.log10(y), *args, **kwargs)

def plotzero(axes, *args, **kwargs):
    axes.plot(*args, **kwargs)
    
    axes.spines['bottom'].set_position('zero')
    axes.spines['left'].set_position('zero')
    
    axes.spines['right'].set_color('none')
    axes.spines['top'].set_color('none')
    
    axes.xaxis.tick_bottom()
    axes.yaxis.tick_left()