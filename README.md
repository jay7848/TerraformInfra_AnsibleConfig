# TravelMemory on AWS — Terraform + Ansible (Ready-to-Run)

This bundle creates a 2-tier MERN deployment:
- **Web/App EC2 (public subnet)** — serves React and Node/Express
- **MongoDB EC2 (private subnet)** — only reachable from Web via port **27017**

> **Region:** `us-west-2` (change in `terraform/variables.tf` if needed)

---

## 🔑 Key Pair Name (.ppk)
- The AWS **Key Pair name** used by EC2 is **`Jay-TravelMemoryApp-keypair`**.
- Inventory paths reference a **local** file named **`Jay-TravelMemoryApp-keypair.ppk`**.
- **Note**: Ansible uses OpenSSH; `.ppk` is a PuTTY key. If you only have `.ppk`, convert it to PEM:
  - With PuTTYgen: *Conversions → Export OpenSSH key* → save as `Jay-TravelMemoryApp-keypair.pem` and update the `ansible_ssh_private_key_file` paths in `ansible/inventory.ini` accordingly.
  - Or install `putty-tools` and run: `puttygen Jay-TravelMemoryApp-keypair.ppk -O private-openssh -o Jay-TravelMemoryApp-keypair.pem`

If you already created a different AWS Key Pair, update `variable "key_name"` in `terraform/variables.tf`.

---

## 🚀 Deploy

### 1) Terraform (VPC, Subnets, NAT, SGs, EC2)
```bash
cd terraform
terraform init
terraform plan -out tfplan
terraform apply -auto-approve
```
Copy the outputs: `web_public_ip`, `db_private_ip`.

### 2) Ansible (MongoDB, Node/Nginx, App)
Edit `ansible/inventory.ini`:
- Replace `WEB_PUBLIC_IP` with the Terraform output.
- Replace `DB_PRIVATE_IP` with the Terraform output.
- If you converted to PEM, update the key file paths.

Then run:
```bash
cd ../ansible
ansible all -m ping
ansible-playbook site.yml
```

Open the app in a browser:
```
http://WEB_PUBLIC_IP
```

---

## 🗂 Project Layout
```
tm-infra/
├─ terraform/            # VPC, NAT, SGs, EC2, IAM SSM
└─ ansible/              # MongoDB, Node/Nginx/PM2, app deploy
```

---

## 🧹 Clean Up (avoid NAT charges)
```bash
cd terraform
terraform destroy -auto-approve
```

---

## ⚠️ Security Notes
- SSH (22) to Web restricted by `my_ip_cidr` (set your IP/32 in `variables.tf`).
- DB has **no public IP**, 27017 allowed only from Web SG.
- Mongo **auth enabled**; app user has least-privilege.
- UFW enabled on hosts; HTTP allowed on Web, SSH for admin.

---

## 🔧 Adjustments
- App paths (frontend/backend) are set for `client` / `server`. If the repo differs, change `frontend_dir` / `backend_dir` in `ansible/inventory.ini`.
- Region/instance types in `terraform/variables.tf`.
