# APP
#### **An app for MAXUS**

##### 2023.08.07修改记录：

- 修改了模型校核界面，但未完成；

##### 2023.08.08修改记录：

- 仍然是模型校核界面，做起来真费劲；
- 电机以及电池上传的文件需要统一命名，不然无法寻找；可以后续再改进

##### 2023.08.09修改记录：

- 所有的电机、电池数据文件必须一致，不然运行起来可能有错误；
- 明天要继续修改GA_Motor & GA_Batt;

##### 2023.08.12修改记录：

- 模型校核部分基本上已经完成了；
- 后续和最优策略部分结合起来就okay了。

##### 2023.08.16修改记录：

- 部分完成了模型集成；
- 存在的问题主要是软件中算法相对路径的修改。

##### 2023.08.22修改记录：

- 发现了模型校核部分的问题，主要是因为之前开发算法时未把驱动与制动分开，在数据处理部分，就将电流小于0的地方全等于0了，所以误差会有点大；
- 明天修改这一部分，就差不多了。

##### 2023.08.23修改记录：

- 功能基本上完成；
- 只有校核结果没有那么满意，有可能还需要继续调，但是已经比未校核的结果好了很多；
- 需要进一步检查代码中是不是用了预设值好的参数，需要将其与用户输入的值进行替换。