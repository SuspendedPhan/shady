using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MultiBoxed : MonoBehaviour
{
	public LiveRectMb rectPrefab;
	public float pBoxSize;

	public float pSpeed;

	private LiveRectMb[,] liveRects;
	private int gridWidth = 20;

    // Start is called before the first frame update
    void Start()
    {
    	liveRects = new LiveRectMb[gridWidth, gridWidth];
    	for (var x = 0; x < gridWidth; x++) 
    	{
    		for (var y = 0; y < gridWidth; y++) 
	    	{
	    		var liveRect = Instantiate(rectPrefab);
	    		liveRects[x, y] = liveRect;
	    	}
    	}
    }

    // Update is called once per frame
    void Update()
    {
        for (var x = 0; x < gridWidth; x++) 
    	{
    		for (var y = 0; y < gridWidth; y++) 
	    	{
	    		var liveRect = liveRects[x, y];
	    		var tileWidth = 2.0f / gridWidth;

	    		var rect = new Rect();
    			rect.width = tileWidth * pBoxSize;
    			rect.height = rect.width;

    			var offset = new Vector2(tileWidth / 2f, tileWidth / 2f);
    			// var offset = Vector2.zero;
    			rect.center = new Vector2(Mathf.Lerp(-1, 1, (float) x / gridWidth), Mathf.Lerp(-1, 1, (float) y / gridWidth)) + offset;

    			liveRect.Rect = rect;
	    		liveRects[x, y] = liveRect;
	    	}
    	}
    }

    [ContextMenu("Spark")]
    private void Spark()
    {
		StartCoroutine(Spark(Random.Range(0, 10), Random.Range(0, 10)));
		// yield break;
    	// while (true)
    	// {
	    // 	yield return new WaitForSeconds(1.0f);
    	// }
    }
    
    private IEnumerator Spark(int x, int y)
    {
    	
    	var color = Random.ColorHSV();
    	var pendingWaves = new List<RippleWave>();

    	for (int xDir = -1; xDir <= 1; xDir++)
    	{
    		for (int yDir = -1; yDir <= 1; yDir++) 
			{
				if (xDir == 0 && yDir == 0) continue;
		    	Ripple(new RippleWave(x, y, xDir, yDir, color), pendingWaves);
			}
    	}

    	while (pendingWaves.Count != 0)
    	{
    		yield return new WaitForSeconds(Mathf.Lerp(5f, 0f, pSpeed));
    		var newWaves = new List<RippleWave>();
    		foreach (var wave in pendingWaves)
    		{
    			Ripple(new RippleWave(wave.x, wave.y, wave.xDir, wave.yDir, wave.color), newWaves);
    		}
    		pendingWaves = newWaves;
    	}
    }

    private void Ripple(RippleWave wave, List<RippleWave> mutableNewWaves)
    {
    	Debug.Log(string.Format("x:{0} y:{1} xDir:{2} yDir:{3}", wave.x, wave.y, wave.xDir, wave.yDir));
    	Debug.Assert(wave.xDir != 0 || wave.yDir != 0);
    	if (wave.x < 0 || wave.x == gridWidth) return;
    	if (wave.y < 0 || wave.y == gridWidth) return;

    	liveRects[wave.x, wave.y].Color = wave.color;

    	mutableNewWaves.Add(new RippleWave(wave.x + wave.xDir, wave.y + wave.yDir, wave.xDir, wave.yDir, wave.color));
    	if (Mathf.Abs(wave.xDir) == Mathf.Abs(wave.yDir))
    	{
    		mutableNewWaves.Add(new RippleWave(wave.x + wave.xDir, wave.y, wave.xDir, 0, wave.color));
    		mutableNewWaves.Add(new RippleWave(wave.x, wave.y + wave.yDir, 0, wave.yDir, wave.color));
    	}
    }

    private void Converge()
    {

    }

    class RippleWave
    {
    	public int x;
    	public int xDir;
    	public int y;
    	public int yDir;
    	public Color color;
    	public RippleWave(int x, int y, int xDir, int yDir, Color color) 
    	{
			this.x = x;
			this.xDir = xDir;
			this.y = y;
			this.yDir = yDir;
			this.color = color;
    	}
    }
}
