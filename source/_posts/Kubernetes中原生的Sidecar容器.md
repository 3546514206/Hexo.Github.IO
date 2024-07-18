---
title: Kubernetes中原生的Sidecar容器
date: 2024-07-18 15:10:17
tags:
- 云计算
---


#### __1、Sidecar容器的概念__

&ensp;&ensp;&ensp;&ensp; sidecar 容器的概念在 Kubernetes 早期就已经存在。多年来，sidecar 模式在应用程序中变得越来越普遍，使用场景也变得更加多样化。其中比较经典的就是 Istio 通过 sidecar 容器实现了服务网格的功能，Envoy 作为 sidecar 容器与应用程序容器一起运行，负责处理所有的网络流量，实现了服务之间的安全通信、流量管理、监控等功能。

![sidecar](/pic/Kubernetes中原生的Sidecar容器/sidecar.webp)

#### __2、当前Sidecar容器的问题__

&ensp;&ensp;&ensp;&ensp; 当前的 Kubernetes 原语可以很好地处理这种模式，但是对于几个用例来说，它们还存在着不足，并且迫使应用程序采用奇怪的变通方法。

#### __2.1、问题 1：使用 Sidecar 容器的 Job__

&ensp;&ensp;&ensp;&ensp; 假设你有一个 Job，其中包含两个容器：一个是用于执行作业的主容器，另一个只是完成辅助任务的 sidecar 容器。这个辅助容器可以是用于服务网格、收集指标或者日志的服务等等。当 Job 中的主容器完成任务退出时，由于 sidecar 容器还在运行，最终会导致 Pod 无法正常终止。此外，对于 restartPolicy:Never 的 Job，当 sidecar 容器因为 OOM 被杀死时，它不会被重新启动，如果 sidecar 容器为其他容器提供网络或者安全通信，这可能会导致 Pod 无法使用。

&ensp;&ensp;&ensp;&ensp; 下面我们可以通过一个简单的例子来演示这个问题。下面是一个 Job 的 YAML 文件，其中包含两个容器：一个是主容器 main-container-1，另一个是 sidecar 容器 sidecar-container-1。main-container-1 容器在完成一些任务后会正常退出，而 sidecar-container-1 容器会则一直运行。

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: myapp
spec:
  template:
    spec:
      containers:
        - name: main-container-1
          image: busybox:1.35
          command: ["sh", "-c"]
          args:
            - |
              echo "main container is starting..."
              for i in $(seq 1 5); do
                echo "main container is doing some task: $i/5"
                sleep 3
              done
              echo "main container completed tasks and exited"
        - name: sidecar-container-1
          image: busybox:1.35
          command: ["sh", "-c"]
          args:
            - |
              echo "sidecar container is starting..."
              while true; do
                echo "sidecar container is collecting logs..."
                sleep 1
              done
      restartPolicy: OnFailure
```

&ensp;&ensp;&ensp;&ensp; 执行以下命令应用上面的 Job 资源。

```sh
kubectl apply -f 1-job-cannot-complete.yaml
```

&ensp;&ensp;&ensp;&ensp; 在本文的实验中，我们会在一个 Pod 中同时运行多个容器，为了方便观察日志，我们可以使用 stern 这个开源工具。 stern 允许我们同时查看多个 Pod 中多个容器的日志，并且以不同颜色进行显示，方便我们直观地进行区分。

&ensp;&ensp;&ensp;&ensp; 执行以下命令查看 myapp Pod 中所有容器的日志：

```sh
# --diff-container 参数会为每个容器的日志添加不同的颜色，默认情况下，只会为每个 Pod 的日志添加不同的颜色
stern myapp --diff-container
```

&ensp;&ensp;&ensp;&ensp; 从日志中可以看到，main-container-1 容器完成任务后正常退出，而 sidecar-container-1 还在持续运行，最终导致这个 Job 无法正常结束。

![边车容器日志](/pic/Kubernetes中原生的Sidecar容器/边车容器日志.webp)

&ensp;&ensp;&ensp;&ensp; 如果我们提前在另一个窗口执行 kubectl get pod -w 命令，可以观察到 Pod 的状态变化如下：

```sh
NAME          READY   STATUS    RESTARTS   AGE
myapp-fdpb7   0/2     Pending   0          0s
myapp-fdpb7   0/2     Pending   0          0s
myapp-fdpb7   0/2     ContainerCreating   0          0s
myapp-fdpb7   2/2     Running             0          2s
myapp-fdpb7   1/2     NotReady            0          17s
```

&ensp;&ensp;&ensp;&ensp; 每行状态的解释如下，完整的 Pod 资源内容请查看 logs/1-job-cannot-complete-status.yaml 文件：

&ensp;&ensp;&ensp;&ensp; 1.Pod 创建后还未被调度，Pod 的 Phase 为 Pending。

```sh
status:
  phase: Pending
  qosClass: BestEffort
