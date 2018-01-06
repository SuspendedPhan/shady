using System.Collections;
using System.Collections.Generic;
using RockVR.Video;
using UnityEngine;

public class Main : MonoBehaviour {
    public Material mat;
    public Material mat2;
    private bool recording;

	// Use this for initialization
	void Start () {
        bool a = VideoCaptureCtrl.instance.debug;
	}

	// Update is called once per frame
	void Update () {
        if (Input.GetKeyDown(KeyCode.O) && !recording) {
            GetComponent<VideoCapture>().StartCapture();
            recording = true;

        } else if (Input.GetKeyDown(KeyCode.P) && recording) {
            GetComponent<VideoCapture>().StopCapture();
            recording = false;
        }
        mat.SetFloat("uTime", Time.time);
        mat.SetFloat("uRecording", recording ? 1 : 0);
	}

    // void OnRenderImage(RenderTexture src, RenderTexture dest) {
    //     Graphics.Blit(src, dest, mat);
    //     // Graphics.Blit(dest, dest, mat2);
    // }
}
