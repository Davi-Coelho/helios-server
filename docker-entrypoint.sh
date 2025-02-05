#!/bin/bash
python manage.py compilemessages
python manage.py migrate
echo "from django.contrib.auth.models import User; 
from django.contrib.auth.hashers import make_password; 
User.objects.create(is_staff=True,is_superuser=True, username='$DJANGO_SUPERUSER_USERNAME', email='$DJANGO_SUPERUSER_EMAIL', password=make_password('$DJANGO_SUPERUSER_PASSWORD'))" | python manage.py shell
echo "from helios_auth.models import User; 
from django.contrib.auth.hashers import make_password; 
User.objects.create(user_type='password', user_id='$HELIOS_USERNAME', admin_p=True, info={'password':'$HELIOS_PASSWORD', 'email':'$HELIOS_EMAIL'})" | python manage.py shell
