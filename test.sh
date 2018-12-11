#!/bin/bash
mvn clean package

set -x -e

check() {
    sha256sum data.tx | sed s/tx/rx/ | sha256sum -c
}

dd if=/dev/urandom of=data.tx bs=10kB count=1
JAR='target/jmodem-0.1.jar'

#amodem send -q -i data.tx -l- -o audio.tx
java -cp $JAR jmodem.Main send <data.tx >audio.tx
java -cp $JAR jmodem.Main recv <audio.tx >data.rx
check

#amodem recv -q -i audio.tx -l- -o data.rx
#check

rm data.rx data.tx audio.tx
