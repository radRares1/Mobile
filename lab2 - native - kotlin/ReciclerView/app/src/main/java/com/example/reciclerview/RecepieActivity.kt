package com.example.reciclerview

import android.app.Activity
import android.app.AlertDialog
import android.os.Bundle
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import com.example.reciclerview.entities.Recepie
import kotlinx.android.synthetic.main.activity_recepie.*

/**
 * A simple [Fragment] subclass as the default destination in the navigation.
 */
public class RecepieActivity() : AppCompatActivity() {

    private var recepie: Recepie? = null

    constructor(initRecepie: Recepie) : this() {
        recepie = initRecepie
    }


    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_recepie)



        this.recepie = intent.extras?.get("recepie") as Recepie?

        //we set the values from the recepie into their respective textview
        val title = findViewById<TextView>(R.id.titleContainer)
        val updatedTitle = recepie?.title
        title.setText(updatedTitle)


        val type = findViewById<TextView>(R.id.typeContainer)
        val updatedType = recepie?.type
        type.setText(updatedType)

        val desc = findViewById<TextView>(R.id.descriptionContainer)
        val updatedDesc = recepie?.description
        desc.setText(updatedDesc)

        val ingredients = findViewById<TextView>(R.id.ingredientsContainer)
        val ingString = recepie?.ingredients?.foldRight("") { e, f -> e + ", " + f }
        val updatedIngs = ingString
        ingredients.setText(updatedIngs)

        this.editFab.setOnClickListener { v ->
            title.isEnabled = true
            title.setBackgroundColor(0)
            type.isEnabled = true
            type.setBackgroundColor(0)
            ingredients.isEnabled = true
            ingredients.setBackgroundColor(0)
            desc.isEnabled = true
            desc.setBackgroundColor(0)

            this.saveButton.isVisible = true

        }

        this.saveButton.setOnClickListener { v ->
            val newRecepie = Recepie(recepie!!.id, "", "", listOf(""), "")
            newRecepie.title = title.text.toString()
            newRecepie.type = type.text.toString()
            newRecepie.description = desc.text.toString()
            newRecepie.ingredients = desc.text.toString().split(',')

        //fml ca nu stiu cum se face ca lumea ierarhia sa poti sa faci navigarea intre fragmente ca oamenii

//            val newFragment = SecondFragment()
//
//            var updatedRecepies = newFragment.recepies.forEach { e -> if(e.id == newRecepie.id) {
//                e.ingredients = newRecepie.ingredients
//                e.description = newRecepie.description
//                e.type = newRecepie.type
//                e.title = newRecepie.title
//            } }
//
//            val transaction = supportFragmentManager.beginTransaction()
//            transaction.add(R.id.recyclerview,newFragment).commit()


        }


    }

}