from .settings import *

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': "employee_app",
        'USER': 'employee',
        'PASSWORD': 'postgres',
        'HOST': os.environ.get('POSTGRES_HOST'),
        'PORT': '5432',
    }
}

