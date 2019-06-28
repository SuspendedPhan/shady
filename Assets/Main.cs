using System.Collections;
using System.Collections.Generic;
using RockVR.Video;
using UnityEngine;

public class Main : MonoBehaviour {
    private bool recording;
    public static Main instance;

	// Use this for initialization
	void Start () {
        GetComponent<VideoCapture>();
        var _ = VideoCaptureCtrl.instance;
        RockVR.Video.PathConfig.SaveFolder = @"C:/Users/Yaktori/Documents/GitHub/shady/Captures/";
        // RockVR.Video.PathConfig.SaveFolder = @"/Users/lerp/Shady/Captures/";
	}


	// Update is called once per frame
	void Update () {
        instance = this;
        if (Input.GetKeyDown(KeyCode.O) && !recording) {
            GetComponent<VideoCapture>().StartCapture();
            recording = true;
            Debug.Log("Start recording.");

        } else if (Input.GetKeyDown(KeyCode.P) && recording) {
            GetComponent<VideoCapture>().StopCapture();
            recording = false;
            Debug.Log("Stop recording.");
        } else if (Input.GetKeyDown(KeyCode.C)) {
            ScreenCapture.CaptureScreenshot("Captures/" + Toolbox.GetUniqueFilename() + ".png");
            Debug.Log("Captured screenshot!");
        }
	}

    // public static Vector2 MouseUV()
    // {
    //     return new Vector2(Input.mousePosition.x / Screen.width,
    //         Input.mousePosition.y / Screen.height);
    // }
}
