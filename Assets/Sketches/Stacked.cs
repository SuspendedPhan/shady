using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Stacked : MonoBehaviour
{
	public LiveRectMb liveRectMbPrefab;
	public Shader noiseShader;

    // Start is called before the first frame update
    void Start()
    {
    	{
	        var liveRect = Instantiate(liveRectMbPrefab);
	        var rect = liveRect.Rect;
	        rect.size = new Vector2(2f, 2f);
	        rect.center = Vector2.zero;
	        liveRect.Rect = rect;
	        liveRect.GetComponent<Renderer>().material.shader = noiseShader;
	    }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
