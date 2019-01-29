部署kubernetes服务

##先将环境中多余的服务删除
```bash
[root@mini3 service-config]# kubectl get services
NAME             TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
api-gateway      NodePort    10.68.37.239   <none>        80:80/TCP           55m
course-service   ClusterIP   10.68.228.81   <none>        8081/TCP            56m
kubernetes       ClusterIP   10.68.0.1      <none>        443/TCP             5d
user-service     ClusterIP   10.68.83.59    <none>        8082/TCP,7911/TCP   56m
[root@mini3 service-config]# kubectl delete svc user-service
service "user-service" deleted

```
##删除deploy
```bash
[root@mini3 service-config]# kubectl get deploy
NAME                        DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
api-gateway-deployment      1         1         1            1           57m
course-service-deployment   1         1         1            1           57m
user-service-deployment     1         1         1            1           58m
[root@mini3 service-config]# kubectl delete deploy user-service-deployment
deployment "user-service-deployment" deleted

##删除pods
```
[root@mini3 service-config]# kubectl get pods
NAME                                         READY     STATUS    RESTARTS   AGE
api-gateway-deployment-6f777f84d7-6qbzk      1/1       Running   0          58m
course-service-deployment-66dd5bd4c4-5qnzc   2/2       Running   0          58m
[root@mini3 service-config]# kubectl delete pods <podName>

```bash

```

```bash
#创建服务
kubectl apply -f message-service.yaml

kubectl apply -f user-service.yaml

kubectl apply -f course-service.yaml

kubectl apply -f api-gateway.yaml
```

```bash
# 查看服务列表
[root@mini3 service-config]# kubectl get svc
NAME             TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
api-gateway      NodePort    10.68.37.239   <none>        80:80/TCP           1m
course-service   ClusterIP   10.68.228.81   <none>        8081/TCP            1m
kubernetes       ClusterIP   10.68.0.1      <none>        443/TCP             5d
user-service     ClusterIP   10.68.83.59    <none>        8082/TCP,7911/TCP   2m

```

```bash
#查看deploy
[root@mini3 service-config]# kubectl get deploy
NAME                        DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
api-gateway-deployment      1         1         1            1           14m
course-service-deployment   1         1         1            1           14m
user-service-deployment     1         1         1            1           15m
#查看pods
[root@mini3 service-config]# kubectl get pods -o wide
NAME                                         READY     STATUS    RESTARTS   AGE       IP             NODE
api-gateway-deployment-6f777f84d7-6qbzk      1/1       Running   0          14m       172.20.55.74   192.168.252.32
course-service-deployment-66dd5bd4c4-5qnzc   2/2       Running   0          14m       172.20.55.73   192.168.252.32
user-service-deployment-95b8d7897-mh9q4      2/2       Running   0          15m       172.20.55.76   192.168.252.32

```

## 查看发布的服务的日志
#### 查看只有一个container的日志
kubectl logs <podName>
```bash
#查看pods
[root@mini3 service-config]# kubectl get pods -o wide
#查看只有一个image的日志
[root@mini3 service-config]# kubectl logs api-gateway-deployment-6f777f84d7-6qbzk 
2019-01-29 15:14:07.918  INFO 1 --- [           main] s.c.a.AnnotationConfigApplicationContext : Refreshing org.springframework.context.annotation.AnnotationConfigApplicationContext@72e907ca: startup date [Tue Jan 29 15:14:07 UTC 2019]; root of context hierarchy
2019-01-29 15:14:11.640  INFO 1 --- [           main] f.a.AutowiredAnnotationBeanPostProcessor : JSR-330 'javax.inject.Inject' annotation found and supported for autowiring
2019-01-29 15:14:12.122  INFO 1 --- [           main] trationDelegate$BeanPostProcessorChecker : Bean 'configurationPropertiesRebinderAutoConfiguration' of type [org.springframework.cloud.autoconfigure.ConfigurationPropertiesRebinderAutoConfiguration$$EnhancerBySpringCGLIB$$b01194d8] is not eligible for getting processed by all BeanPostProcessors (for example: not eligible for auto-proxying)

```
#### 查看有多个container的pod的日志
kubectl logs <podName> <containerName>
```bash
#查看pods
[root@mini3 service-config]# kubectl get pods -o wide
[root@mini3 service-config]# kubectl logs course-service-deployment-66dd5bd4c4-5qnzc course-service
java.net.ConnectException: Connection refused
	at sun.nio.ch.SocketChannelImpl.checkConnect(Native Method) ~[na:1.7.0_181]
	at sun.nio.ch.SocketChannelImpl.finishConnect(SocketChannelImpl.java:744) ~[na:1.7.0_181]
	at org.apache.zookeeper.ClientCnxnSocketNIO.doTransport(ClientCnxnSocketNIO.java:361) ~[zookeeper-3.4.6.jar!/:3.4.6-1569965]
	at org.apache.zookeeper.ClientCnxn$SendThread.run(ClientCnxn.java:1081) ~[zookeeper-3.4.6.jar!/:3.4.6-1569965]

```

##查看发布结果

登录：  
http://192.168.252.32/user/login   返回{"code":"0","message":"success","token":"zs9rxbkzovj4xy722ofgzrahax4izhjw"}  
访问课程服务：  
http://192.168.252.32/course/courseList?token=zs9rxbkzovj4xy722ofgzrahax4izhjw