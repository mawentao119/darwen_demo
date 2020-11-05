# -*- coding: utf-8 -*-

__author__ = "chairsma"

# 通过 RobotFrameWork 封装 curl 命令发起 API 测试请求 
# 通过 jmespath 模块实现结果的 查找与对比
# 外部需求：需要连接数据库取得用户id和key，如果无法连接，可以在 get auth 中根据用户名直接给
# ！！此模块主要实现动态变量的生成，生成env.conf
#

from robot.api import logger

import subprocess
import json
import jmespath

def _runshellcommand(cmd):
    ''' return (resultcode, stdout, stderr) with stdout and stderr decoded .'''
    res = subprocess.run(cmd, shell=True, capture_output=True)
    return ( res.returncode, res.stdout.decode(), res.stderr.decode() )

def curl(*varargs):
    ''' 根据测试用例中的参数 组装 curl 命令
        默认加 -s 参数 忽略 -v 参数
        如果是 https 默认加 -k 参数
    '''
    cmd = 'curl -s '   # 默认使用 -s 参数，为了便于结果处理，可以拷贝 log.html 中的命令，改为 -v参数
    logger.info(varargs)
    for arg in varargs:
        logger.debug("*ARG:"+arg)
        if arg.startswith('-v'):
            arg = ''
            logger.warn(" '-v' cannot use in cases , change to -s ")
        if arg.startswith('-k'):
            arg = ''
            logger.debug(" ignor -k, if it is https ,then -k is default .")
        if arg.startswith('https') or arg.startswith("'https"):
            arg = '-k ' + arg
            logger.debug(" ignor -k, if it is https ,then -k is default .")
        if arg.startswith('-s'):
            arg = ''
        cmd += arg + ' ' 
    logger.info("**CURL: "+cmd)
    (resultcode, output, err) = _runshellcommand(cmd)
    if resultcode != 0:
        logger.error("Curl command ERR:"+err)
        logger.error("Curl command Output:"+output)
        return ''
    logger.debug("RES:" + output)
    return output

def expect_json(result, item, exp, exptype='str'):
    ''' 
       将测试结果转化成 json 通过 jmespath 进行解析， 与测试用例中的预期进行对比 
       目前支持的预期结果类型： str and unicode(默认)、int、float 因为jmespath抽取后就这三种类型 
    '''

    if not (exptype == 'str' or exptype == 'int' or exptype == 'float' or exptype == 'unicode') :
        logger.error("Not support Compare type:"+ exptype + ". Please Use: str,int,float")
        return False

    rjs = json.loads(result)
    r_val = jmespath.search(item,rjs)
    logger.info("Expect: "+item+":"+exp+" >> "+str(r_val))
    if r_val is None:
        logger.error("Not Found result: " + item)
        return False

    exp_val = None

    if exptype == 'str' or exptype == 'unicode':
        exp_val = str(exp)
    if exptype == 'int':
        exp_val = int(exp)
    if exptype == 'float':
        exp_val = float(exp)
   
    if type(r_val) != type(exp_val) :
        logger.error("Result Type VS Expect Type: " + str(type(r_val)) + " VS " + str (type(exp_val)) )
        return False
    if r_val != exp_val:
        logger.error("Result Value VS Expect Value: " + str(r_val) + " VS " + str(exp_val) )
        return False
    return True

def get_result(result,item,exptype='str'):
    '''返回json内的特定内容，保存结果给下一次请求使用，暂支持str返回，后续考虑扩展 '''
    rjs = json.loads(result)
    r_val = jmespath.search(item,rjs)
    if exptype == 'list':
    	return list(r_val)
    return str(r_val)

if __name__ == '__main__':
    ''' some test code '''
    
    print("something")
