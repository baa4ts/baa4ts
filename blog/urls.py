from django.urls import path
from blog.views import VistaPortfolio


urlpatterns = [
    path('', VistaPortfolio.as_view(), name="Portafolio")
]
