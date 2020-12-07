package com.example.reciclerview

import android.app.AlertDialog
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.reciclerview.entities.Recepie
import com.example.reciclerview.entities.SwipeToDeleteCallback
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.fragment_second.*
import kotlinx.android.synthetic.main.fragment_second.view.*

/**
 * A simple [Fragment] subclass as the second destination in the navigation.
 */
class SecondFragment : Fragment(),View.OnClickListener {


    var recepies = listOf(
        Recepie(0,"t1", "ty1", listOf("12", "23"), "d1"),
        Recepie(1,"t2", "ty2", listOf("12", "23"), "d2"),
        Recepie(2,"t3", "ty3", listOf("12", "23"), "d3"),
        Recepie(3,"t4", "ty4", listOf("12", "23"), "d4"),
        Recepie(4,"t5", "ty5", listOf("12", "23"), "d5"),
        Recepie(5,"t6", "ty6", listOf("12", "23"), "d6"),
        Recepie(6,"t7", "ty7", listOf("12", "23"), "d7"),
        Recepie(7,"t8", "ty8", listOf("12", "23"), "d8"),
        Recepie(8,"t9", "ty9", listOf("12", "23"), "d9"),
        Recepie(9,"t10", "ty10", listOf("12", "23"), "d11"),
        Recepie(10,"t11", "ty11", listOf("12", "23"), "d11")
    ).toMutableList()


    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        val view: View = inflater.inflate(R.layout.fragment_second, container, false)
        view.fab.setOnClickListener { v ->


            val nextFrag = AddFragment()
            val transaction = this.activity!!.supportFragmentManager.beginTransaction()
                .replace(R.id.addFragment,nextFrag).commit()


        }
        // Inflate the layout for this fragment

        return view
    }

    fun applyView(){
        recyclerview.apply {
            // set a LinearLayoutManager to handle Android
            // RecyclerView behavior
            layoutManager = LinearLayoutManager(activity)
            // set the custom adapter to the RecyclerView
            adapter = ListAdapter(recepies)
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        // RecyclerView node initialized here

        applyView()

        val swipeHandler = object : SwipeToDeleteCallback(this.context) {

            override fun onSwiped(viewHolder: RecyclerView.ViewHolder, direction: Int) {
                val adapter = recyclerview.adapter as ListAdapter

                val builder = AlertDialog.Builder(context)
                builder.setMessage("Are you sure you want to Delete?")
                    .setCancelable(true)
                    .setPositiveButton("Yes") { _, _ ->
                        // remove list item at position
                        adapter.removeAt(viewHolder.adapterPosition)

                    }
                    .setNegativeButton("No") { dialog, _ ->
                        // Dismiss the dialog

                        dialog.dismiss()
                        //re-draw the view in order to have the list item in place
                        //not the delete-swipe part
                        applyView()
                    }
                val alert = builder.create()
                alert.show()
            }
        }

        val itemTouchHelper = ItemTouchHelper(swipeHandler)
        itemTouchHelper.attachToRecyclerView(recyclerview)


    }

    override fun onClick(v: View?) {
        if (v != null) {
            v.callOnClick()
        }
    }




}

