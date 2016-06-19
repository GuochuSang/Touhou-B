xof 0302txt 0064
template Header {
 <3D82AB43-62DA-11cf-AB39-0020AF71E433>
 WORD major;
 WORD minor;
 DWORD flags;
}

template Vector {
 <3D82AB5E-62DA-11cf-AB39-0020AF71E433>
 FLOAT x;
 FLOAT y;
 FLOAT z;
}

template Coords2d {
 <F6F23F44-7686-11cf-8F52-0040333594A3>
 FLOAT u;
 FLOAT v;
}

template Matrix4x4 {
 <F6F23F45-7686-11cf-8F52-0040333594A3>
 array FLOAT matrix[16];
}

template ColorRGBA {
 <35FF44E0-6C7C-11cf-8F52-0040333594A3>
 FLOAT red;
 FLOAT green;
 FLOAT blue;
 FLOAT alpha;
}

template ColorRGB {
 <D3E16E81-7835-11cf-8F52-0040333594A3>
 FLOAT red;
 FLOAT green;
 FLOAT blue;
}

template IndexedColor {
 <1630B820-7842-11cf-8F52-0040333594A3>
 DWORD index;
 ColorRGBA indexColor;
}

template Boolean {
 <4885AE61-78E8-11cf-8F52-0040333594A3>
 WORD truefalse;
}

template Boolean2d {
 <4885AE63-78E8-11cf-8F52-0040333594A3>
 Boolean u;
 Boolean v;
}

template MaterialWrap {
 <4885AE60-78E8-11cf-8F52-0040333594A3>
 Boolean u;
 Boolean v;
}

template TextureFilename {
 <A42790E1-7810-11cf-8F52-0040333594A3>
 STRING filename;
}

template Material {
 <3D82AB4D-62DA-11cf-AB39-0020AF71E433>
 ColorRGBA faceColor;
 FLOAT power;
 ColorRGB specularColor;
 ColorRGB emissiveColor;
 [...]
}

template MeshFace {
 <3D82AB5F-62DA-11cf-AB39-0020AF71E433>
 DWORD nFaceVertexIndices;
 array DWORD faceVertexIndices[nFaceVertexIndices];
}

template MeshFaceWraps {
 <4885AE62-78E8-11cf-8F52-0040333594A3>
 DWORD nFaceWrapValues;
 Boolean2d faceWrapValues;
}

template MeshTextureCoords {
 <F6F23F40-7686-11cf-8F52-0040333594A3>
 DWORD nTextureCoords;
 array Coords2d textureCoords[nTextureCoords];
}

template MeshMaterialList {
 <F6F23F42-7686-11cf-8F52-0040333594A3>
 DWORD nMaterials;
 DWORD nFaceIndexes;
 array DWORD faceIndexes[nFaceIndexes];
 [Material]
}

template MeshNormals {
 <F6F23F43-7686-11cf-8F52-0040333594A3>
 DWORD nNormals;
 array Vector normals[nNormals];
 DWORD nFaceNormals;
 array MeshFace faceNormals[nFaceNormals];
}

template MeshVertexColors {
 <1630B821-7842-11cf-8F52-0040333594A3>
 DWORD nVertexColors;
 array IndexedColor vertexColors[nVertexColors];
}

template Mesh {
 <3D82AB44-62DA-11cf-AB39-0020AF71E433>
 DWORD nVertices;
 array Vector vertices[nVertices];
 DWORD nFaces;
 array MeshFace faces[nFaces];
 [...]
}

Header{
1;
0;
1;
}

