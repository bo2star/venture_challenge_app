server:
	bundle exec rails server webrick --binding 127.0.0.1 --port 3112

open:
	open -a "Google Chrome" http://app.onlineventurechallenge.dev:3112

watch:
	bundle exec guard

deploy:
	git push
	git push heroku master

deploy_migrations:
	git push
	git push heroku master
	heroku run rake db:migrate