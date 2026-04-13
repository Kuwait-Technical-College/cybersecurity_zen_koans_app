package com.kuwaitdevs.cybersecurityzenkoans

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Bundle
import android.os.Handler
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import com.kuwaitdevs.cybersecurityzenkoans.ui.components.ZenKoanApp
import com.kuwaitdevs.cybersecurityzenkoans.ui.theme.CybersecurityZenKoansTheme
import com.kuwaitdevs.cybersecurityzenkoans.viewmodel.KoanViewModel
import kotlin.math.abs

class MainActivity : ComponentActivity(), SensorEventListener {

    private lateinit var sensorManager: SensorManager
    private var accelerometer: Sensor? = null
    private var lastUpdate: Long = 0
    private var lastX = 0.0f
    private var lastY = 0.0f
    private var lastZ = 0.0f
    private val SHAKE_THRESHOLD = 1000

    // Debounce variables
    private var lastShakeTime: Long = 0
    private val DEBOUNCE_TIME = 1500  // 1.5 seconds debounce time

    // ViewModel instance
    private val koanViewModel: KoanViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize sensor manager and accelerometer
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)

        enableEdgeToEdge()

        setContent {
            CybersecurityZenKoansTheme {
                val koanWithExplanation by koanViewModel.currentKoanWithExplanation.observeAsState()
                val showAnimation by koanViewModel.showAnimation.observeAsState(false)
                val showShakeMessage by koanViewModel.showShakeMessage.observeAsState(true)
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    ZenKoanApp(
                        modifier = Modifier.padding(innerPadding),
                        koanWithExplanation = koanWithExplanation,
                        showAnimation = showAnimation,
                        showShakeMessage = showShakeMessage,
                        onShake = {
                            koanViewModel.refreshKoan()
                            koanViewModel.hideShakeMessage()
                            Handler(mainLooper).postDelayed({
                                koanViewModel.resetAnimation()
                            }, 500)
                        }
                    )
//                    LaunchedEffect( koanWithExplanation) {
//                        koanViewModel.refreshKoan()
//                        koanViewModel.hideShakeMessage()
//                        koanViewModel.resetAnimation()
//                    }
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        accelerometer?.let {
            sensorManager.registerListener(this, it, SensorManager.SENSOR_DELAY_NORMAL)
        }
    }

    override fun onPause() {
        super.onPause()
        sensorManager.unregisterListener(this)
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event?.sensor?.type == Sensor.TYPE_ACCELEROMETER) {
            val currentTime = System.currentTimeMillis()
            if ((currentTime - lastUpdate) > 100) {
                val diffTime = currentTime - lastUpdate
                lastUpdate = currentTime

                val x = event.values[0]
                val y = event.values[1]
                val z = event.values[2]

                val speed = abs(x + y + z - lastX - lastY - lastZ) / diffTime * 10000

                if (speed > SHAKE_THRESHOLD) {
                    val shakeTime = System.currentTimeMillis()
                    // Check for debounce
                    if (shakeTime - lastShakeTime > DEBOUNCE_TIME) {
                        // Use ViewModel to refresh koan
                        koanViewModel.refreshKoan()
                        koanViewModel.hideShakeMessage()
                        
                        Log.d("Shake", "Device shaken, requesting new koan from ViewModel")

                        // Reset animation flag after a short delay
                        Handler(mainLooper).postDelayed({
                            koanViewModel.resetAnimation()
                        }, 500)

                        // Update last shake time
                        lastShakeTime = shakeTime
                    } else {
                        Log.d("Shake", "Shake ignored due to debounce (${shakeTime - lastShakeTime}ms < ${DEBOUNCE_TIME}ms)")
                    }
                }

                lastX = x
                lastY = y
                lastZ = z
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // Not needed for this implementation
    }
}