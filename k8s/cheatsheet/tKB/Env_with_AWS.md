Setting up the Env on AWS Using AGC Playgrounds
===============================================

1. Create a Playground
2. Login
3. Create a eks cluster service
   * While creating it, you should also create an IAM role for it
      * The service is **EKS**
      * The use case is **EKS Cluster**
      * The permissions policy for this is **AmazonEKSClusterPolicy**
4. Create a Node group
   * choose *t3.medium* as the size for nodes
   * While creating the node group you should also create a IAM role for it
      * Roles service is **EC2**
      * The following are the permissions policies attached to the role
         * **AmazonEC2ContainerRegistryReadOnly**
         * **AmazonEKS_CNI_Policy**
         * **AmazonEKSWorkerNodePolicy**
5. Go to *IAM* --> *Users* --> *cloud_user* --> *Security Credentials* tab --> *Access Keys* --> *Create access key* --> Download the file
6. on terminal type: `aws configure` and enter the Credentials from the previous step
7. The following command to add the cluster into your `kubeconfig`
```
aws eks update-kubeconfig --region <region> --name <name>
```
8. Type in the following to check the connection:
```
kubectl get nodes
```
x
- To get the current clusters
```
kubectl config get-clusters
```

- To delete specific cluster
```
kubectl config delete-cluster <NAME>
```
