# Step by Step Deployment for Rails 3 with Capistrano Nginx/Unicorn Environment

this is a step-by-step deployment guide for rails 3 with capistrano, to set a nginx/unicorn/postgresql environment according to the railscast episodes by Ryan Bates, http://railscasts.com/episodes/337-capistrano-recipes and http://railscasts.com/episodes/335-deploying-to-a-vps

## Production Stack

* ubuntu 10.04
* nginx
* unicorn
* postgres
* rbenv
* linode vps

## Global Variables

* **$USER**         : the linux server user to deploy the app (with sudo privileges)
* **$RUBY_VERSION** : the ruby version to use (ex: 1.9.2-p290)
* **$GIT_REPO**     : the github address of the project (ex: git@github.com:fespinoz/perorg)
* **$APP_NAME**     : the app name (ex: "personal_organizer")
* **$DEPLOY_PATH**  : the basic root path to deploy (ex: "/home/#{user}/apps/#{application}")
* **$SERVER**       : the IP address or public dns of the server (ex: "172.9.182.12" or "ec2asda.aws.com")
* **$GIT_BRANCH**   : the git branch to deploy (ex: "master")

# Steps

1. Check VPS (ex Linode)
	* purchase linode
	* rebuild
		* select ubuntu 10.04
		* set root password
	* view remote access

2. Create deployer user (ubuntu user also works fine)
	
	Add $USER user, only if needed, the user ubuntu works just fine

		adduser $USER --ingroup admin

3. Configure easy access to server

	3.1 To enter the server without password, ssh setup
	
		cat ~/.ssh/id_rsa.pub | ssh $USER@$SERVER 'cat >> ~/.ssh/authorized_keys'

	3.2 enable capistrano's forward_agent option to use local ssh keys to deploy from github
	
		ssh-add # -K on Mac OS X

4. SetUp Git

		mate .gitignore # add config/database.yml

		cp config/database.yml config/database.example.yml
	
		git init
	
		git add .
	
		git commit -m "initial commit"
	 
		git remote add origin $GIT_REPO
	 
		git push

5. Installing and Setting Up Capistrano and Unicorn

	5.1 add capistrano and unicorn gems
	
	5.2 generating capistrano, unicorn and nginx config files
	
		capify .

	    * copy the deploy.rb file and the recipes folder to your config/
 
	5.3 **check configurations and set variables**

		* deploy file
		* recipy files
    * Capfile (and uncomment the assets section)
	5.4 commit deploy changes

		git add .
		git commit -m "deployment configs"

6. Install dependencies

	6.1 install git
	
		sudo apt-get install git-core
		
	6.2 Get to know github.com
	
		ssh git@github.com
		
	6.3 Then install dependencies with the capistrano recipes
 
		cap deploy:install

7. Launch deployment Setup

		cap deploy:setup # it will ask for the $USER password

8. Edit config files in $DEPLOY_PATH/shared

9. Deploying for the very first time

		cap deploy:cold

10. Extra Installation

	EX. Postfix
		if you want to send emails within your app

		* apt-get -y install telnet postfix
