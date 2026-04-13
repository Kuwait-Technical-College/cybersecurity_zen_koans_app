package com.kuwaitdevs.cybersecurityzenkoans.ui.components

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.kuwaitdevs.cybersecurityzenkoans.data.KoanWithExplanation
import com.kuwaitdevs.cybersecurityzenkoans.ui.theme.DeepMaroon
import com.kuwaitdevs.cybersecurityzenkoans.ui.theme.LotusWhite
import com.kuwaitdevs.cybersecurityzenkoans.ui.theme.MeditationBlue
import com.kuwaitdevs.cybersecurityzenkoans.ui.theme.SaffronOrange
import com.kuwaitdevs.cybersecurityzenkoans.ui.theme.ZenGold

@Composable
fun KoanCard(
    koanWithExplanation: KoanWithExplanation,
    modifier: Modifier = Modifier
) {
    val isDark = isSystemInDarkTheme()
    val cardBackground = if (isDark) MeditationBlue else LotusWhite
    val cardContent = if (isDark) SaffronOrange else DeepMaroon
    val dividerColor = if (isDark) SaffronOrange.copy(alpha = 0.3f) else DeepMaroon.copy(alpha = 0.2f)
    val elevationColor = if (isDark) LotusWhite.copy(alpha = 0.18f) else DeepMaroon.copy(alpha = 0.10f)

    Card(
        modifier = modifier
            .fillMaxWidth()
            .padding(16.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 8.dp),
        colors = CardDefaults.cardColors(
            containerColor = cardBackground,
            contentColor = cardContent
        ),
    ) {
        Column(
            modifier = Modifier.padding(20.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // Koan Text
            Text(
                text = koanWithExplanation.koanText,
                style = MaterialTheme.typography.bodyLarge,
                fontFamily = FontFamily.Monospace,
                textAlign = TextAlign.Center,
                color = cardContent
            )

            HorizontalDivider(
                modifier = Modifier.padding(vertical = 16.dp),
                color = dividerColor
            )

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = koanWithExplanation.technicalExplanation,
                style = MaterialTheme.typography.bodyMedium,
                color = cardContent.copy(alpha = 0.85f),
                textAlign = TextAlign.Start,
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(16.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.Center,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "#${koanWithExplanation.uniqueCode}",
                    style = MaterialTheme.typography.labelMedium,
                    color = ZenGold
                )
                Spacer(modifier = Modifier.width(12.dp))
            }
        }
    }
}