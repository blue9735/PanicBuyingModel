# 导入库
import emoji
import re

# 打开文件
with open('后期安全类.txt',encoding='UTF-8') as f:
    data = f.read()
    
#print(emoji.demojize(data)) #测试一下成功没？以及看看emoji代码
content = re.sub('(\:.*?\:)', '', emoji.demojize(data))
print(content)
f = open(r'清理后-后期安全类.txt','w',encoding='utf-8')
print (content,file = f)
f.close()
