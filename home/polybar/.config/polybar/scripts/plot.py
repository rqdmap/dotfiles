import os
import datetime
import numpy as np

import matplotlib.pyplot as plt

plt.figure(figsize=(8, 6))
plt.subplots_adjust(bottom=0.2)

path = os.path.dirname(os.path.abspath(__file__))
log_file = path + '/battery.log'
x = []
y = []
with open(log_file) as f:
    res = f.read().split('\n')


    x_size = 100;
    d = 5;
    assert(x_size % d == 0)

    for line in res[-min(len(res), x_size + 2):]:
        line = line.split(' ')
        if(len(line) != 2):
            continue
        x.append(datetime.datetime.fromtimestamp(int(line[0])).strftime("%m-%d %H:%M:%S"))
        y.append(int(line[1]))

    plt.plot(x, y)
    plt.xticks(np.arange(0, len(x) + 1, 5), rotation=45)
    plt.yticks(np.arange(0, 105, 5))
    plt.savefig(path + '/battery.png')