```

&ensp;&ensp;&ensp;&ensp; 2.Pod 已经被调度到 Node 上，但是容器还未被创建，Pod 的 Phase 还是 Pending。

```sh
status:
  conditions:
    - lastProbeTime: null
      lastTransitionTime: "2024-05-28T13:05:25Z"
      status: "True"
      type: PodScheduled # Pod 已经被调度到 Node 上
  phase: Pending
  qosClass: BestEffort
```

&ensp;&ensp;&ensp;&ensp; 3.正在等待创建容器，Pod 还没有处于 Ready 状态，Pod 的 Phase 仍为 Pending。

```sh
status:
  conditions:
    - lastProbeTime: null
      lastTransitionTime: "2024-05-28T13:05:25Z"
      status: "True"
      type: Initialized
    - lastProbeTime: null
      lastTransitionTime: "2024-05-28T13:05:25Z"
      message: 'containers with unready status: [main-container-1 sidecar-container-1]'
      reason: ContainersNotReady
      status: "False" # Pod 还没有处于 Ready 状态
      type: Ready
    - lastProbeTime: null
      lastTransitionTime: "2024-05-28T13:05:25Z"
      message: 'containers with unready status: [main-container-1 sidecar-container-1]'
      reason: ContainersNotReady
      status: "False"
      type: ContainersReady
    - lastProbeTime: null
      lastTransitionTime: "2024-05-28T13:05:25Z"
      status: "True"
      type: PodScheduled
  containerStatuses:
    - image: busybox:1.35
      imageID: ""
      lastState: {}
      name: main-container-1
      ready: false
      restartCount: 0
      started: false
      state:
        waiting: # 等待容器创建完成
          reason: ContainerCreating 
    - image: busybox:1.35
      imageID: ""
      lastState: {}
      name: sidecar-container-1
      ready: false
      restartCount: 0
      started: false
      state:
        waiting: # 等待容器创建完成
          reason: ContainerCreating
  hostIP: 172.19.0.2
  phase: Pending
  qosClass: BestEffort
  startTime: "2024-05-28T13:05:25Z"
```

&ensp;&ensp;&ensp;&ensp; 4.所有容器在运行中，Pod 的 Phase 变为 Running。

```sh
status:
  conditions:
    - lastProbeTime: null
      lastTransitionTime: "2024-05-28T13:05:25Z"
      status: "True"
      type: Initialized
    - lastProbeTime: null
      lastTransitionTime: "2024-05-28T13:05:27Z"
      status: "True"
      type: Ready
    - lastProbeTime: null
      lastTransitionTime: "2024-05-28T13:05:27Z"
      status: "True"
      type: ContainersReady
    - lastProbeTime: null
      lastTransitionTime: "2024-05-28T13:05:25Z"
      status: "True"
      type: PodScheduled
  containerStatuses:
    - containerID: containerd://af182325a9bb106697dc56f7ff25e96d6dd22d45eb134990d9c4820349c11232
      image: docker.io/library/busybox:1.35
      imageID: docker.io/library/busybox@sha256:469d6089bc898ead80a47dab258a127ffdae15342eab860be3be9ed2acdee33b
      lastState: {}
      name: main-container-1
      ready: true
      restartCount: 0
      started: true
      state:
        running: # 主容器在运行中
          startedAt: "2024-05-28T13:05:26Z"
    - containerID: containerd://fb24805ffe5ee1fddb64a728ee8853299f9c093b2722b77d54808d9821b90b0e
      image: docker.io/library/busybox:1.35
      imageID: docker.io/library/busybox@sha256:469d6089bc898ead80a47dab258a127ffdae15342eab860be3be9ed2acdee33b
      lastState: {}
      name: sidecar-container-1
      ready: true
      restartCount: 0
      started: true
      state:
        running: # sidecar 容器在运行中
          startedAt: "2024-05-28T13:05:26Z"
  hostIP: 172.19.0.2
  phase: Running
  podIP: 10.244.0.7
  podIPs:
    - ip: 10.244.0.7
  qosClass: BestEffort
  startTime: "2024-05-28T13:05:25Z"
