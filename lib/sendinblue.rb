require "sendinblue/version"
require "json"
require "httparty"

module Sendinblue
	class Mailin
		@base_url = ""
		@api_key = "Your access key"
		def initialize(base_url,api_key,timeout=nil)
			@base_url = base_url
			@api_key = api_key
			@timeout = timeout
		end
		def do_request(resource,method,input)
			called_url = @base_url + "/" + resource
			content_type = "application/json"
			if @timeout != nil then @timeout = @timeout else @timeout = 30 end 	#default timeout: 30 secs
			if(@timeout != nil && (@timeout <= 0 or @timeout > 60))
				raise Exception.new("value not allowed for timeout")
			end
			case method
			when "GET"
				response = HTTParty.get(called_url,:body=>input, :default_timeout=> @timeout, :headers => {"api-key"=>@api_key,"content-type"=>content_type})
			when "POST"
				response = HTTParty.post(called_url,:body=>input, :default_timeout=> @timeout, :headers => {"api-key"=>@api_key,"content-type"=>content_type})
			when "PUT"
				response = HTTParty.put(called_url,:body=>input, :default_timeout=> @timeout, :headers => {"api-key"=>@api_key,"content-type"=>content_type})
			else
				response = HTTParty.delete(called_url,:body=>input, :default_timeout=> @timeout, :headers => {"api-key"=>@api_key,"content-type"=>content_type})
			end
			return JSON.parse(response.body)
		end
		def get(resource,input)
			return do_request(resource,"GET",input)
		end
		def post(resource,input)
			return do_request(resource,"POST",input)
		end
		def put(resource,input)
			return do_request(resource,"PUT",input)
		end
		def delete(resource,input)
			return do_request(resource,"DELETE",input)
		end
		# Get Account.
		# No input required
		def get_account()
			return self.get("account","")
		end
		
		# Get SMTP details.
		# No input required
		def get_smtp_details()
			return self.get("account/smtpdetail","")
		end

		# Create Child Account.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} child_email: Email address of Reseller child [Mandatory]
		# @options data {String} password: Password of Reseller child to login [Mandatory]
		# @options data {String} company_org: Name of Reseller child’s company [Mandatory]
		# @options data {String} first_name: First name of Reseller child [Mandatory]
		# @options data {String} last_name: Last name of Reseller child [Mandatory]
		# @options data {Array} credits: Number of email & sms credits respectively, which will be assigned to the Reseller child’s account [Optional]
		#     - email_credit {Integer} number of email credits
		#     - sms_credit {Integer} Number of sms credts
		# @options data {Array} associate_ip: Associate dedicated IPs to reseller child. You can use commas to separate multiple IPs [Optional]
		def create_child_account(data)
			return self.post("account",data.to_json)
		end

		# Update Child Account.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} auth_key: 16 character authorization key of Reseller child to be modified [Mandatory]
		# @options data {String} company_org: Name of Reseller child’s company [Optional]
		# @options data {String} first_name: First name of Reseller child [Optional]
		# @options data {String} last_name: Last name of Reseller child [Optional]
		# @options data {String} password: Password of Reseller child to login [Optional]
		# @options data {Array} associate_ip: Associate dedicated IPs to reseller child. You can use commas to separate multiple IPs [Optional]
		# @options data {Array} disassociate_ip: Disassociate dedicated IPs from reseller child. You can use commas to separate multiple IPs [Optional]
		def update_child_account(data)
			return self.put("account",data.to_json)
		end

		# Delete Child Account.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} auth_key: 16 character authorization key of Reseller child to be deleted [Mandatory]
		def delete_child_account(data)
			return self.delete("account/" + data['auth_key'],"")
		end

		# Get Reseller child Account.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} auth_key: 16 character authorization key of Reseller child. Example : To get the details of more than one child account, use, {"key1":"abC01De2fGHI3jkL","key2":"mnO45Pq6rSTU7vWX"} [Mandatory]
		def get_reseller_child(data)
			return self.post("account/getchildv2",data.to_json)
		end

		# Add/Remove Reseller child's Email/Sms credits.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} auth_key: 16 character authorization key of Reseller child to modify credits [Mandatory]
		# @options data {Array} add_credit: Number of email & sms credits to be added. You can assign either email or sms credits, one at a time other will remain 0. [Mandatory: if rmv_credit is empty]
		#     - email_credit {Integer} number of email credits
		#     - sms_credit {Integer} Number of sms credts
		# @options data {Array} rmv_credit: Number of email & sms credits to be removed. You can assign either email or sms credits, one at a time other will remain 0. [Mandatory: if add_credits is empty]
		#     - email_credit {Integer} number of email credits
		#     - sms_credit {Integer} Number of sms credts
		def add_remove_child_credits(data)
			return self.post("account/addrmvcredit",data.to_json)
		end

		# Send a transactional SMS.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} to: The mobile number to send SMS to with country code [Mandatory]
		# @options data {String} from: The name of the sender. The number of characters is limited to 11 (alphanumeric format) [Mandatory]
		# @options data {String} text: The text of the message. The maximum characters used per SMS is 160, if used more than that, it will be counted as more than one SMS [Mandatory]
		# @options data {String} web_url: The web URL that can be called once the message is successfully delivered [Optional]
		# @options data {String} tag: The tag that you can associate with the message [Optional]
		# @options data {String} type: Type of message. Possible values – marketing (default) & transactional. You can use marketing for sending marketing SMS, & for sending transactional SMS, use transactional type [Optional]
		def send_sms(data)
			return self.post("sms",data.to_json)
		end

		# Create & Schedule your SMS campaigns.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} name: Name of the SMS campaign [Mandatory]
		# @options data {String} sender: This allows you to customize the SMS sender. The number of characters is limited to 11 ( alphanumeric format ) [Optional]
		# @options data {String} content: Content of the message. The maximum characters used per SMS is 160, if used more than that, it will be counted as more than one SMS [Optional]
		# @options data {String} bat: Mobile number with the country code to send test SMS. The mobile number defined here should belong to one of your contacts in SendinBlue account and should not be blacklisted [Optional]
		# @options data {Array} listid: These are the list ids to which the SMS campaign is sent [Mandatory: if scheduled_date is not empty]
		# @options data {Array} exclude_list: These are the list ids which will be excluded from the SMS campaign [Optional]
		# @options data {String} scheduled_date: The day on which the SMS campaign is supposed to run [Optional]
		# @options data {Integer} send_now: Flag to send campaign now. Possible values = 0 (default) & 1. send_now = 0 means campaign can’t be send now, & send_now = 1 means campaign ready to send now [Optional]
		def create_sms_campaign(data)
			return self.post("sms",data.to_json)
		end

		# Update your SMS campaigns.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of the SMS campaign [Mandatory]
		# @options data {String} name: Name of the SMS campaign [Optional]
		# @options data {String} sender: This allows you to customize the SMS sender. The number of characters is limited to 11 ( alphanumeric format ) [Optional]
		# @options data {String} content: Content of the message. The maximum characters used per SMS is 160, if used more than that, it will be counted as more than one SMS [Optional]
		# @options data {String} bat: Mobile number with the country code to send test SMS. The mobile number defined here should belong to one of your contacts in SendinBlue account and should not be blacklisted [Optional]
		# @options data {Array} listid: hese are the list ids to which the SMS campaign is sent [Mandatory: if scheduled_date is not empty]
		# @options data {Array} exclude_list: These are the list ids which will be excluded from the SMS campaign [Optional]
		# @options data {String} scheduled_date: The day on which the SMS campaign is supposed to run [Optional]
		# @options data {Integer} send_now: Flag to send campaign now. Possible values = 0 (default) & 1. send_now = 0 means campaign can’t be send now, & send_now = 1 means campaign ready to send now [Optional]
		def update_sms_campaign(data)
			id = data['id'].to_s
			return self.put("sms/" + id,data.to_json)
		end

		# Send a Test SMS.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of the SMS campaign [Mandatory]
		# @options data {String} to: Mobile number with the country code to send test SMS. The mobile number defined here should belong to one of your contacts in SendinBlue account and should not be blacklisted [Mandatory]
		def send_bat_sms(data)
			id = data['id'].to_s
			return self.get("sms/" + id,data.to_json)
		end

		# Get all campaigns detail.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} type: Type of campaign. Possible values – classic, trigger, sms, template ( case sensitive ) [Optional]
		# @options data {String} status: Status of campaign. Possible values – draft, sent, archive, queued, suspended, in_process, temp_active, temp_inactive ( case sensitive ) [Optional]
		# @options data {Integer} page: Maximum number of records per request is 500, if there are more than 500 campaigns then you can use this parameter to get next 500 results [Optional]
		# @options data {Integer} page_limit: This should be a valid number between 1-500 [Optional]
		def get_campaigns_v2(data)
			if data['type'] == "" and data['status'] == "" and data['page'] == "" and data['page_limit'] == ""
			return self.get("campaign/detailsv2/","")
			else
			return self.get("campaign/detailsv2/type/" + data['type'] + "/status/" + data['status'] + "/page/" + data['page'].to_s + "/page_limit/" + data['page_limit'].to_s + "/","")
			end
		end

		# Get a particular campaign detail.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Unique Id of the campaign [Mandatory]
		def get_campaign_v2(data)
			id = data['id'].to_s
			return self.get("campaign/" + id + "/detailsv2/","")
		end

		# Create and Schedule your campaigns. It returns the ID of the created campaign.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} category: Tag name of the campaign [Optional]
		# @options data {String} from_name: Sender name from which the campaign emails are sent [Mandatory: for Dedicated IP clients, please make sure that the sender details are defined here, and in case of no sender, you can add them also via API & for Shared IP clients, if sender exists]
		# @options data {String} name: Name of the campaign [Mandatory]
		# @options data {String} bat: Email address for test mail [Optional]
		# @options data {String} html_content: Body of the content. The HTML content field must have more than 10 characters [Mandatory: if html_url is empty]
		# @options data {String} html_url: Url which content is the body of content [Mandatory: if html_content is empty]
		# @options data {Array} listid: These are the lists to which the campaign has been sent [Mandatory: if scheduled_date is not empty]
		# @options data {String} scheduled_date: The day on which the campaign is supposed to run[Optional]
		# @options data {String} subject: Subject of the campaign [Mandatory]
		# @options data {String} from_email: Sender email from which the campaign emails are sent [Mandatory: for Dedicated IP clients, please make sure that the sender details are defined here, and in case of no sender, you can add them also via API & for Shared IP clients, if sender exists]
		# @options data {String} reply_to: The reply to email in the campaign emails [Optional]
		# @options data {String} to_field: This is to personalize the «To» Field. If you want to include the first name and last name of your recipient, add [PRENOM] [NOM] To use the contact attributes here, these should already exist in SendinBlue account [Optional]
		# @options data {Array} exclude_list: These are the lists which must be excluded from the campaign [Optional]
		# @options data {String} attachment_url: Provide the absolute url of the attachment [Optional]
		# @options data {Integer} inline_image: Status of inline image. Possible values = 0 (default) & 1. inline_image = 0 means image can’t be embedded, & inline_image = 1 means image can be embedded, in the email [Optional]
		# @options data {Integer} mirror_active: Status of mirror links in campaign. Possible values = 0 & 1 (default). mirror_active = 0 means mirror links are deactivated, & mirror_active = 1 means mirror links are activated, in the campaign [Optional]
		# @options data {Integer} send_now: Flag to send campaign now. Possible values = 0 (default) & 1. send_now = 0 means campaign can’t be send now, & send_now = 1 means campaign ready to send now [Optional]
		def create_campaign(data)
			return self.post("campaign",data.to_json)
		end

		# Delete your campaigns.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of campaign to be deleted [Mandatory]
		def delete_campaign(data)
			id = data['id'].to_s
			return self.delete("campaign/" + id,"")
		end

		# Update your campaign.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of campaign to be modified [Mandatory]
		# @options data {String} category: Tag name of the campaign [Optional]
		# @options data {String} from_name: Sender name from which the campaign emails are sent [Mandatory: for Dedicated IP clients, please make sure that the sender details are defined here, and in case of no sender, you can add them also via API & for Shared IP clients, if sender exists]
		# @options data {String} name: Name of the campaign [Optional]
		# @options data {String} bat: Email address for test mail [Optional]
		# @options data {String} html_content: Body of the content. The HTML content field must have more than 10 characters [Optional]
		# @options data {String} html_url: Url which content is the body of content [Optional]
		# @options data {Array} listid These are the lists to which the campaign has been sent [Mandatory: if scheduled_date is not empty]
		# @options data {String} scheduled_date: The day on which the campaign is supposed to run[Optional]
		# @options data {String} subject: Subject of the campaign.
		# @options data {String} from_email: Sender email from which the campaign emails are sent [Mandatory: for Dedicated IP clients, please make sure that the sender details are defined here, and in case of no sender, you can add them also via API & for Shared IP clients, if sender exists]
		# @options data {String} reply_to: The reply to email in the campaign emails [Optional]
		# @options data {String} to_field: This is to personalize the «To» Field. If you want to include the first name and last name of your recipient, add [PRENOM] [NOM]. To use the contact attributes here, these should already exist in SendinBlue account [Optional]
		# @options data {Array} exclude_list: These are the lists which must be excluded from the campaign [Optional]
		# @options data {String} attachment_url: Provide the absolute url of the attachment [Optional]
		# @options data {Integer} inline_image: Status of inline image. Possible values = 0 (default) & 1. inline_image = 0 means image can’t be embedded, & inline_image = 1 means image can be embedded, in the email [Optional]
		# @options data {Integer} mirror_active: Status of mirror links in campaign. Possible values = 0 & 1 (default). mirror_active = 0 means mirror links are deactivated, & mirror_active = 1 means mirror links are activated, in the campaign [Optional]
		# @options data {Integer} send_now: Flag to send campaign now. Possible values = 0 (default) & 1. send_now = 0 means campaign can’t be send now, & send_now = 1 means campaign ready to send now [Optional]
		def update_campaign(data)
			id = data['id'].to_s
			return self.put("campaign/" + id,data.to_json)
		end

		# Send report of Sent and Archived campaign.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of campaign to send its report [Mandatory]
		# @options data {String} lang: Language of email content. Possible values – fr (default), en, es, it & pt [Optional]
		# @options data {String} email_subject: Message subject [Mandatory]
		# @options data {Array} email_to: Email address of the recipient(s). Example: "test@example.net". You can use commas to separate multiple recipients [Mandatory]
		# @options data {String} email_content_type: Body of the message in text/HTML version. Possible values – text & html [Mandatory]
		# @options data {Array} email_bcc: Same as email_to but for Bcc [Optional]
		# @options data {Array} email_cc: Same as email_to but for Cc [Optional]
		# @options data {String} email_body: Body of the message [Mandatory]
		def campaign_report_email(data)
			id = data['id'].to_s
			return self.post("campaign/" + id + "/report",data.to_json)
		end

		# Export the recipients of a specified campaign.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of campaign to export its recipients [Mandatory]
		# @options data {String} notify_url: URL that will be called once the export process is finished [Mandatory]
		# @options data {String} type: Type of recipients. Possible values – all, non_clicker, non_opener, clicker, opener, soft_bounces, hard_bounces & unsubscribes [Mandatory]
		def campaign_recipients_export(data)
			id = data['id'].to_s
			return self.post("campaign/" + id + "/recipients",data.to_json)
		end

		# Send a Test Campaign.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of the campaign [Mandatory]
		# @options data {Array} emails: Email address of recipient(s) existing in the one of the lists & should not be blacklisted. Example: "test@example.net". You can use commas to separate multiple recipients [Mandatory]
		def send_bat_email(data)
			id = data['id'].to_s
			return self.post("campaign/" + id + "/test",data.to_json)
		end

		# Get all the processes information under the account.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} page: Maximum number of records per request is 50, if there are more than 50 processes then you can use this parameter to get next 50 results [Mandatory]
		# @options data {Integer} page_limit: This should be a valid number between 1-50 [Mandatory]
		def get_processes(data)
			return self.get("process",data.to_json)
		end

		# Get the process information.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of process to get details [Mandatory]	
		def get_process(data)
			id = data['id'].to_s
			return self.get("process/" + id.to_s,"")
		end

		# Get all lists detail.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} list_parent: This is the existing folder id & can be used to get all lists belonging to it [Optional]
		# @options data {Integer} page: Maximum number of records per request is 50, if there are more than 50 processes then you can use this parameter to get next 50 results [Mandatory]
		# @options data {Integer} page_limit: This should be a valid number between 1-50 [Mandatory]
		def get_lists(data)
			return self.get("list",data.to_json)
		end

	    # Get a particular list detail.
	    # @param {Array} data contains php array with key value pair.
	    # @options data {Integer} id: Id of list to get details [Mandatory]
		def get_list(data)
			id = data['id'].to_s
			return self.get("list/" + id.to_s,"")
		end

		# Create a new list.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} list_name: Desired name of the list to be created [Mandatory]
		# @options data {Integer} list_parent: Folder ID [Mandatory]
		def create_list(data)
			return self.post("list",data.to_json)
		end

		# Delete a specific list.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of list to be deleted [Mandatory]
		def delete_list(data)
			id = data['id'].to_s
			return self.delete("list/" + id,"")
		end

		# Update a list.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of list to be modified [Mandatory]
		# @options data {String} list_name: Desired name of the list to be modified [Optional]
		# @options data {Integer} list_parent: Folder ID [Mandatory]
		def update_list(data)
			id = data['id'].to_s
			return self.put("list/" + id,data.to_json)
		end

		# Add already existing users in the SendinBlue contacts to the list.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of list to link users in it [Mandatory]
		# @options data {Array} users: Email address of the already existing user(s) in the SendinBlue contacts. Example: "test@example.net". You can use commas to separate multiple users [Mandatory]
		def add_users_list(data)
			id = data['id'].to_s
			return self.post("list/" + id + "/users",data.to_json)
		end

		# Delete already existing users in the SendinBlue contacts from the list.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of list to unlink users from it [Mandatory]
		# @options data {Array} users: Email address of the already existing user(s) in the SendinBlue contacts to be modified. Example: "test@example.net". You can use commas to separate multiple users [Mandatory]
		def delete_users_list(data)
			id = data['id'].to_s
			return self.delete("list/" + id + "/delusers",data.to_json)
		end

		# Send Transactional Email.
		# @param {Array} data contains php array with key value pair.
		# @options data {Array} to: Email address of the recipient(s). It should be sent as an associative array. Example: array("to@example.net"=>"to whom"). You can use commas to separate multiple recipients [Mandatory]
		# @options data {String} subject: Message subject [Mandatory]
		# @options data {Array} from Email address for From header. It should be sent as an array. Example: array("from@email.com","from email") [Mandatory]
		# @options data {String} html: Body of the message. (HTML version) [Mandatory]. To send inline images, use <img src="{YourFileName.Extension}" alt="image" border="0" >, the 'src' attribute value inside {} (curly braces) should be same as the filename used in 'inline_image' parameter
		# @options data {String} text: Body of the message. (text version) [Optional]
		# @options data {Array} cc: Same as to but for Cc. Example: array("cc@example.net","cc whom") [Optional]
		# @options data {Array} bcc: Same as to but for Bcc. Example: array("bcc@example.net","bcc whom") [Optional]
		# @options data {Array} replyto: Same as from but for Reply To. Example: array("from@email.com","from email") [Optional]
		# @options data {Array} attachment: Provide the absolute url of the attachment/s. Possible extension values = gif, png, bmp, cgm, jpg, jpeg, txt, css, shtml, html, htm, csv, zip, pdf, xml, doc, xls, ppt, tar, and ez. To send attachment/s generated on the fly you have to pass your attachment/s filename & its base64 encoded chunk data as an associative array. Example: array("YourFileName.Extension"=>"Base64EncodedChunkData"). You can use commas to separate multiple attachments [Optional]
		# @options data {Array} headers: The headers will be sent along with the mail headers in original email. Example: array("Content-Type"=>"text/html; charset=iso-8859-1"). You can use commas to separate multiple headers [Optional]
		# @options data {Array} inline_image: Pass your inline image/s filename & its base64 encoded chunk data as an associative array. Example: array("YourFileName.Extension"=>"Base64EncodedChunkData"). You can use commas to separate multiple inline images [Optional]	
		def send_email(data)
			return self.post("email",data.to_json)
		end

		# To retrieve details of all webhooks.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} is_plat: Flag to get webhooks. Possible values – 0 & 1. Example: to get Transactional webhooks, use $is_plat=0, to get Marketing webhooks, use $is_plat=1, & to get all webhooks, use $is_plat="" [Optional]
		def get_webhooks(data)
			return self.get("webhook",data.to_json)
		end

		# To retrieve details of any particular webhook.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of webhook to get details [Mandatory]
		
		def get_webhook(data)
			id = data['id'].to_s
			return self.get("webhook/" + id,"")
		end

		# Create a Webhook.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} url: URL that will be triggered by a webhook [Mandatory]
		# @options data {String} description: Webook description [Optional]
		# @options data {Array} events: Set of events. You can use commas to separate multiple events. Possible values for Transcational webhook – request, delivered, hard_bounce, soft_bounce, blocked, spam, invalid_email, deferred, click, & opened and Possible Values for Marketing webhook – spam, opened, click, hard_bounce, unsubscribe, soft_bounce & list_addition ( case sensitive ) [Mandatory]
		# @options data {Integer} is_plat: Flag to create webhook type. Possible values – 0 (default) & 1. Example: to create Transactional webhooks, use $is_plat=0, & to create Marketing webhooks, use $is_plat=1 [Optional]
		def create_webhook(data)
			return self.post("webhook",data.to_json)
		end

		# Delete a webhook.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of webhook to be deleted [Mandatory]
		def delete_webhook(data)
			id = data['id'].to_s
			return self.delete("webhook/" + id,"")
		end

		# Update a webhook.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of webhook to be modified [Mandatory]
		# @options data {String} url: URL that will be triggered by a webhook [Mandatory]
		# @options data {String} description: Webook description [Optional]
		# @options data {Array} events: Set of events. You can use commas to separate multiple events. Possible values for Transcational webhook – request, delivered, hard_bounce, soft_bounce, blocked, spam, invalid_email, deferred, click, & opened and Possible Values for Marketing webhook – spam, opened, click, hard_bounce, unsubscribe, soft_bounce & list_addition ( case sensitive ) [Mandatory]
		def update_webhook(data)
			id = data['id'].to_s
			return self.put("webhook/" + id,data.to_json)
		end

		# Aggregate / date-wise report of the SendinBlue SMTP account.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} aggregate: This is used to indicate, you are interested in all-time totals. Possible values – 0 & 1. aggregate = 0 means it will not aggregate records, and will show stats per day/date wise [Optional]
		# @options data {String} start_date: The start date to look up statistics. Date must be in YYYY-MM-DD format and should be before the end_date [Optional]
		# @options data {String} end_date: The end date to look up statistics. Date must be in YYYY-MM-DD format and should be after the start_date [Optional]
		# @options data {Integer} days: Number of days in the past to include statistics ( Includes today ). It must be an integer greater than 0 [Optional]
		# @options data {String} tag: The tag you will specify to retrieve detailed stats. It must be an existing tag that has statistics [Optional]	
		def get_statistics(data)
			return self.post("statistics",data.to_json)
		end
		
		# Get Access a specific user Information.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} email: Email address of the already existing user in the SendinBlue contacts [Mandatory]
		def get_user(data)
			id = data['email']
			return self.get("user/" + id,"")
		end

		# Unlink existing user from all lists.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} email: Email address of the already existing user in the SendinBlue contacts to be unlinked from all lists [Mandatory]
		def delete_user(data)
			id = data['email']
			return self.delete("user/" + id,"")
		end

		# Import Users Information.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} url: The URL of the file to be imported. Possible file types – .txt, .csv [Mandatory: if body is empty]
		# @options data {String} body: The Body with csv content to be imported. Example: ‘NAME;SURNAME;EMAIL\n"Name1";"Surname1";"example1@example.net"\n"Name2";"Surname2";"example2@example.net"‘, where \n separates each user data. You can use semicolon to separate multiple attributes [Mandatory: if url is empty]
		# @options data {Array} listids: These are the list ids in which the the users will be imported [Mandatory: if name is empty]
		# @options data {String} notify_url: URL that will be called once the import process is finished [Optional] In notify_url, we are sending the content using POST method
		# @options data {String} name: This is new list name which will be created first & then users will be imported in it [Mandatory: if listids is empty]
		# @options data {Integer} list_parent: This is the existing folder id & can be used with name parameter to make newly created list’s desired parent [Optional]
		def import_users(data)
			return self.post("user/import",data.to_json)
		end

		# Export Users Information.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} export_attrib: The name of attribute present in your SendinBlue account. You can use commas to separate multiple attributes. Example: "EMAIL,NAME,SMS" [Optional]
		# @options data {String} filter: Filter can be added to export users. Example: "{\"blacklisted\":1}", will export all blacklisted users [Mandatory]
		# @options data {String} notify_url: URL that will be called once the export process is finished [Optional]	
		def export_users(data)
			return self.post("user/export",data.to_json)
		end
		
		# Create a new user if an email provided as input, doesn’t exists in the contact list of your SendinBlue account, otherwise it will update the existing user.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} email: Email address of the user to be created in SendinBlue contacts. Already existing email address of user in the SendinBlue contacts to be modified [Mandatory]
		# @options data {Array} attributes: The name of attribute present in your SendinBlue account. It should be sent as an associative array. Example: array("NAME"=>"name"). You can use commas to separate multiple attributes [Optional]
		# @options data {Integer} blacklisted: This is used to blacklist/ Unblacklist a user. Possible values – 0 & 1. blacklisted = 1 means user has been blacklisted [Optional]
		# @options data {Array} listid: The list id(s) to be linked from user [Optional]
		# @options data {Array} listid_unlink: The list id(s) to be unlinked from user [Optional]
		# @options data {Array} blacklisted_sms: This is used to blacklist/ Unblacklist a user’s SMS number. Possible values – 0 & 1. blacklisted_sms = 1 means user’s SMS number has been blacklisted [Optional]
		def create_update_user(data)
			return self.post("user/createdituser",data.to_json)
		end
		
		# Access all the attributes information under the account.
		# No input required
		def get_attributes()
			return self.get("attribute","")
		end
		
		# Access the specific type of attribute information.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} type: Type of attribute. Possible values – normal, transactional, category, calculated & global [Optional]
		def get_attribute(data)
			type = data['type']
			return self.get("attribute/" + type,"")
		end

		# Create an Attribute.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} type: Type of attribute. Possible values – normal, transactional, category, calculated & global ( case sensitive ) [Mandatory]
		# @options data {Array} data: The name and data type of ‘normal’ & ‘transactional’ attribute to be created in your SendinBlue account. It should be sent as an associative array. Example: array(‘ATTRIBUTE_NAME1′ => ‘DATA_TYPE1′, ‘ATTRIBUTE_NAME2’=> ‘DATA_TYPE2′).
		# The name and data value of ‘category’, ‘calculated’ & ‘global’, should be sent as JSON string. Example: ‘[{ "name":"ATTRIBUTE_NAME1", "value":"Attribute_value1" }, { "name":"ATTRIBUTE_NAME2", "value":"Attribute_value2" }]’. You can use commas to separate multiple attributes [Mandatory]
		def create_attribute(data)
			return self.post("attribute",data.to_json)
		end

		# Delete a specific type of attribute information.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} type: Type of attribute to be deleted [Mandatory]	
		def delete_attribute(data)
			type = data['type']
			return self.post("attribute/" + type,data.to_json)
		end

		# Get Email Event report.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} limit: To limit the number of results returned. It should be an integer [Optional]
		# @options data {String} start_date: The start date to get report from. Date must be in YYYY-MM-DD format and should be before the end_date [Optional]
		# @options data {String} end_date: The end date to get report till date. Date must be in YYYY-MM-DD format and should be after the start_date [Optional]
		# @options data {Integer} offset: Beginning point in the list to retrieve from. It should be an integer [Optional]
		# @options data {String} date: Specific date to get its report. Date must be in YYYY-MM-DD format and should be earlier than todays date [Optional]
		# @options data {Integer} days: Number of days in the past (includes today). If specified, must be an integer greater than 0 [Optional]
		# @options data {String} email: Email address to search report for [Optional]
		def get_report(data)
			return self.post("report",data.to_json)
		end

		# Get all folders detail.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} page: Maximum number of records per request is 50, if there are more than 50 folders then you can use this parameter to get next 50 results [Mandatory]
		# @options data {Integer} page_limit: This should be a valid number between 1-50 [Mandatory]
		def get_folders(data)
			return self.get("folder",data.to_json)
		end

		# Get a particular folder detail.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of folder to get details [Mandatory]
		def get_folder(data)
			id = data['id'].to_s
			return self.get("folder/" + id,"")
		end

		# Create a new folder.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} name: Desired name of the folder to be created [Mandatory]
		def create_folder(data)
			return self.post("folder",data.to_json)
		end

		# Delete a specific folder information.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of folder to be deleted [Mandatory]
		def delete_folder(data)
			id = data['id'].to_s
			return self.delete("folder/" + id,"")
		end

		# Update an existing folder.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of folder to be modified [Mandatory]
		# @options data {String} name: Desired name of the folder to be modified [Mandatory]
		def update_folder(data)
			id = data['id'].to_s
			return self.put("folder/" + id,data.to_json)
		end

		# Delete any hardbounce, which actually would have been blocked due to some temporary ISP failures.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} start_date: The start date to get report from. Date must be in YYYY-MM-DD format and should be before the end_date [Optional]
		# @options data {String} end_date: The end date to get report till date. Date must be in YYYY-MM-DD format and should be after the start_date [Optional]
		# @options data {String} email: Email address to delete its bounces [Optional]
		def delete_bounces(data)
			return self.post("bounces",data.to_json)
		end

		# Send templates created on SendinBlue, through SendinBlue SMTP (transactional mails).
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of the template created on SendinBlue account [Mandatory]
		# @options data {String} to: Email address of the recipient(s). You can use pipe ( | ) to separate multiple recipients. Example: "to-example@example.net|to2-example@example.net" [Mandatory]
		# @options data {String} cc: Same as to but for Cc [Optional]
		# @options data {String} bcc: Same as to but for Bcc [Optional]
		# @options data {Array} attr: The name of attribute present in your SendinBlue account. It should be sent as an associative array. Example: array("NAME"=>"name"). You can use commas to separate multiple attributes [Optional]
		# @options data {String} attachment_url: Provide the absolute url of the attachment. Url not allowed from local machine. File must be hosted somewhere [Optional]
		# @options data {Array} attachment: To send attachment/s generated on the fly you have to pass your attachment/s filename & its base64 encoded chunk data as an associative array [Optional]
		def send_transactional_template(data)
			id = data['id'].to_s
			return self.put("template/" + id,data.to_json)
		end

		# Create and schedule your Trigger campaigns.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} category: Tag name of the campaign [Optional]
		# @options data {String} from_name: Sender name from which the campaign emails are sent [Mandatory: for Dedicated IP clients, please make sure that the sender details are defined here, and in case of no sender, you can add them also via API & for Shared IP clients, if sender exists]
		# @options data {String} trigger_name: Name of the campaign [Mandatory]
		# @options data {String} bat: Email address for test mail [Optional]
		# @options data {String} html_content: Body of the content. The HTML content field must have more than 10 characters [Mandatory: if html_url is empty]
		# @options data {String} html_url: Url which content is the body of content [Mandatory: if html_content is empty]
		# @options data {Array} listid: These are the lists to which the campaign has been sent [Mandatory: if scheduled_date is not empty]
		# @options data {String} scheduled_date: The day on which the campaign is supposed to run[Optional]
		# @options data {String} subject: Subject of the campaign [Mandatory]
		# @options data {String} from_email: Sender email from which the campaign emails are sent [Mandatory: for Dedicated IP clients, please make sure that the sender details are defined here, and in case of no sender, you can add them also via API & for Shared IP clients, if sender exists]
		# @options data {String} reply_to: The reply to email in the campaign emails [Optional]
		# @options data {String} to_field: This is to personalize the «To» Field. If you want to include the first name and last name of your recipient, add [PRENOM] [NOM]. To use the contact attributes here, these should already exist in SendinBlue account [Optional]
		# @options data {Array} exclude_list: These are the lists which must be excluded from the campaign [Optional]
		# @options data {Integer} recurring: Type of trigger campaign. Possible values = 0 (default) & 1. recurring = 0 means contact can receive the same Trigger campaign only once, & recurring = 1 means contact can receive the same Trigger campaign several times [Optional]
		# @options data {String} attachment_url: Provide the absolute url of the attachment [Optional]
		# @options data {Integer} inline_image: Status of inline image. Possible values = 0 (default) & 1. inline_image = 0 means image can’t be embedded, & inline_image = 1 means image can be embedded, in the email [Optional]
		# @options data {Integer} mirror_active: Status of mirror links in campaign. Possible values = 0 & 1 (default). mirror_active = 0 means mirror links are deactivated, & mirror_active = 1 means mirror links are activated, in the campaign [Optional]
		# @options data {Integer} send_now: Flag to send campaign now. Possible values = 0 (default) & 1. send_now = 0 means campaign can’t be send now, & send_now = 1 means campaign ready to send now [Optional]
		def create_trigger_campaign(data)
			return self.post("campaign",data.to_json)
		end

		# Update and schedule your Trigger campaigns.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of Trigger campaign to be modified [Mandatory]
		# @options data {String} category: Tag name of the campaign [Optional]
		# @options data {String} from_name: Sender name from which the campaign emails are sent [Mandatory: for Dedicated IP clients, please make sure that the sender details are defined here, and in case of no sender, you can add them also via API & for Shared IP clients, if sender exists]
		# @options data {String} trigger_name: Name of the campaign [Mandatory]
		# @options data {String} bat Email address for test mail [Optional]
		# @options data {String} html_content: Body of the content. The HTML content field must have more than 10 characters [Mandatory: if html_url is empty]
		# @options data {String} html_url: Url which content is the body of content [Mandatory: if html_content is empty]
		# @options data {Array} listid: These are the lists to which the campaign has been sent [Mandatory: if scheduled_date is not empty]
		# @options data {String} scheduled_date: The day on which the campaign is supposed to run[Optional]
		# @options data {String} subject: Subject of the campaign [Mandatory]
		# @options data {String} from_email: Sender email from which the campaign emails are sent [Mandatory: for Dedicated IP clients, please make sure that the sender details are defined here, and in case of no sender, you can add them also via API & for Shared IP clients, if sender exists]
		# @options data {String} reply_to: The reply to email in the campaign emails [Optional]
		# @options data {String} to_field: This is to personalize the «To» Field. If you want to include the first name and last name of your recipient, add [PRENOM] [NOM]. To use the contact attributes here, these should already exist in SendinBlue account [Optional]
		# @options data {Array} exclude_list: These are the lists which must be excluded from the campaign [Optional]
		# @options data {Integer} recurring: Type of trigger campaign. Possible values = 0 (default) & 1. recurring = 0 means contact can receive the same Trigger campaign only once, & recurring = 1 means contact can receive the same Trigger campaign several times [Optional]
		# @options data {String} attachment_url: Provide the absolute url of the attachment [Optional]
		# @options data {Integer} inline_image: Status of inline image. Possible values = 0 (default) & 1. inline_image = 0 means image can’t be embedded, & inline_image = 1 means image can be embedded, in the email [Optional]
		# @options data {Integer} mirror_active: Status of mirror links in campaign. Possible values = 0 & 1 (default). mirror_active = 0 means mirror links are deactivated, & mirror_active = 1 means mirror links are activated, in the campaign [Optional]
		# @options data {Integer} send_now: Flag to send campaign now. Possible values = 0 (default) & 1. send_now = 0 means campaign can’t be send now, & send_now = 1 means campaign ready to send now [Optional]
		def update_trigger_campaign(data)
			id = data['id'].to_s
			return self.put("campaign/" + id,data.to_json)
		end

		# Create a Template.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} from_name: Sender name from which the campaign emails are sent [Mandatory: for Dedicated IP clients & for Shared IP clients, if sender exists]
		# @options data {String} template_name: Name of the Template [Mandatory]
		# @options data {String} bat: Email address for test mail [Optional]
		# @options data {String} html_content: Body of the content. The HTML content field must have more than 10 characters [Mandatory: if html_url is empty]
		# @options data {String} html_url Url: which content is the body of content [Mandatory: if html_content is empty]
		# @options data {String} subject: Subject of the campaign [Mandatory]
		# @options data {String} from_email: Sender email from which the campaign emails are sent [Mandatory: for Dedicated IP clients & for Shared IP clients, if sender exists]
		# @options data {String} reply_to: The reply to email in the campaign emails [Optional]
		# @options data {String} to_fieldv This is to personalize the «To» Field. If you want to include the first name and last name of your recipient, add [PRENOM] [NOM]. To use the contact attributes here, these should already exist in SendinBlue account [Optional]
		# @options data {Integer} status: Status of template. Possible values = 0 (default) & 1. status = 0 means template is inactive, & status = 1 means template is active [Optional]
		# @options data {Integer} attachment: Status of attachment. Possible values = 0 (default) & 1. attach = 0 means an attachment can’t be sent, & attach = 1 means an attachment can be sent, in the email [Optional]
		def create_template(data)
			return self.post("template",data.to_json)
		end

		# Update a Template.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of Template to be modified [Mandatory]
		# @options data {String} from_name: Sender name from which the campaign emails are sent [Mandatory: for Dedicated IP clients & for Shared IP clients, if sender exists]
		# @options data {String} template_name: Name of the Template [Mandatory]
		# @options data {String} bat: Email address for test mail [Optional]
		# @options data {String} html_content: Body of the content. The HTML content field must have more than 10 characters [Mandatory: if html_url is empty]
		# @options data {String} html_url: Url which content is the body of content [Mandatory: if html_content is empty]
		# @options data {String} subject: Subject of the campaign [Mandatory]
		# @options data {String} from_email: Sender email from which the campaign emails are sent [Mandatory: for Dedicated IP clients & for Shared IP clients, if sender exists]
		# @options data {String} reply_to: The reply to email in the campaign emails [Optional]
		# @options data {String} to_field: This is to personalize the «To» Field. If you want to include the first name and last name of your recipient, add [PRENOM] [NOM]. To use the contact attributes here, these should already exist in SendinBlue account [Optional]
		# @options data {Integer} status: Status of template. Possible values = 0 (default) & 1. status = 0 means template is inactive, & status = 1 means template is active [Optional]
		# @options data {Integer} attachment: Status of attachment. Possible values = 0 (default) & 1. attach = 0 means an attachment can’t be sent, & attach = 1 means an attachment can be sent, in the email [Optional]
		def update_template(data)
			id = data['id'].to_s
			return self.put("template/" + id,data.to_json)
		end

		# Get the Campaign name, subject and share link of the classic type campaigns only which are sent, for those which are not sent and the rest of campaign types like trigger, template & sms, will return an error message of share link not available.
		# @param {Array} data contains php array with key value pair.
		# @options data {Array} camp_ids: Id of campaign to get share link. You can use commas to separate multiple ids [Mandatory]
		def share_campaign(data)
			return self.post("campaign/sharelinkv2",data.to_json)
		end

		# Update the Campaign status.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of campaign to update its status [Mandatory]
		# @options data {String} status: Types of status. Possible values – suspended, archive, darchive, sent, queued, replicate and replicate_template ( case sensitive ) [Mandatory]
		def update_campaign_status(data)
			id = data['id'].to_s
			return self.put("campaign/" + id + "/updatecampstatus",data.to_json)
		end

		# Get Access of created senders information.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} option: Options to get senders. Possible options – IP-wise, & Domain-wise ( only for dedicated IP clients ). Example: to get senders with specific IP, use $option=’1.2.3.4′, to get senders with specific domain use, $option=’domain.com’, & to get all senders, use $option="" [Optional]	
		def get_senders(data)
			return self.get("advanced",data.to_json)
		end

		# Create your Senders.
		# @param {Array} data contains php array with key value pair.
		# @options data {String} name: Name of the sender [Mandatory]
		# @options data {String} email: Email address of the sender [Mandatory]
		# @options data {Array} ip_domain: Pass pipe ( | ) separated Dedicated IP and its associated Domain. Example: "1.2.3.4|mydomain.com". You can use commas to separate multiple ip_domain’s [Mandatory: Only for Dedicated IP clients, for Shared IP clients, it should be kept blank]
		def create_sender(data)
			return self.post("advanced",data.to_json)
		end

		# Update your Senders.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of sender to be modified [Mandatory]
		# @options data {String} name: Name of the sender [Mandatory]
		# @options data {Array} ip_domain: Pass pipe ( | ) separated Dedicated IP and its associated Domain. Example: "1.2.3.4|mydomain.com". You can use commas to separate multiple ip_domain’s [Mandatory: Only for Dedicated IP clients, for Shared IP clients, it should be kept blank]
		def update_sender(data)
			id = data['id'].to_s
			return self.put("advanced/" + id,data.to_json)
		end

		# Delete your Sender Information.
		# @param {Array} data contains php array with key value pair.
		# @options data {Integer} id: Id of sender to be deleted [Mandatory]
		def delete_sender(data)
			id = data['id'].to_s
			return self.delete("advanced/" + data,"")
		end
	end
end
