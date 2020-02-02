<?php

namespace calendar;

class Color
{
    // material design quick color reference: https://www.materialui.co/colors
    public static $colors = array(
        0 => array(
            "#FFCDD2", "#F8BBD0", "#E1BEE7", "#D1C4E9", "#C5CAE9", "#BBDEFB", "#B3E5FC", "#B2EBF2", "#B2DFDB",
            "#C8E6C9", "#DCEDC8", "#F0F4C3", "#FFECB3", "#FFE0B2", "#FFCCBC", "#D7CCC8", "#CFD8DC",
        ),
        1 => array(
            "#EF5350", "#EC407A", "#AB47BC", "#7E57C2", "#5C6BC0", "#1E88E5", "#039BE5", "#0097A7", "#009688",
            "#43A047", "#689F38", "#9E9D24", "#FF8F00", "#F57C00", "#FF7043", "#8D6E63", "#78909C",
        )
    );

    /**
     * Randomly selects a text/background color combination.
     *
     * @param $textColor
     * @param $backgroundColor
     */
    public static function getRandomColors(&$textColor, &$backgroundColor)
    {
        $combination = rand(0, 1);
        $backgroundColor = self::$colors[$combination][rand(0, count(self::$colors[$combination]) - 1)];
        $textColor = $combination ? "#FFFFFF" : "#333333";
    }

    /**
     * Prints all the color combinations on the screen for preview purposes.
     */
    public static function test()
    {
        for ($i = 0; $i < 2; $i++) {
            for ($j = 0; $j < count(self::$colors[$i]); $j++) {
                $bg = self::$colors[$i][$j];
                $tx = $i ? "#FFFFFF" : "#333333";
                echo "<div style='float:left;text-align:center;padding:20px;min-width:100px;background:$bg'>".
                    "<span style='color:$tx'>$bg</span></div>";
            }
            echo "<div style='clear:both'></div>";
        }
        exit();
    }
}