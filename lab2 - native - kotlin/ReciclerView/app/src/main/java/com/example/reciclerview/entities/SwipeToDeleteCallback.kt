package com.example.reciclerview.entities

import android.content.Context
import android.graphics.*
import android.graphics.drawable.ColorDrawable
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.RecyclerView
import com.example.reciclerview.R

abstract class SwipeToDeleteCallback(context: Context?) : ItemTouchHelper.SimpleCallback(0, ItemTouchHelper.LEFT) {

    val deleteIcon = context?.let { ContextCompat.getDrawable(it, R.drawable.ic_delete) }
    val inWidth = deleteIcon?.intrinsicWidth
    val inHeight = deleteIcon?.intrinsicHeight
    val background = ColorDrawable()
    val backgroundColor = Color.parseColor("#f44336")

    override fun onMove(
        recyclerView: RecyclerView,
        viewHolder: RecyclerView.ViewHolder,
        target: RecyclerView.ViewHolder
    ): Boolean {
        TODO("Not yet implemented")
    }

    // Let's draw our delete view
    override fun onChildDraw(
        c: Canvas,
        recyclerView: RecyclerView,
        viewHolder: RecyclerView.ViewHolder,
        dX: Float,
        dY: Float,
        actionState: Int,
        isCurrentlyActive: Boolean
    ) {

        val itemView = viewHolder.itemView
        val itemHeight = itemView.bottom - itemView.top

        // Draw the red delete background
        background.color = backgroundColor
        background.setBounds(
            itemView.right + dX.toInt(),
            itemView.top,
            itemView.right,
            itemView.bottom
        )
        background.draw(c)

        // Calculate position of delete icon
        val iconTop = itemView.top + (itemHeight - inHeight!!) / 2
        val iconMargin = (itemHeight - inHeight) / 2
        val iconLeft = itemView.right - iconMargin - inWidth!!
        val iconRight = itemView.right - iconMargin
        val iconBottom = iconTop + inHeight

        // Draw the delete icon
        if (deleteIcon != null) {
            deleteIcon.setBounds(iconLeft, iconTop, iconRight, iconBottom)
            deleteIcon.draw(c)
            super.onChildDraw(c, recyclerView, viewHolder, dX, dY, actionState, isCurrentlyActive)
        }


    }
}
