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

```ruby
require 'Sendinblue'
m = Sendinblue::Mailin.new("https://api.sendinblue.com/v2.0","<your access key>")
to = {'to@example.net'=>'to email'} #mandatory
subject = 'Mon subject' #mandatory
from = ['from@example.net','from email'] #mandatory
html = '<h1> hello html </h1>' #mandatory
text = 'text'
cc = {'cc@example.net'=>'cc email'}
bcc = {'bcc@example.net'=>'b cc email'}
replyto = ['rpely@example.net','reply email']
attachment=[]
headers=[]
print m.send_email(to,subject,from,html,text,cc,bcc,replyto,attachment,headers)
```

## Support and Feedback

Be sure to visit the SendinBlue official [documentation website](https://apidocs.sendinblue.com) for additional information about our API.

If you find a bug, please submit the issue in [Github directly](https://github.com/mailin-api/mailin-api-ruby/issues).

As always, if you need additional assistance, drop us a note [here](https://apidocs.sendinblue.com/support/).