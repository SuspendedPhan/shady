using System.Collections;
using System.Collections.Generic;
using RockVR.Video;
using UnityEngine;

public class s01Random {
    static float offset;
    public static void Update(Material mat) {
        offset += Main.uMouse.y * 100 * Time.deltaTime;
        mat.SetFloat("uOffset", offset);
    }
}
