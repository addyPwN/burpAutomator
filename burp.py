import requests

print("Welcome to Burp Automator\n")

url = input("Enter url to be scanned: ")
post_url = "http://127.0.0.1:1337/v0.1/scan"

attrib = {
    "scan_type_intrusive_active": "false",
    "scan_type_javascript_analysis": "false",
    "scan_type_light_active": "true",
    "scan_type_medium_active": "true",
    "scan_type_passive": "true",
    "select_individual_issues": "false",
    "store_issues_within_queue_items": "false"
}
headers = {'Content-Type': 'application/x-www-form-urlencoded'}
edit = ["scan_type_intrusive_active", "scan_type_javascript_analysis", "scan_type_light_active", "scan_type_medium_active", "scan_type_passive", "select_individual_issues", "store_issues_within_queue_items"]
i = 0
while(i<9):
    c=1	
    for key, value in attrib.items():
    	print(str(c) + ". " + key + "  " + value)
    	c = c + 1
    print("\nEnter 9 to exit and 99 to start scan")
    i = int(input("Enter which config to change (1-7): "))
    if(i < 9):
        print("Enter True/False")
        j = input()
        attrib[edit[i-1]] = j
    
if( i<9):
    print("Thanks for using!")
else:
    curlcomm = """curl -X POST 'http://127.0.0.1:1337/v0.1/scan' -d '{"scan_configurations":[{"config":"{\\"scanner\\":{\\"issues_reported\\":{"""
    c = 0
    for key, value in attrib.items():
        c = c + 1
        if(c < 7):
            curlcomm += "\\\"" + key + "\\\":" + value + ","
        else:
            curlcomm += "\\\"" + key + "\\\":" + value + "}}} \",\"type\":\"CustomConfiguration\"}],\"urls\":[\"" + url + "\"]}\'"	 
    data = curlcomm[51:-1]
    print(data)
    response = requests.post('http://127.0.0.1:1337/v0.1/scan', data=data)
    if(response.status_code == 201):
    	print("Process Initiated!")
    	a = response.headers
    	taskid = a["Location"]
    	print("Task Created with TASK_ID = " + taskid)
    	choice = int(input("Do you want to get Scan Progress?\n1. Yes\n2. No\nEnter Your Choice!: "))
    	if(choice == 1):
    		post_url = post_url + "/" + str(taskid)
    		prog = requests.get(post_url)
    		print(prog.json())
    else:
    	print("Error " + response.status_code)


    