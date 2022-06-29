import parsl
import os
import time,sys

from parsl.app.app import python_app, bash_app
from parsl.data_provider.files import File

from parslpw import pwconfig,pwargs

@bash_app
def sort_numbers_4 (inputs=[], outputs=[]):
    return '''
        if1=%s
        if2=%s
        of=%s
        echo $(date) $(hostname) $(/bin/pwd) $0: $if1 $if2 $of >> /pworks/bash_app.log
        cat $if1 $if2 |
        sort -n > $of
    ''' % (inputs[0].filename, inputs[1].filename, outputs[0].filename)

def main():
    prefix = 'file://parslhost/' # + os.getcwd() + '/'
    unsorted_file_1 = File(prefix+pwargs.sort1)
    unsorted_file_2 = File(prefix+pwargs.sort2)
    out_file        = File(prefix+pwargs.sorted)

    f = sort_numbers_4(inputs=[unsorted_file_1, unsorted_file_2], outputs=[out_file])
    
    print (f.result())
    print("test of PW Coasters done")

parsl.load(pwconfig)

main()
