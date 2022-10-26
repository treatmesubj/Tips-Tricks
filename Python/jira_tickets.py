import pandas as pd
import os
import re
# https://github.com/ankitpokhrel/jira-cli
# API token auth: https://jsw.ibm.com/plugins/servlet/de.resolution.apitokenauth/admin
# Installation type: Local
# Jira Server: https://jsw.ibm.com
# config: C:\Users\JohnHupperts/.config/.jira/.config.yml
# $env:JIRA_API_TOKEN = "blahblah"
# $env:JIRA_AUTH_TYPE = "bearer"
# f.write("$myshell = New-Object -com \"Wscript.Shell\"\n")
# f.write("\n$myshell.sendkeys(\"{ENTER}\")\n")


def ps_cmd(command):
	os.system(f"{command} > tmp")
	std_out = open('tmp', 'r').read()
	os.remove('tmp')
	return std_out


def log_stuff(text):
	with open('./log.txt', 'a') as f:
		f.write(f"{text}\n")


def run_and_log_cmd(command):
	log_stuff(command); print(command)
	print("[hit ENTER]"); std_out = ps_cmd(command)
	reggy = re.search(r"(http|ftp|https):\/\/([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])", std_out)
	log_stuff(reggy.group()); print(reggy.group(), "\n")
	issue = reggy.group().split("/")[-1]
	return issue


if __name__ == "__main__":
	df = pd.read_excel("./simple_wip_jira_tickets.xlsx", sheet_name="Sheet1", dtype=str, header=1).fillna("")

	for row in df.index: # rows
		row_dict = {col: df.loc[row][col].replace('\n', ' | ').replace("_x000B_", " ") for col in df.columns}
		
		epic_cmd = f"jira epic create --name \"{row_dict['Jira Epic Title']}\" --summary \"{row_dict['Jira Epic Title']}\" --body \"{row_dict['Comments']}\""
		epic = run_and_log_cmd(epic_cmd)
		
		spec_cmd = f"jira issue create --type Story --summary \"Specification\" --body \"Data Owner: {row_dict['Data Owner']} | Data Source: {row_dict['Data Source']} | Data Fields: {row_dict['Data Fields']} | Metric Calculation: {row_dict['Metric Calculation']}\" --parent {epic}"
		run_and_log_cmd(spec_cmd)

		cos_cmd = f"jira issue create --type Story --summary \"Ingest into COS\" --body \"Tehnical Design, COS details, etc.\" --parent {epic}"
		run_and_log_cmd(cos_cmd)

		rdb_cmd = f"jira issue create --type Story --summary \"Ingest into Reporting DB\" --body \"Create DB2 Schema, DMT, etc.\" --parent {epic}"
		run_and_log_cmd(rdb_cmd)

		apr_cmd = f"jira issue create --type Story --summary \"Review & Approve Data\" --body \"Data Accountability Sign Off: {row_dict['Data Accountability Sign Off']}\" --parent {epic}"
		run_and_log_cmd(apr_cmd)

		log_stuff(f"#{'-'*80}\n"); print("-"*40)