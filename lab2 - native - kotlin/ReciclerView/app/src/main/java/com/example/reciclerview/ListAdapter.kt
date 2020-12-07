package com.example.reciclerview

import android.app.AlertDialog
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.example.reciclerview.entities.Recepie

class ListAdapter(private val list: MutableList<Recepie>)
    : RecyclerView.Adapter<ListViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ListViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.recepielist_item, parent, false)

        return ListViewHolder(view)
    }

    override fun onBindViewHolder(holder: ListViewHolder, position: Int) {
        val recepie: Recepie = list[position]
        holder.bind(recepie)

    }

    override fun getItemCount(): Int = list.size

    fun removeAt(adapterPosition: Int) {
        list.removeAt(adapterPosition)
        notifyItemRemoved(adapterPosition)
    }

}