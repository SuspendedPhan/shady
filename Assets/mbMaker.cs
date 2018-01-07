using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class mbMaker : MonoBehaviour {
    private class Triangle {
        public Vector3[] vertices;
        public int[] vertexIndices;
        public Color color;
        public Vector3 normal;
    }

    private List<Triangle> tris = new List<Triangle>();

	// Use this for initialization
	void Start () {
        var mesh = GetComponent<MeshFilter>().mesh;

        for (int i = 0; i < 20; i++) {
            var tri = new Triangle();
            tri.color = Color.blue;
            var trianglePos =
                transform.position + Random.onUnitSphere * 3;
            tri.vertices = new Vector3[] {
                trianglePos + Random.onUnitSphere * 2,
                trianglePos + Random.onUnitSphere * 2,
                trianglePos + Random.onUnitSphere * 2
            };
            var centroid = (tri.vertices[0] + tri.vertices[1] + tri.vertices[2]) / 3;
            tri.normal = Vector3.Cross(tri.vertices[1] - tri.vertices[0],
                tri.vertices[2] - tri.vertices[0]);
            // if (Vector3.Dot(tri.normal, Camera.main.transform.forward) > 0)
            if (Vector3.Dot(tri.normal, centroid - Camera.main.transform.position) > 0)
            {
                tri.normal = -tri.normal;
                tri.vertexIndices = new int[] { i * 3 + 2, i * 3 + 1, i * 3};
            }
            else
            {
                tri.vertexIndices = new int[] { i * 3, i * 3 + 1, i * 3 + 2};
            }
            // var tri2 = new Triangle();
            // tri2.vertices = tri.vertices
            tris.Add(tri);
        }
        var vertices = new List<Vector3>();
        var normals = new List<Vector3>();
        var colors = new List<Color>();
        var vertexIndices = new List<int>();

        foreach (var tri in tris) {
            vertices.AddRange(tri.vertices);
            normals.Add(tri.normal);
            normals.Add(tri.normal);
            normals.Add(tri.normal);
            colors.Add(tri.color);
            colors.Add(tri.color);
            colors.Add(tri.color);
            vertexIndices.AddRange(tri.vertexIndices);
        }

        mesh.Clear();
        mesh.vertices = vertices.ToArray();
        mesh.normals = normals.ToArray();
        mesh.colors = colors.ToArray();
        mesh.triangles = vertexIndices.ToArray();
	}

	// Update is called once per frame
	void Update () {

	}
}
