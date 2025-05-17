from django.urls import path
from port.views import VistaPortfolio

urlpatterns = [
    path('', VistaPortfolio.as_view(), name='index'),
]
