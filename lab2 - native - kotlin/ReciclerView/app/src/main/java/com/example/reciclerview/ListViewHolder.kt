package com.example.reciclerview

import android.app.AlertDialog
import android.content.Intent
import android.view.View
import android.widget.TextView
import androidx.core.content.ContextCompat.startActivity
import androidx.recyclerview.widget.RecyclerView
import com.example.reciclerview.entities.Recepie
import kotlinx.android.synthetic.main.fragment_second.view.*


class ListViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView),
    View.OnClickListener {
    private var mTitleView: TextView? = null
    private var currentRecepie: Recepie = Recepie(-1,"","",listOf(""),"")


    init {
        mTitleView = itemView.findViewById(R.id.recepieTitle)
        itemView.setOnClickListener(this);
    }

    fun bind(recepie: Recepie) {
        mTitleView?.text = recepie.title
        currentRecepie = recepie

    }

    override fun onClick(v: View?) {

        val recepieFragment: RecepieActivity = RecepieActivity(currentRecepie)
        //creez intent din mainActivity si din activitatea pe care o pornesc
        val intent = Intent(v?.context, recepieFragment::class.java)
        //pass the recepie to the activity
        intent.putExtra("recepie",currentRecepie)

        //aici ii doar sa vad care era contextul si sa vad ca recepie-ul ii cel click-uit
//        val builder = AlertDialog.Builder(v?.context)
//        builder.setMessage("Are you sure you want to Delete?")
//            .setCancelable(true)
//            .setPositiveButton(currentRecepie.title) { dialog, id ->
//                dialog.dismiss()
//            }.setNegativeButton(v?.context.toString()) { dialog, id ->
//                dialog.dismiss()
//            }
//        builder.show()

        //App stopped working daca apelez startActivity
        //apelez cu contextul de la main activity
        if (v != null) {
            v.context.startActivity(intent)
        }
    }


}


