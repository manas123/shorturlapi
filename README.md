# urlshortnerapi

== README

Run bundle install

mysql db creation (bundle exec rake db:create)

Run migrations (bundle exec rake db:migrate)

After the above steps, it should work fine with the basic functionalities.

ex:

	env: development

	[POST] [localhost:3000]/api/v1/shorturls?url=[LONG_URL] - to create short url

	response format:

		{
		    "id": ID,
		    "longurl": LONG_URL,
		    "shorturlkey": KEY,
		    "shorturl": SHORT_URL,
		    "expires_at": EXPIRES_AT,
		    "created_at": CREATED_AT,
		    "updated_at": UPDATED_AT
		}

	SHORT_URL request redirects to LONG_URL

	Data is stored in mysql db and cached (expires in 1.day)

