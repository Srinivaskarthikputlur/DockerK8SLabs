# **Vault**

---

> #### Dynamic Secrets with Vault

### **Lab Image : Kubernetes**

---

#### Step 1:

* Navigate to the `Vault` directory on the provisioned server.

```commandline
cd /root/container-training/Kubernetes/Vault
```

---

#### Step 2:

* Deploy the Vault service

```commandline
kubectl create -f vault.yaml
```
```commandline
kubectl get deployment
```
```commandline
kubectl get svc
```

> **NOTE**: `Vault root key` has been set to `vault-root-token`. It should ideally be something a LOT stronger

---

#### Step 3:

* Set the IP of the `Vault` service as an Environment variable

```commandline
VaultIP=http://$(kubectl get svc vault -o yaml | grep "clusterIP" |awk '{print $2}'):8200
```
```commandline
echo $VaultIP
```

> **NOTE**: Vault is available on `http://vault:8200` for other k8s pods

---

#### Step 4:

* Login to `Vault`

```commandline
vault login -address $VaultIP vault-root-token
```

* Create a Root CA that expires in a year and generate the root cert.

```commandline
vault secrets enable -address $VaultIP  -path=root-ca -max-lease-ttl=8760h pki
```
```commandline
vault write -address $VaultIP root-ca/root/generate/internal common_name="Root CA" ttl=8760h exclude_cn_from_sans=true
```

* Setup URLs on Vault

```commandline
vault write -address $VaultIP root-ca/config/urls issuing_certificates="http://vault:8200/v1/root-ca/ca" crl_distribution_points="http://vault:8200/v1/root-ca/crl"
```

---

#### Step 5:

* Create the Intermediate CA that expires in 180 days

```commandline
vault secrets enable -address $VaultIP -path=intermediate-ca -max-lease-ttl=4320h pki
```

* Generate a Certificate Signing Request and ask the Root to sign it

```commandline
vault write -address $VaultIP -format=json intermediate-ca/intermediate/generate/internal common_name="Intermediate CA" ttl=4320h exclude_cn_from_sans=true | jq -r .data.csr > intermediate.csr
```
```commandline
vault write -address $VaultIP -format=json root-ca/root/sign-intermediate csr=@intermediate.csr use_csr_values=true exclude_cn_from_sans=true format=pem_bundle | jq -r .data.certificate | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' > signed.crt
```

* Send the Signed certificate back to Vault and Setup the URLs

```commandline
vault write -address $VaultIP intermediate-ca/intermediate/set-signed certificate=@signed.crt
```
```commandline
vault write -address $VaultIP intermediate-ca/config/urls issuing_certificates="http://vault:8200/v1/intermediate-ca/ca" crl_distribution_points="http://vault:8200/v1/intermediate-ca/crl"
```

---

#### Step 6:

* Enable the AppRole backend on Vault

```commandline
vault auth enable -address $VaultIP approle
```

* Create a role to allow Kubernetes-Vault to generate certificates and send the policy to Vault

```commandline
vault write -address $VaultIP intermediate-ca/roles/kubernetes-vault allow_any_name=true max_ttl="24h"
```
```commandline
vault policy write -address $VaultIP kubernetes-vault policy-kubernetes-vault.hcl
```

* Create a token role for Kubernetes-Vault that generates a 6 hour periodic token and generate token for Kubernetes-Vault and AppID

```commandline
vault write -address $VaultIP auth/token/roles/kubernetes-vault allowed_policies=kubernetes-vault period=6h
```
```commandline
CLIENTTOKEN=$(vault token-create -address $VaultIP -format=json -role=kubernetes-vault | jq -r .auth.client_token)
```
```commandline
echo $CLIENTTOKEN
```

---

#### Step 7:

* In `kubernetes-vault.yaml` on `line 54`, replace the value of the token with that of `$CLIENTTOKEN` fetched in the last step.

```commandline
sed -i -e 's/Replace_with_$CLIENTTOKEN_Here/'"$CLIENTTOKEN"'/g' kubernetes-vault.yaml
```
**EXAMPLE:**

```yaml
  kubernetes-vault.yml: |-
    vault:
      addr: http://vault:8200
      token: s.5mEiuuaZoSUyfpZ6WC16mrCX
```

* Create the deployment
```commandline
kubectl create -f kubernetes-vault.yaml
```

* Set up an app-role for sample-app that generates a periodic 6 hour token and add new rules to kubernetes-vault policy

```commandline
vault write -address $VaultIP auth/approle/role/sample-app secret_id_ttl=90s period=6h secret_id_num_uses=1 policies=kubernetes-vault,default
```
```commandline
vault policy write -address $VaultIP kubernetes-vault policy-sample-app.hcl
```

* Get the Apps role-id

```commandline
VAULT_ROLE_ID=$(vault read -address $VaultIP -format=json auth/approle/role/sample-app/role-id | jq -r .data.role_id)
```
```commandline
echo $VAULT_ROLE_ID
```

---

#### Step 8:

* In `sample-app.yaml` on `line 27`, replace the value of `VAULT_ROLE_ID` with the value of `$VAULT_ROLE_ID` fetched in the previous step.

```commandline
echo $VAULT_ROLE_ID
```
```commandline
sed -i -e 's/Replace_with_$VAULT_ROLE_ID_Value_Here/'"$VAULT_ROLE_ID"'/g' sample-app.yaml
```

**EXAMPLE:**

```yaml
  imagePullPolicy: Always
    env:
      - name: VAULT_ROLE_ID
        value: 23c14dda-11d7-054d-bc7a-5e4fc044c946
```

* Create the deployment

```commandline
kubectl apply -f sample-app.yaml
```

* Observe the logs of each `sample-app` pod once it's `Running`. It can be seen that each pod receives a unique token from vault.

```commandline
kubectl get pods
```
```commandline
kubectl logs <sample-app-xxxxxxxx>
```

---

#### *Teardown*:

* Stop all the deployments and services created

```commandline
kubectl delete -f vault.yaml -f kubernetes-vault.yaml -f sample-app.yaml
```

---

### Reading Material/References:

