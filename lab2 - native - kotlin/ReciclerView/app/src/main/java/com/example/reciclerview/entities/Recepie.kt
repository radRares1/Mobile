package com.example.reciclerview.entities

import java.io.Serializable

data class Recepie(var id:Int, var title:String, var type:String, var ingredients:List<String>, var description:String)
    :Serializable{
}