using System.Collections;
using System.Collections.Generic;
using RockVR.Video;
using UnityEngine;

public class Main : MonoBehaviour {
    bool doCompute = true;

    public Material mPlayground;
    public Material mCursor;
    private bool recording;
    public static Vector2 uMouse;
    public static Main instance;
    private ComputeShader compute;
    private RenderTexture tempDestination;

	// Use this for initialization
	void Start () {
        // instance = this;
        GetComponent<VideoCapture>();
        var _ = VideoCaptureCtrl.instance;
        RockVR.Video.PathConfig.SaveFolder = @"C:/Users/Yaktori/Documents/GitHub/shady/Captures/";
        // RockVR.Video.PathConfig.SaveFolder = @"/Users/lerp/Shady/Captures/";
        var script = UnityEditor.AssetDatabase.LoadMainAssetAtPath(
            "Assets/Sketches/s01Random.cs") as UnityEditor.MonoScript;
        gameObject.AddComponent(script.GetClass());

        compute = UnityEditor.AssetDatabase.LoadMainAssetAtPath(
            // "Assets/temp.compute") as ComputeShader;
            "Assets/Sketches/sHelloCompute.compute") as ComputeShader;
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
        mPlayground.SetFloat("uTime", Time.time);
        mPlayground.SetFloat("uRecording", recording ? 1 : 0);
        uMouse = Input.mousePosition;
        uMouse.x /= Screen.width;
        uMouse.y /= Screen.height;
        mPlayground.SetVector("uMouse", uMouse);
	}

    void OnRenderImage(RenderTexture src, RenderTexture dest) {
        if (doCompute)
        {
            Compute(src, dest);
            return;
        }
        mCursor.SetVector("uMouse", MouseUV());
        Graphics.Blit(src, dest, mPlayground);
        // Graphics.Blit(src, dest, mCursor);
    }

    void Compute(RenderTexture src, RenderTexture dest) {
        int kernelHandle = compute.FindKernel("CSMain");

        // do we need to create a new temporary destination render texture?
        if (null == tempDestination || src.width != tempDestination.width
            || src.height != tempDestination.height)
        {
            if (null != tempDestination)
            {
                tempDestination.Release();
            }
            tempDestination = new RenderTexture(src.width, src.height,
                src.depth);
            tempDestination.enableRandomWrite = true;
            tempDestination.Create();
        }
        Graphics.Blit(src, tempDestination);

        int rCount = 16;
        int aCount = 16;
        int groupSizeX = 8;
        int groupSizeY = 8;

        compute.SetVector("uResolution",
            new Vector2(tempDestination.width, tempDestination.height));
        compute.SetFloat("rCount", rCount);
        compute.SetFloat("aCount", aCount);
        compute.SetFloat("uTime", Time.time);
        compute.SetTexture(kernelHandle, "Source", src);
        compute.SetTexture(kernelHandle, "Destination", tempDestination);
        compute.Dispatch(kernelHandle, rCount / groupSizeX, aCount / groupSizeY, 1);
        Graphics.Blit(tempDestination, dest);
    }

    public static Vector2 MouseUV()
    {
        return new Vector2(Input.mousePosition.x / Screen.width,
            Input.mousePosition.y / Screen.height);
    }
}
