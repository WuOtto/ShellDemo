#!/bin/bash
 
# --------------------------------------------------------------------------- #
# 获取文件名后缀
# Parameter1: 文件名
# output: Yes
# return: None
# --------------------------------------------------------------------------- #
function FileSuffix() {
    local filename="$1"
    if [ -n "$filename" ]; then
        echo "${filename##*.}"
    fi
}
 
# --------------------------------------------------------------------------- #
# 获取文件名前缀
# Parameter1: 文件名
# output: Yes
# return: None
# --------------------------------------------------------------------------- #
function FilePrefix() {
    local filename="$1"
    if [ -n "$filename" ]; then
        echo "${filename%.*}"
    fi
}
 
# --------------------------------------------------------------------------- #
# 判断文件后缀是否是指定后缀
# Parameter1: 文件名
# parameter2: 后缀名
# output: None
# return: 0: 表示文件后缀是指定后缀；1: 表示文件后缀不是指定后缀
# --------------------------------------------------------------------------- #
function IsSuffix() {
    local filename="$1"
    local suffix="$2"
    if [ "$(FileSuffix ${filename})" = "$suffix" ]; then
        return 0
    else
        return 1
    fi
}
 
# --------------------------------------------------------------------------- #
# 将xib编译成nib文件
# --------------------------------------------------------------------------- #
function transitionToNib(){
    ibtool --errors --warnings --output-format human-readable-text --compile ibtool --errors --warnings --output-format human-readable-text --compile $1 $2
 
}
 
# --------------------------------------------------------------------------- #
#处理输入的参数 并编译成nib
# --------------------------------------------------------------------------- #
function handlFile(){
    ORIGIN=$1
    # echo $1
 
    XIBFILE=${ORIGIN##*/}
    # echo "$XIBFILE xib文件"
 
    IsSuffix ${XIBFILE} "xib"
    ret=$?
 
    if [  $ret -eq 0 ]; then
        echo "the suffix of the ${file} is xib"
        FILENAME="${ORIGIN%.*}"
        NIBFILEDIR=$FILENAME".nib"
        NIBFILE=${NIBFILEDIR##*/}
 
        echo "$FILENAME file名"
        echo "$NIBFILE nib文件"
 
        transitionToNib $NIBFILE $XIBFILE
    else
        echo "the suffix of the ${XIBFILE} is not xib"
    fi
 
 
}
 
#循环目录，将每个xib编译成nib
function scandir() {
    local cur_dir parent_dir workdir
    workdir=$1
    cd ${workdir}
    if [ ${workdir} = "/" ]
    then
        cur_dir=""
    else
        cur_dir=$(pwd)
    fi
 
    for dirlist in $(ls ${cur_dir})
    do
        if test -d ${dirlist};then
            cd ${dirlist}
            scandir ${cur_dir}/${dirlist}
            cd ..
        else
            echo "${cur_dir}/${dirlist} 子文件"
 
            handlFile ${cur_dir}/${dirlist}
 
        fi
    done
}
 
 
echo `basename $0` is in `pwd`
#return
 
#判断是否有输入参数 需输入一个xib文件 或 一个只包含xib的文件 注意，xib文件名不能为空，否则不会被编译成nib
if [ ! -n "$1" ] ;then
    echo "you have not input a xibfile or directory of xibfile!"
    return
# else
    # echo "the word you input is $1"
fi
 
 
 
#判断是文件还是文件夹
if test -d $1
then
 
    # echo "you input  a directory"
 
    scandir $1
 
    exit 1
 
elif test -f $1
then
    # echo "you input a file "
 
    handlFile $1
     
    exit 1
else
    echo "the Directory isn't exist which you input,pls input a new one!!"
    exit 1
fi
