package com.kuwaitdevs.cybersecurityzenkoans.ui.components

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.view.View
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Rect as ComposeRect
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.unit.dp
import com.kuwaitdevs.cybersecurityzenkoans.data.KoanWithExplanation
import com.kuwaitdevs.cybersecurityzenkoans.util.ShareUtil
import android.graphics.Rect
import android.view.PixelCopy
import android.app.Activity
import androidx.compose.ui.layout.boundsInRoot
import androidx.compose.ui.text.style.TextAlign
import androidx.core.graphics.createBitmap
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import android.content.Intent
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.IconButtonDefaults
import androidx.compose.material3.TextButton
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.ui.res.stringResource
import com.kuwaitdevs.cybersecurityzenkoans.BuildConfig
import com.kuwaitdevs.cybersecurityzenkoans.R
import androidx.core.net.toUri


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ZenKoanApp(
    modifier: Modifier,
    koanWithExplanation: KoanWithExplanation?,
    showAnimation: Boolean,
    showShakeMessage: Boolean,
    onShake: () -> Unit = {}
) {
    val context = LocalContext.current
    val view = LocalView.current

    var koanCardBounds by remember { mutableStateOf<ComposeRect?>(null) }
    var showAboutSheet by remember { mutableStateOf(false) }

    Surface(
        modifier = modifier.fillMaxSize(),
        color = MaterialTheme.colorScheme.background
    ) {
        Box(
            modifier = Modifier.fillMaxSize()
        ) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(
                        brush = Brush.verticalGradient(
                            colors = listOf(
                                MaterialTheme.colorScheme.primary.copy(alpha = 0.1f),
                                MaterialTheme.colorScheme.background,
                                MaterialTheme.colorScheme.secondary.copy(alpha = 0.1f)
                            )
                        )
                    )
            )

            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(24.dp),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                AnimatedVisibility(
                    visible = !showAnimation,
                    enter = fadeIn(animationSpec = tween(500)),
                    exit = fadeOut(animationSpec = tween(300))
                ) {
                    Box(
                        modifier = Modifier.fillMaxWidth(),
                        contentAlignment = Alignment.Center
                    ) {
                        koanWithExplanation?.let {
                            KoanCard(
                                koanWithExplanation = it,
                                modifier = Modifier.onGloballyPositioned { layoutCoordinates ->
                                    koanCardBounds = layoutCoordinates.boundsInRoot()
                                }
                            )
                        }
                    }
                }

                if (showShakeMessage) {
                    Text(
                        text = stringResource(R.string.shake_your_device_for_a_new_koan),
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.padding(top = 24.dp),
                        textAlign = TextAlign.Center
                    )
                }
            }

            if (!showShakeMessage) {
                Box(
                    modifier = Modifier
                        .align(Alignment.BottomEnd)
                        .padding(24.dp)
                ) {
                    KoanFab(
                        modifier = Modifier,
                        onShareClick = {
                            shareKoanCardAsImage(context, view, koanCardBounds, koanWithExplanation)
                        },
                        onAboutClick = {
                            showAboutSheet = true
                        },
                        onLoadClick = {
                            // Handle Load click
                        }
                    )
                }
            }

            // Debug-only shake button
            if (BuildConfig.DEBUG) {
                Box(
                    modifier = Modifier
                        .align(Alignment.BottomStart)
                        .padding(24.dp)
                ) {
                    IconButton(
                        onClick = onShake,
                        colors = IconButtonDefaults.iconButtonColors(
                            containerColor = MaterialTheme.colorScheme.tertiary.copy(alpha = 0.7f),
                            contentColor = MaterialTheme.colorScheme.onTertiary
                        )
                    ) {
                        Icon(
                            imageVector = Icons.Default.Refresh,
                            contentDescription = "Shake (debug)"
                        )
                    }
                }
            }

            // Replace ModalBottomSheet with AlertDialog for About
            if (showAboutSheet) {
                AlertDialog(
                    onDismissRequest = { showAboutSheet = false },
                    title = {
                        Text(
                            text = stringResource(R.string.cyber_security_zen_koan),
                            style = MaterialTheme.typography.titleMedium,
                            color = MaterialTheme.colorScheme.primary
                        )
                    },
                    text = {
                        Column(
                            horizontalAlignment = Alignment.CenterHorizontally
                        ) {
                            Text(
                                text = "Version: ${2.0}",
                                style = MaterialTheme.typography.bodyMedium,
                                textAlign = TextAlign.Center,
                                modifier = Modifier.padding(top = 8.dp)
                            )
                        }
                    },
                    confirmButton = {
                        Button(
                            onClick = {
                                val intent = Intent(Intent.ACTION_VIEW,
                                    context.getString(R.string.https_github_com_kuwaitdevs_cybersecurity_zen_koans_app).toUri())
                                context.startActivity(intent)
                            }
                        ) {
                            Text(stringResource(R.string.source_code))
                        }
                    },
                    dismissButton = {
                        TextButton(onClick = { showAboutSheet = false }) {
                            Text(stringResource(R.string.close))
                        }
                    }
                )
            }
        }
    }
}

// Helper function to capture the currently displayed KoanCard as an image and share it
fun shareKoanCardAsImage(context: Context, rootView: View, koanCardBounds: ComposeRect?, koanWithExplanation: KoanWithExplanation?) {
    try {
        if (koanCardBounds == null) return

        // Get KoanCard bounds in window (in pixels)
        val left = koanCardBounds.left.toInt()
        val top = koanCardBounds.top.toInt()
        val width = koanCardBounds.width.toInt()
        val height = koanCardBounds.height.toInt()
        val rect = Rect(left, top, left + width, top + height)

        // Create a bitmap of the KoanCard area
        val bitmap = createBitmap(width, height)

        val activity = context as? Activity ?: return

        PixelCopy.request(
            activity.window,
            rect,
            bitmap,
            { copyResult ->
                if (copyResult == PixelCopy.SUCCESS) {
                    ShareUtil.shareKoanCardImage(context, bitmap, koanWithExplanation)
                }
            },
            Handler(Looper.getMainLooper())
        )
    } catch (e: Exception) {
        // fallback: draw cache of the whole rootView and crop
        //rootView.isDrawingCacheEnabled = true
        //val fullBitmap = Bitmap.createBitmap(rootView.drawingCache)
        //rootView.isDrawingCacheEnabled = false
        //val cropped = Bitmap.createBitmap(fullBitmap, left, top, width, height)
        //ShareUtil.shareKoanCardImage(context, cropped, koanWithExplanation)
    }
}