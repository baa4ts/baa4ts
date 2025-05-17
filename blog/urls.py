from django.urls import path
from .views import VistaPortfolio

urlpatterns = [
    path('', VistaPortfolio.as_view(), name='Portafolio'),  # /blog/
]
