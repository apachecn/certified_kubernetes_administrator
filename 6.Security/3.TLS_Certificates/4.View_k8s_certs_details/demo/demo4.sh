master $ pwd
/etc/kubernetes/manifests
master $

master $ cat etcd.yaml
  apiVersion: v1
  kind: Pod
  metadata:
    creationTimestamp: null
    labels:
      component: etcd
      tier: control-plane
    name: etcd
    namespace: kube-system
  spec:
    containers:
      - command:
          - etcd
          - --advertise-client-urls=https://172.17.0.17:2379
          - --cert-file=/etc/kubernetes/pki/etcd/server-certificate.crt
          - --client-cert-auth=true
          - --data-dir=/var/lib/etcd
          - --initial-advertise-peer-urls=https://172.17.0.17:2380
          - --initial-cluster=master=https://172.17.0.17:2380
          - --key-file=/etc/kubernetes/pki/etcd/server.key
          - --listen-client-urls=https://127.0.0.1:2379,https://172.17.0.17:2379
          - --listen-metrics-urls=http://127.0.0.1:2381
          - --listen-peer-urls=https://172.17.0.17:2380
          - --name=master
          - --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
          - --peer-client-cert-auth=true
          - --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
          - --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
          - --snapshot-count=10000
          - --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
        image: k8s.gcr.io/etcd:3.3.15-0
        imagePullPolicy: IfNotPresent
        livenessProbe:
          failureThreshold: 8
          httpGet:
            host: 127.0.0.1
            path: /health
            port: 2381
            scheme: HTTP
          initialDelaySeconds: 15
          timeoutSeconds: 15
        name: etcd
        resources: {}
        volumeMounts:
          - mountPath: /var/lib/etcd
            name: etcd-data
          - mountPath: /etc/kubernetes/pki/etcd
            name: etcd-certs
    hostNetwork: true
    priorityClassName: system-cluster-critical
    volumes:
      - hostPath:
          path: /etc/kubernetes/pki/etcd
          type: DirectoryOrCreate
        name: etcd-certs
      - hostPath:
          path: /var/lib/etcd
          type: DirectoryOrCreate
        name: etcd-data
  status: {}
master $