Mesh {
 64;
 -7.14383;2.98646;0.68745;,
 -3.70382;2.98646;0.68745;,
 -3.70382;-0.45354;0.68745;,
 -7.14383;-0.45354;0.68745;,
 -7.14381;2.98439;0.93299;,
 -3.70383;2.98439;0.93299;,
 -3.70383;-0.47259;-0.78701;,
 -7.14381;-0.47259;-0.78701;,
 -7.08522;2.70971;1.26305;,
 -3.76243;3.15488;0.49200;,
 -3.76243;0.17575;-1.22801;,
 -7.08522;-0.26942;-0.45694;,
 -7.08522;3.15488;0.49200;,
 -3.76243;2.70971;1.26305;,
 -3.76243;-0.26942;-0.45694;,
 -7.08522;0.17575;-1.22801;,
 -3.54515;2.98646;0.68646;,
 -0.10515;2.98646;0.68646;,
 -0.10515;-0.45354;0.68646;,
 -3.54515;-0.45354;0.68646;,
 -3.54513;2.98439;0.93199;,
 -0.10515;2.98439;0.93199;,
 -0.10515;-0.47259;-0.78800;,
 -3.54513;-0.47259;-0.78800;,
 -3.48654;2.70971;1.26205;,
 -0.16375;3.15488;0.49100;,
 -0.16375;0.17575;-1.22900;,
 -3.48654;-0.26942;-0.45794;,
 -3.48654;3.15488;0.49100;,
 -0.16375;2.70971;1.26205;,
 -0.16375;-0.26942;-0.45794;,
 -3.48654;0.17575;-1.22900;,
 0.12063;2.98646;0.68745;,
 3.56063;2.98646;0.68745;,
 3.56063;-0.45354;0.68745;,
 0.12063;-0.45354;0.68745;,
 0.12064;2.98439;0.93299;,
 3.56063;2.98439;0.93299;,
 3.56063;-0.47259;-0.78701;,
 0.12064;-0.47259;-0.78701;,
 0.17924;2.70971;1.26305;,
 3.50202;3.15488;0.49200;,
 3.50202;0.17575;-1.22801;,
 0.17924;-0.26942;-0.45694;,
 0.17924;3.15488;0.49200;,
 3.50202;2.70971;1.26305;,
 3.50202;-0.26942;-0.45694;,
 0.17924;0.17575;-1.22801;,
 3.69436;2.98646;0.68745;,
 7.13437;2.98646;0.68745;,
 7.13437;-0.45354;0.68745;,
 3.69436;-0.45354;0.68745;,
 3.69438;2.98439;0.93299;,
 7.13437;2.98439;0.93299;,
 7.13437;-0.47259;-0.78701;,
 3.69438;-0.47259;-0.78701;,
 3.75297;2.70971;1.26305;,
 7.07576;3.15488;0.49200;,
 7.07576;0.17575;-1.22801;,
 3.75297;-0.26942;-0.45694;,
 3.75297;3.15488;0.49200;,
 7.07576;2.70971;1.26305;,
 7.07576;-0.26942;-0.45694;,
 3.75297;0.17575;-1.22801;;
 
 16;
 4;0,1,2,3;,
 4;4,5,6,7;,
 4;8,9,10,11;,
 4;12,13,14,15;,
 4;16,17,18,19;,
 4;20,21,22,23;,
 4;24,25,26,27;,
 4;28,29,30,31;,
 4;32,33,34,35;,
 4;36,37,38,39;,
 4;40,41,42,43;,
 4;44,45,46,47;,
 4;48,49,50,51;,
 4;52,53,54,55;,
 4;56,57,58,59;,
 4;60,61,62,63;;
 
 MeshMaterialList {
  3;
  16;
  0,
  1,
  2,
  2,
  0,
  1,
  2,
  2,
  0,
  1,
  2,
  2,
  0,
  1,
  2,
  2;;
  Material {
   0.300000;0.300000;0.300000;1.000000;;
   5.000000;
   0.100000;0.100000;0.100000;;
   0.150000;0.150000;0.150000;;
   TextureFilename {
    "Tree1.tga";
   }
  }
  Material {
   0.300000;0.300000;0.300000;1.000000;;
   5.000000;
   0.100000;0.100000;0.100000;;
   0.150000;0.150000;0.150000;;
   TextureFilename {
    "Tree2.tga";
   }
  }
  Material {
   0.300000;0.300000;0.300000;1.000000;;
   5.000000;
   0.100000;0.100000;0.100000;;
   0.150000;0.150000;0.150000;;
   TextureFilename {
    "Tree3.tga";
   }
  }
 }
 MeshNormals {
  13;
  0.000000;0.000000;-1.000000;,
  0.000000;0.445454;-0.895305;,
  -0.258820;0.482962;-0.836516;,
  0.258820;0.482962;-0.836516;,
  0.000000;0.445452;-0.895306;,
  -0.258819;0.482962;-0.836517;,
  0.258819;0.482962;-0.836517;,
  0.000000;0.445454;-0.895305;,
  -0.258821;0.482962;-0.836516;,
  0.258821;0.482962;-0.836516;,
  0.000000;0.445454;-0.895305;,
  -0.258820;0.482962;-0.836516;,
  0.258820;0.482962;-0.836516;;
  16;
  4;0,0,0,0;,
  4;1,1,1,1;,
  4;2,2,2,2;,
  4;3,3,3,3;,
  4;0,0,0,0;,
  4;4,4,4,4;,
  4;5,5,5,5;,
  4;6,6,6,6;,
  4;0,0,0,0;,
  4;7,7,7,7;,
  4;8,8,8,8;,
  4;9,9,9,9;,
  4;0,0,0,0;,
  4;10,10,10,10;,
  4;11,11,11,11;,
  4;12,12,12,12;;
 }
 MeshTextureCoords {
  64;
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;,
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;,
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;,
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;,
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;,
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;,
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;,
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;,
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;,
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;,
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;,
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;,
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;,
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;,
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;,
  0.000000;0.000000;,
  1.000000;0.000000;,
  1.000000;1.000000;,
  0.000000;1.000000;;
 }
}
