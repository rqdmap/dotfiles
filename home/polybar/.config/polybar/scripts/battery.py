# Read dictionary from upower
import os,sys
import time

output = os.popen('upower -i /org/freedesktop/UPower/devices/battery_BAT0').read()
kv = [[j.strip() for j in i.strip().split(':', 1)] for i in output.split('\n')]
kv = [i for i in kv if len(i) == 2 and len(i[1]) > 0]
kv = dict(kv)

# Update log file
path = os.path.dirname(os.path.abspath(__file__))
log_file = path + '/battery.log'
update = False
try:
    f = open(log_file, 'rb')
    if os.path.getsize(log_file) > 200:
        f.seek(-200, 2)
    line = f.readlines()[-1].decode("utf-8").strip()

    now = line.split(" ")[0]
    if int(time.time()) - int(now) > 60:
        update = True
        
    percentage = line.split(" ")[1]
    if percentage != kv['percentage'][:-1]:
        update = True
except:
    pass

if update == True:
    now = int(time.time())
    output = str(now) + ' ' + kv['percentage'][:-1] + '\n'
    with open(log_file, 'a') as f:
        f.write(output)
    f.close()





# Used by polybar

def charging():
    return kv['state'] != 'discharging'

# 特殊处理
if len(sys.argv) == 2:
    if sys.argv[1] == '1' and charging() and int(kv['percentage'][:-1]) < 95:
        exit(0)
    if sys.argv[1] == '0' and not charging():
        exit(0)
    exit(-1)


if kv['state'] == 'charging':
    print(kv['time to full'])
else:
    print(kv['time to empty'])



