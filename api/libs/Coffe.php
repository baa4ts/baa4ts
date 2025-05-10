<?php

class CoffeManager
{
    private $CoffeList = [];

    public function NewCoffe()
    {
        echo "hola";
    }

    public function DropCoffe()
    {
        $url = explode("/", $_SERVER['REQUEST_URI']);

        print_r($url);
    }
}
