# Sections

   ## Table of Contents
   - [Solution Overview](#solution-overview)
   - [Salesforce Project Deployment Guide](#salesforce-project-deployment-guide)

# Solution Overview

## Data Model Changes

1. The **Account** object was modified with an additional field:
   * **Domain** (`Domain__c`): A text field to hold the domain name extracted from the Website field.
   
2. The **Lead** object was modified with two additional fields:
   * **Account** (`Account__c`): A lookup field to the Account object.
     * Designed to create a relationship between the Account and Lead objects.
   * **isMatchedAutomatically** (`isMatchedAutomatically__c`): A number field.
     * Designed to hold values of 0 or 1, representing false or true, respectively.



# Salesforce Project Deployment Guide

This guide will help you deploy the Salesforce project files from this repository to your own Salesforce org.

## Prerequisites

Before you begin, ensure you have the following:

- **Salesforce CLI (`sf` or `sfdx`)**: [Download and install the Salesforce CLI](https://developer.salesforce.com/tools/sfdxcli).
- **Git**: [Download and install Git](https://git-scm.com/downloads).
- **A Salesforce Developer Org or Sandbox**: Ensure you have an appropriate Salesforce org to deploy the metadata.

## Step 1: Clone the Repository

1. **Open your terminal.**
2. **Navigate to the directory** where you want to clone the repository.
3. **Run the following command** to clone the repository:

   ```bash
   git clone https://github.com/madaraDance/AivenInterviewAssignment.git
   ```

4. **Navigate into the cloned repository**:
   
   ```bash
   cd AivenInterviewAssignment
   ```

## Step 2: Authenticate to Salesforce

1. **Run the following command** to log in to your Salesforce org:
   
   1.1 **For a production or developer org**:
   ```bash
      sfdx auth:web:login --set-default --alias MyDefaultOrg
   ```
   1.2 **For a sandbox org**:

   ```bash
      sfdx auth:web:login --set-default --alias MyDefaultOrg --instanceurl https://test.salesforce.com
   ```

   2. **This command will open a browser window for you to log into Salesforce**. After logging in, the org will be set as your default org and will be associated with the alias MyDefaultOrg.


2. **Select the appropriate Salesforce environment** (Production, Sandbox, or Developer Edition) during login.

## Step 3: Deploy the Metadata to Your Org

1. **Run the following command** to deploy the metadata:
   ```bash
   sf project deploy start --source-dir force-app
   ```
2. **Wait for the deployment to complete.** The CLI will display the deployment status and any errors or warnings that occur.

## Step 4: Verify the Deployment
1. **Log in to your** Salesforce org.
2. **Navigate to Setup to check** that the custom fields, triggers, classes, and other components have been deployed successfully.
3. **Test the functionality** to ensure everything is working as expected.

   3.1 One way to test is to **Navigate to Developer Console**.

   3.2 In the upper navigation menu, **click on "Test" and select "Run All"** from the dropdown.

   3.3 After the tests have executed, **click on the "Tests" tab in the bottom menu**.

   3.4 **Open the First Folder and ensure**:
      * **DomainExtractorTest class** has **2 tests passed**.
      * **LeadTriggerhandlerTest class** has **6 tests passed**.




