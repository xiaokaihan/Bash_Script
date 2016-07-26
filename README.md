# Bash_Script
bash script practice
is_today_trading_day.sh:

该脚本的功能是：判断当天是否为节假日。

运行脚本：./is_today_trading_day.sh MA（或HK） 

具体实现为： 
		① 首先在脚本的开头， 配置环境变量，以及bash脚本和sql脚本的绝对路径；
		
		② 在运行脚本时，传入一个市场的参数（MA或HK），且脚本会自动获取当前日期（日期格式为：yyyyMMdd）；
		
		③ 将市场的参数和当前日期， 传入到sql脚本中， 在对应的数据库表中进行查询，并将查询结果以字符串的方式返回；
		
		④ 接着对查询结果字符串进行grep操作，若字符串包含"HOLIDAY=Y"子串， 则表示当天为节假日，标记为：STATUS=SKIP；
			若字符串包含"HOLIDAY=N"子串， 则表示当天不为节假日，标记为：STATUS=PROCEED；
			否则表示bash脚本或者sql脚本出错，标记为：STATUS=ERROR；
			
		⑤ 最后判断["$STATUS" = "PROCEED" ]，
			结果为true，则exit 0，表示正常运行程序并退出程序，可以继续执行后面的程序；
			否则exit 1，表示非正常运行导致退出程序，不会再执行后面的程序。
