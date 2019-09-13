from rest_framework import routers
from django.conf.urls import url, include
from django.urls import path
from employee_app.views import EmployeeViewSet

app_name = "employee_app"

router = routers.SimpleRouter()
router.register(r'employees', EmployeeViewSet, base_name='employee')

urlpatterns = router.urls