```

&ensp;&ensp;&ensp;&ensp; 5.main-container-1 容器完成任务后正常退出，而 sidecar-container-1 还在持续运行，最终这个 Job 无法正常结束。

```sh
status:
  conditions:
    - lastProbeTime: null
      lastTransitionTime: "2024-05-28T13:05:25Z"
      status: "True"
      type: Initialized
    - lastProbeTime: null
      lastTransitionTime: "2024-05-28T13:05:42Z"
      message: 'containers with unready status: [main-container-1]'
      reason: ContainersNotReady
      status: "False"
      type: Ready
    - lastProbeTime: null
      lastTransitionTime: "2024-05-28T13:05:42Z"
      message: 'containers with unready status: [main-container-1]'
      reason: ContainersNotReady
      status: "False"
      type: ContainersReady
    - lastProbeTime: null
      lastTransitionTime: "2024-05-28T13:05:25Z"
      status: "True"
      type: PodScheduled
  containerStatuses:
    - containerID: containerd://af182325a9bb106697dc56f7ff25e96d6dd22d45eb134990d9c4820349c11232
      image: docker.io/library/busybox:1.35
      imageID: docker.io/library/busybox@sha256:469d6089bc898ead80a47dab258a127ffdae15342eab860be3be9ed2acdee33b
      lastState: {}
      name: main-container-1
      ready: false
      restartCount: 0
      started: false
      state:
        terminated: # 主容器已经正常退出
          containerID: containerd://af182325a9bb106697dc56f7ff25e96d6dd22d45eb134990d9c4820349c11232
          exitCode: 0
          finishedAt: "2024-05-28T13:05:41Z"
          reason: Completed
          startedAt: "2024-05-28T13:05:26Z"
    - containerID: containerd://fb24805ffe5ee1fddb64a728ee8853299f9c093b2722b77d54808d9821b90b0e
      image: docker.io/library/busybox:1.35
      imageID: docker.io/library/busybox@sha256:469d6089bc898ead80a47dab258a127ffdae15342eab860be3be9ed2acdee33b
      lastState: {}
      name: sidecar-container-1
      ready: true
      restartCount: 0
      started: true
      state:
        running: # sidecar 容器还在继续运行
          startedAt: "2024-05-28T13:05:26Z"
  hostIP: 172.19.0.2
  phase: Running
  podIP: 10.244.0.7
  podIPs:
    - ip: 10.244.0.7
  qosClass: BestEffort
  startTime: "2024-05-28T13:05:25Z"
```

&ensp;&ensp;&ensp;&ensp; 下面这张图展示了上面描述的 Pod 状态变化过程：

![Pod 状态变化过程](/pic/Kubernetes中原生的Sidecar容器/Pod状态变化过程.webp)

&ensp;&ensp;&ensp;&ensp; 这里有几个地方需要解释一下，在我们观察容器和 Pod 的状态时，Kubernetes 提供了一些字段来帮助我们理解 Pod 的状态：

&ensp;&ensp;&ensp;&ensp; __Pod phase:__ Pod phase 是对 Pod 在其生命周期中所处位置的一个高层次的概括，包括 Pending、Running、Succeeded、Failed 和 Unknown。

* Pending：Pod 已被 Kubernetes 系统接受，但有一个或者多个容器尚未被创建。此阶段包括等待 Pod 被调度的时间和通过网络下载镜像的时间。

* Running：Pod 中的所有容器都已经被创建，并且至少有一个容器正在运行，或者正在启动或者重启。

* Succeeded：Pod 中的所有容器都已经成功终止，并且不会再重启。

* Failed：Pod 中的所有容器都已经终止，但至少有一个容器是因为失败而终止。

* Unknown：Pod 的状态无法被获取，通常是由于与 Pod 应该运行的节点通信失败导致的。

&ensp;&ensp;&ensp;&ensp; __Container states:__ 容器的状态，包括 Waiting、Running 和 Terminated。我在上图右边部分的方框中用不同的颜色标记了这三种 Container states，另外在括号内部还对相同 Container states 的不同情况作了区分。

* Waiting：容器正在等待某些条件满足，例如正在拉取镜像，或者应用 Secret 数据。

* Running：容器正在运行中。

* Terminated：容器已经终止，可能是正常结束或者因为某些原因失败。如果你使用 kubectl describe pod 或者 kubectl get pod 命令来查询包含 Terminated 状态的容器的 Pod 时， 你会看到容器进入此状态的原因、退出代码以及容器执行期间的起止时间。

&ensp;&ensp;&ensp;&ensp; __Pod Status：__ 在执行 kubectl get pod 命令时返回的 Pod 状态，该字段是 Pod 内所有容器状态的一个聚合，具体的源代码参见 printPod 函数.有以下几个常见的状态：

* Init:N/M：Pod 包含 M 个 init 容器，其中 N 个已经运行完成。

* Init:Error：Pod 中的某个 init 容器执行失败。

* Init:CrashLoopBackOff：Pod 中的某个 init 容器多次失败。

* Pending：Pod 尚未开始创建 init 容器。

* PodInitializing：Pod 已经执行完所有 init 容器，在等待创建主容器。

* ContainerCreating：当 Pod 中不包含 init 容器时，在等待创建主容器时会显示这个状态。

* Running：Pod 中的所有容器都在运行中。

&ensp;&ensp;&ensp;&ensp; __Pod Ready：__ 以 Ready 的容器数量 / 所有容器的数量的形式展示。

&ensp;&ensp;&ensp;&ensp; 测试完毕后，执行以下命令删除这个 Job。

```sh
kubectl delete -f 1-job-cannot-complete.yaml
```

















