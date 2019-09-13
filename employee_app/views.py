from rest_framework.permissions import  IsAuthenticatedOrReadOnly
from rest_framework.authentication import TokenAuthentication
from rest_framework.filters import SearchFilter
from rest_framework import viewsets

from django_filters import rest_framework as filters

from employee_app.models import Employee
from employee_app.serializers import EmployeeSerializer

# Create your views here.


class EmployeeFilter(filters.FilterSet):
    """
    customize filter for filtering employees
    """
    first_name = filters.CharFilter(field_name='first_name', lookup_expr='icontains')
    last_name = filters.CharFilter(field_name='last_name', lookup_expr='icontains')
    dept_name = filters.CharFilter(field_name='dept_name', lookup_expr='icontains')


class EmployeeViewSet(viewsets.ModelViewSet):
    """
    A simple ViewSet for viewing employees.
    """
    permission_classes = (IsAuthenticatedOrReadOnly,)
    authentication_classes = (TokenAuthentication,)
    filter_backends = (filters.DjangoFilterBackend, SearchFilter)
    filterset_class = EmployeeFilter
    search_fields = ('first_name','last_name','dept_name')
    queryset = Employee.objects.all()
    serializer_class = EmployeeSerializer
