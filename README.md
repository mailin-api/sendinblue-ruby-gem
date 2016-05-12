## Sendinblue Ruby GEM

This is [SendinBlue](https://www.sendinblue.com) provided API V2 Ruby GEM. It implements the various exposed APIs that you can read more about on https://apidocs.sendinblue.com.

SendinBlue API's use HTTP Authentication through an api key. You can create your api key from [API Console](https://my.sendinblue.com/advanced/apikey), after you sign up for an account with SendinBlue. You must use latest version 2.0, access key, for accessing APIs.

Compatibility:

 - Ruby 1.9.X
 - Ruby 2.X.X

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sendinblue'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ ( sudo ) gem install sendinblue


## Usage

Interacting with the API.
Below sample is used to send mail from your application using SendinBlue API.

Our library supports a timeout value, default is 30 Secs, which you can pass as 3rd parameter in Mailin class Object.

```ruby
require 'sendinblue'
m = Sendinblue::Mailin.new("https://api.sendinblue.com/v2.0","your access key",5)	#Optional parameter: Timeout in Secs
data = { "to" => {"to@example.net"=>"to whom!"},
"cc" => {"cc@example.net"=>"cc whom!"},
"bcc" => {"bcc@example.net"=>"bcc whom!"},
"from" => ["from@email.com","from email!"],
"replyto" => ["replyto@email.com","reply to!"],
"subject" => "My subject",
"text" => "This is the text",
"html" => "This is the <h1>HTML</h1><br/>
This is inline image 1.<br/>
<img src=\"{myinlineimage1.png}\" alt=\"image1\" border=\"0\"><br/>
Some text<br/>
This is inline image 2.<br/>
<img src=\"{myinlineimage2.jpg}\" alt=\"image2\" border=\"0\"><br/>
Some more text<br/>
Re-used inline image 1.<br/>
<img src=\"{myinlineimage1.png}\" alt=\"image3\" border=\"0\">",
"attachment" => [],
"headers" => {"Content-Type"=> "text/html;charset=iso-8859-1","X-param1"=> "value1", "X-param2"=> "value2","X-Mailin-custom"=>"my custom value", "X-Mailin-IP"=> "102.102.1.2", "X-Mailin-Tag" => "My tag"},
"inline_image" => {"myinlineimage1.png" => "your_png_files_base64_encoded_chunk_data","myinlineimage2.jpg" => "your_jpg_files_base64_encoded_chunk_data"}
}

result = m.send_email(data)
puts result
```

##Recommendation:

Sendinblue Ruby GEM has been upgraded to new version 2.4 with object-based wrapper & have new way of sending input parameters & return JSON Object in response.

If earlier you were using version 2.0, & now upgraded to version 2.2 or higher, then you may face **ArgumentError: wrong number of arguments** in APIs.

In that case, it is **highly recommended** to update way of sending input parameters, then you may no longer face this issue.
Please refer new Ruby samples in [documentation website](https://apidocs.sendinblue.com).

## Support and Feedback

Be sure to visit the SendinBlue official [documentation website](https://apidocs.sendinblue.com) for additional information about our API.

If you find a bug, please submit the issue in [Github directly](https://github.com/mailin-api/mailin-api-ruby/issues).

As always, if you need additional assistance, drop us a note [here](https://apidocs.sendinblue.com/support/).