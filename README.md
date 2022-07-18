# Galactus - unused GCP Service Account/Key detector

This script uses GCP's [Policy Analyzer](https://cloud.google.com/policy-intelligence/docs/activity-analyzer-service-account-authentication) feature to detect unused Service Accounts (SA) or Service Account Keys (SAK).

## Prerequisites
- [gcloud](https://cloud.google.com/sdk/docs/install) installed and in PATH
- Python 3
- Enabling the [Policy Analyzer API](https://cloud.google.com/policy-intelligence/docs/activity-analyzer-service-account-authentication#before-you-begin)

## Script arguments

```bash
$ ./galactus --help
usage: galactus [-h] -p PROJECT -a ACTIVITY_TYPE [-l LIMIT] -t THRESHOLD [-d]

Unused GCP Service Account and Key detector

options:
  -h, --help            show this help message and exit
  -p PROJECT, --project PROJECT
                        GCP Project name
  -a ACTIVITY_TYPE, --activity-type ACTIVITY_TYPE
                        Activity type (serviceAccountLastAuthentication / serviceAccountKeyLastAuthentication)
  -l LIMIT, --limit LIMIT
                        Result limit
  -t THRESHOLD, --threshold THRESHOLD
                        Date threshold in format "%Y-%m-%dT%H:%M:%SZ"
  -d, --debug           Enable debug logging
```

### Using environment variables

The following environment variable can be used instead of command line arguments (arguments take precedence):
- GCP_PROJECT - instead of -p/--project
- ACTIVITY_TYPE - instead of -a/--activity-type
- THRESHOLD - instead of -t/--threshold
- DEBUG - instead of -d/--debug

## Examples

Find SA that were not used since before 1.5.2022:

```bash
$ ./galactus -p test-eyal -t 2022-05-01T00:00:00Z -a serviceAccountLastAuthentication
2022-07-15 17:35:25,078 - INFO - //iam.googleapis.com/projects/test-eyal/serviceAccounts/crossplane-test@test-eyal.iam.gserviceaccount.com - last used 2022-02-28T08:00:00Z
```

Find SAK that were not used since before 28.2.2022 at 10AM:

```bash
$ ./galactus -p test-eyal -t 2022-02-28T10:00:00Z -a serviceAccountKeyLastAuthentication
2022-07-15 17:36:52,823 - INFO - //iam.googleapis.com/projects/test-eyal/serviceAccounts/crossplane-test@test-eyal.iam.gserviceaccount.com/keys/b2edfc3fc441c9937c0c2e0da2b1345d57a02abb - last used 2022-02-28T08:00:00Z

```
