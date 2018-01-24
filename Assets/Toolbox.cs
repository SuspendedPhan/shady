using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Toolbox
{
    public static string GetUniqueFilename()
    {
        return DateTime.Now.ToString("yyyy-MM-dd-HH-mm-ss");
    }
}
