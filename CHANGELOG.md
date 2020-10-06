## 0.0.8
NEW FEATURES:
* Add custom volume size for concourse instance
* Update CoreOs AMI owners

## 0.0.7 (Unreleased)
## 0.0.6 (nn.03.2018)
BACKWARDS INCOMPATIBILITIES / NOTES:
* **Subnets must now be defined as array instead of A and B. The first SN will be used for individual ressource.**

NEW FEATURES:
* Generate random passwords for concourse and postgres if specified other
* Deploy a RDS instance for postgres instead of a container

IMPROVEMENTS:
* Allow to specify more then two subnetworks

BUG FIXES:
* None
