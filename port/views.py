from django.http import HttpResponseNotAllowed
from django.shortcuts import render
from django.views import View


class VistaPortfolio(View):

    template_name = 'portfolio.html'

    def dispatch(self, request, *args, **kwargs):
        if request.method != 'GET':
            return HttpResponseNotAllowed(['GET'])
        return super().dispatch(request, *args, **kwargs)

    def get(self, request):
        return render(request, self.template_name)
