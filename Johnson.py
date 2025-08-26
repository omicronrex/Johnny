from pathlib import Path
import re

dirs = [p.parent for p in Path("../").glob("*/johnny.cfg")]

print(dirs)

johnny_exts=[]
johnny_names=[]
johnny_descs=[]

def johnny(source:Path):
    print(source)
    with source.open() as f:
        matches=re.findall("///(\w+\([A-Za-z0-9, _]*\))((?:\n[ \t]*//.+)*)",f.read())

       # for match in matches:
        #    m.join(re.split('\n[ \t]*//', "\n   //hello\n    //world")).strip()

        print(matches) #list of tuples (function,desc)



for extension in dirs:
    with (extension/"johnny.cfg").open() as f:
        name=f.readline()
        johnny_exts.append(name)
        for line in f:
            johnny(extension/line.strip())
