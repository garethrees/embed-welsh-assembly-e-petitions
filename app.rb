require 'sinatra'
require 'open-uri'

enable :inline_templates

get '/' do
  set_base_url
  @petition_url = params['petition_url']

  if @petition_url && !@petition_url.empty?
    @petition_data = scrape_petition(@petition_url)
  end

  erb :index
end

get '/widget' do
  set_base_url
  headers "X-Frame-Options" => ''
  @petition_url = params['petition_url']
  @petition_data = scrape_petition(@petition_url)
  erb :widget
end

def scrape_petition(petition_url)
  page = Nokogiri::HTML(open(petition_url))
  {
    :title => page.css('.pageTitle').text,
    :body => page.css('.petitionInfoText').text,
    :signatures => page.css('.countSignatureHeading').text
  }
end

def set_base_url
  @base_url = ENV['BASE_URL']
end

__END__

@@ index
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta http-equiv="imagetoolbar" content="false" />
  <style type="text/css" media="screen">
    body{margin:1em auto;max-width:40em;padding:0 .62em;font:1.2em/1.62 sans-serif;}h1,h2,h3{line-height:1.2;}@media print{body{max-width:none}}
    .widgetbox {
      background-color: #eee;
      font-family: monospace;
      font-size: 1em;
      height: 120px;
      padding: 0.8em 1em;
      width: 80%;
    }
    .petition-form .form-field {
      margin-bottom: 0.8em;
    }
    .petition-form input[type=text] {
      font-size: 1.75em;
      display: block;
      width: 100%;
    }

    .petition-form input[type=submit],
    .petition-form input[type=submit]:hover,
    .petition-form input[type=submit]:visited,
    .petition-form input[type=submit]:active,
    .petition-form input[type=submit]:focus {
      background-color: #025682;
      border: none;
      color: #fff;
      cursor: pointer;
      display: block;
      font-family: Arial,Helvetica,sans-serif;
      font-size: 1.1em;
      font-weight: bold;
      outline: none;
      padding: 8px 16px;
      text-decoration: none;
    }
    .petition-form input[type=submit]:active,
    .petition-form input[type=submit]:hover {
      background-color: #177197;
    }
    .petition-form input[type=submit]:focus {
      outline: 3px solid #CF0975;
    }

  </style>
  <title>Embed Welsh Assembly e-Petitions</title>

</head>
<body>
  <h1>Embed a Welsh Assembly e-Petition on your website</h1>

  <% if @petition_data %>
    <p>
      To add a widget for <%= @petition_data[:title] %>, copy and paste the
      following code to your web page:
    </p>

    <textarea autofocus readonly rows='4' cols='60' class='widgetbox'><iframe src='<%= @base_url %>/widget?petition_url=<%= @petition_url %>' width='320' height='400' onload="this.style.height=this.contentDocument.body.scrollHeight +'px';this.style.border='none';" style="border:none;" frameborder='0' marginwidth='0' marginheight='0'></iframe>
    </textarea>

    <p>
      The widget will look like this:
    </p>

    <iframe src='<%= @base_url %>/widget?petition_url=<%= @petition_url %>'
            width='320'
            height='400'
            onload="this.style.height=this.contentDocument.body.scrollHeight +'px';this.style.border='none';"
            style="border:none;"
            frameborder='0'
            marginwidth='0'
            marginheight='0'></iframe>

    <p>
      <a href="/">Start again →</a>
    </p>
   <% else %>
    <form class="petition-form" action="/">
      <div class="petition-form form-field">
        <input type="text" required placeholder="Petition URL" name="petition_url">
      </div>
      <div class="petition-form form-field">
        <input type="submit" value="Submit">
      </div>
    </form>
  <% end %>
</body>
</html>

@@ widget
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <meta name="keywords" content="Welsh Assembly e-Petition" />
  <meta name="description" content="e-Petition: <%= @petition_data[:title] %>" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta http-equiv="imagetoolbar" content="false" />

  <style type="text/css" media="screen">
    body {
      border: 6px solid #50626F;
      color: #172934;
      font:1em/1.62 sans-serif;
      margin:1em auto;
      max-width:40em;
      padding:0 .62em;
    }

    .petition-title {
      font-size: 16px;
      line-height:1.2;
    }

    .petition-body {
      font-size: 14px;
    }

    .petition-signatures {
      color: #50626f;
      font-size: 14px;
    }

    .petition-url,
    .petition-url:hover,
    .petition-url:visited,
    .petition-url:active,
    .petition-url:focus {
      background-color: #025682;
      color: #fff;
      cursor: pointer;
      display: inline-block;
      font-family: Arial,Helvetica,sans-serif;
      font-size: 1.1em;
      font-weight: bold;
      padding: 8px 16px;
      text-decoration: none;
    }
    .petition-url:active,
    .petition-url:hover {
      background-color: #177197;
    }
    .petition-url:focus {
      outline: 3px solid #CF0975;
    }
  </style>

  <title><%= @petition_data[:title] %></title>
</head>
<body>
  <div class="widget">
    <h1 class="petition petition-title">
      <%= @petition_data[:title] %>
    </h1>

    <p class="petition petition-body">
      <%= @petition_data[:body] %>
    </p>

    <p class="petition petition-signatures">
      <%= @petition_data[:signatures] %>
    </p>

    <p>
      <a href="<%= @petition_url %>" target="_parent" class="petition petition-url">
        Sign this petition
      </a>
    </div>
  </div>
</body>
</html>


