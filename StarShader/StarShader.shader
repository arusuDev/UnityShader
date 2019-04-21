Shader "Arusu/StarShader"
{
	Properties
	{
		_Size("Size", float) = 5.0
		_Color("Color",Color) = (0.0,1.0,1.0,1.0)
	}
	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 100

		Cull Off
		Lighting Off

		Pass
		{
			CGPROGRAM
			#pragma target 5.0
			#pragma vertex vert
			#pragma geometry geom 
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform float _Size;
			uniform float4 _Color;
			static const float Double_PI = 3.1415926535f*2.0f;


			struct v2g
			{
				float4 pos : SV_POSITION;
			};

			struct g2f
			{
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};

			v2g vert(appdata_full v)
			{
				v2g o;
				o.pos = v.vertex;

				return o;
			}
			// 星形のポリゴン数は10個。
			[maxvertexcount(30)]
			void geom(triangle v2g input[3], inout TriangleStream<g2f> outStream)
			{

				float4 p0 = input[0].pos;
				float4 p1 = input[1].pos;
				float4 p2 = input[2].pos;
				uint i;
				
				float4 center_fl4 = (p0 + p1 + p2) * 0.33333;
				float4 vertex_fl4[10];
				g2f vertex[10];
				g2f center;
				center.pos = UnityObjectToClipPos(center_fl4);
				center.col = _Color;
				for(i=0;i<10;i++){
					//頂点を0として、
					if(i%2==0){
						vertex_fl4[i] = float4(cos(Double_PI*i/10)*_Size,sin(Double_PI*i/10)*_Size,0.0f,0.0f)+center_fl4;
						vertex[i].pos = UnityObjectToClipPos(vertex_fl4[i]);
						vertex[i].col = _Color;	
					}else{
						vertex_fl4[i] = float4(cos(Double_PI*i/10)*_Size*0.5,sin(Double_PI*i/10)*_Size*0.5,0.0f,0.0f)+center_fl4;
						vertex[i].pos = UnityObjectToClipPos(vertex_fl4[i]);
						vertex[i].col = _Color;
					}
					
				}

				for(i=0;i<9;i++){
					outStream.Append(vertex[i]);
					outStream.Append(vertex[i+1]);
					outStream.Append(center);
					outStream.RestartStrip();
				}

				outStream.Append(vertex[9]);
				outStream.Append(vertex[0]);
				outStream.Append(center);

				outStream.RestartStrip();
			}

			float4 frag(g2f i) : COLOR
			{
				return i.col;
			}
			ENDCG
		}
	}
}
