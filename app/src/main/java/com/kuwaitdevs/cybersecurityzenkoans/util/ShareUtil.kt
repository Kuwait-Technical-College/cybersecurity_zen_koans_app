package com.kuwaitdevs.cybersecurityzenkoans.util

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.util.Log
import androidx.core.content.FileProvider
import com.kuwaitdevs.cybersecurityzenkoans.data.KoanWithExplanation
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

object ShareUtil {

    private const val TAG = "ShareUtil"
    private const val FILE_PROVIDER_AUTHORITY = "com.kuwaitdevs.cybersecurityzenkoans.fileprovider"
    private const val SHARED_IMAGE_NAME = "cybersecurity_zen_koan.jpg"

    fun shareKoanCardImage(context: Context, bitmap: Bitmap, koanWithExplanation: KoanWithExplanation?) {
        try {
            // Save bitmap to cache directory
            val cachePath = File(context.cacheDir, "images")
            cachePath.mkdirs()

            val file = File(cachePath, SHARED_IMAGE_NAME)
            val stream = FileOutputStream(file)
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
            stream.close()

            // Get the content URI via FileProvider
            val contentUri = FileProvider.getUriForFile(
                context,
                FILE_PROVIDER_AUTHORITY,
                file
            )

            // Create and start a share intent
            val shareIntent = Intent(Intent.ACTION_SEND).apply {
                type = "image/jpeg"
                putExtra(Intent.EXTRA_STREAM, contentUri)
                putExtra(Intent.EXTRA_SUBJECT, "Cybersecurity Zen Koan #${koanWithExplanation?.uniqueCode}")
                putExtra(Intent.EXTRA_TEXT, "CSZK: #${koanWithExplanation?.uniqueCode}")
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }

            // Start the share activity
            context.startActivity(Intent.createChooser(shareIntent, "Share Koan"))

        } catch (e: IOException) {
            Log.e(TAG, "Error sharing koan image", e)
        }
    }
}
