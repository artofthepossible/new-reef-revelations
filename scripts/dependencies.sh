# create a dependencies.sh file that runs these to ensure application runs #Create a virtual environment for your project to manage dependencies separately from other Python projects by running:
python3 -m venv venv

#Activate the virtual environment:
source venv/bin/activate

#Install the required dependencies listed in requirements.txt by running:
pip install -r requirements.txt
#pip install Flask Jinja2
#pip install --upgrade Flask Jinja2

#Set the FLASK_APP environment variable to tell Flask where your application is located:
# Assure the environment is correct, do necessary preps but don't start the app
echo "Setting up environment for flask app"
export FLASK_APP=app.py

#Run the Flask application:
#flask run
#!/bin/sh


echo "Environment setup complete"