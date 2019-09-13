from django.db import models

# Create your models here.

class Employee(models.Model):
    GENDER_CHOICES = (
        ('M', 'Male'),
        ('F', 'Female'),
    )
    first_name = models.CharField(max_length=14)
    last_name = models.CharField(max_length=16)
    birth_date = models.DateField()
    gender = models.CharField(max_length=1, choices=GENDER_CHOICES)
    dept_name = models.CharField(max_length=20)

    def __unicode__(self):
        return self.first_name

    def __str__(self):
        return self.first_name

    class Meta:
        verbose_name_plural = "Employees"