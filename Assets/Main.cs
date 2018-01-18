using System.Collections;
using System.Collections.Generic;
using RockVR.Video;
using UnityEngine;

public class Main : MonoBehaviour {
    public Material mPlayground;
    public Material mCursor;
    private bool recording;
    public static Vector2 uMouse;

	// Use this for initialization
	void Start () {
        bool a = VideoCaptureCtrl.instance.debug;
        GetComponent<VideoCapture>().customPathFolder = @"C:/Users/Yaktori/Documents/GitHub/shady/Captures/";
	}

	// Update is called once per frame
	void Update () {
        if (Input.GetKeyDown(KeyCode.O) && !recording) {
            GetComponent<VideoCapture>().StartCapture();
            recording = true;
            Debug.Log("Start recording.");

        } else if (Input.GetKeyDown(KeyCode.P) && recording) {
            GetComponent<VideoCapture>().StopCapture();
            recording = false;
            Debug.Log("Stop recording.");
        }
        mPlayground.SetFloat("uTime", Time.time);
        mPlayground.SetFloat("uRecording", recording ? 1 : 0);
        uMouse = Input.mousePosition;
        uMouse.x /= Screen.width;
        uMouse.y /= Screen.height;
        mPlayground.SetVector("uMouse", uMouse);
        s01Random.Update(mPlayground);
	}

    void OnRenderImage(RenderTexture src, RenderTexture dest) {
        
        mCursor.SetVector("uMouse", MouseUV());
        Graphics.Blit(src, dest, mPlayground);
        // Graphics.Blit(src, dest, mCursor);
    }

    public static Vector2 MouseUV()
    {
        return new Vector2(Input.mousePosition.x / Screen.width,
            Input.mousePosition.y / Screen.height);
    }
}
