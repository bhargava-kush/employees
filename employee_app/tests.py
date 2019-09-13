from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework.test import APITestCase
from rest_framework.test import APIRequestFactory
from rest_framework.test import force_authenticate

from employee_app.models import Employee
from employee_app.views import EmployeeViewSet

# Create your tests here.

class StandupBotTestCase(APITestCase):

    # fixtures to store test data
    fixtures = ('test_data',)

    client = APIClient()

    def setUp(self):
        """
        load test data from fixtures
        """
        self.employee = Employee.objects.get(pk=2)
        self.factory = APIRequestFactory()
        self.view = EmployeeViewSet

    def test_retrieve_employee(self):

        url = f"/api/employees/2/"

        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data,{'id': 2, 'first_name': 'Kush', 'last_name': 'bhargava',
                                                'birth_date': '2019-09-11', 'gender': 'M', 'dept_name': 'Backend'})

    def test_get_employees(self):
        url = f"/api/employees/"
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)

    def test_employees_filter(self):
        url = f"/api/employees/?first_name=kush"
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), [{'id': 2, 'first_name': 'Kush', 'last_name': 'bhargava',
                                          'birth_date': '2019-09-11', 'gender': 'M', 'dept_name': 'Backend'}])


    def test_create_employee_with_authentication(self):
        data = {"first_name": "X", "last_name": "Y","birth_date": "2015-02-11","gender": "F","dept_name": "frontend"}
        url =f"/api/employees/"
        self.client.credentials(HTTP_AUTHORIZATION='Token 54c08e7faeed428eb54ee5d6980e2f13bc689252')
        response = self.client.post(url, data=data, format="json")
        self.assertEqual(response.status_code, 201)


    def test_create_employee_without_authentication(self):
        data = {"first_name": "X", "last_name": "Y","birth_date": "2015-02-11","gender": "F","dept_name": "frontend"}
        url =f"/api/employees/"
        response = self.client.post(url, data=data, format="json")
        self.assertEqual(response.status_code, 401)


    def test_edit_employee_with_authentication(self):
        data = {"first_name": "X", "last_name": "Y","birth_date": "2015-02-11","gender": "F","dept_name": "frontend"}
        url =f"/api/employees/2/"
        self.client.credentials(HTTP_AUTHORIZATION='Token 54c08e7faeed428eb54ee5d6980e2f13bc689252')
        response = self.client.put(url, data=data, format="json")
        self.assertEqual(response.status_code, 200)


    def test_edit_employee_without_authentication(self):
        data = {"first_name": "X", "last_name": "Y","birth_date": "2015-02-11","gender": "F","dept_name": "frontend"}
        url =f"/api/employees/2/"
        response = self.client.put(url, data=data, format="json")
        self.assertEqual(response.status_code, 401)

    def test_delete_employee(self):
        url = f"/api/employees/2/"
        self.client.credentials(HTTP_AUTHORIZATION='Token 54c08e7faeed428eb54ee5d6980e2f13bc689252')
        response = self.client.delete(url)
        self.assertEqual(response.status_code, 204)

