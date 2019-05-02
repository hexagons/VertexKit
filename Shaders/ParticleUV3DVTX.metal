//
//  ParticleUV3DVTX.metal
//  Pixels3DShaders
//
//  Created by Anton Heestand on 2019-05-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    packed_float3 position;
    packed_float2 texCoord;
};

struct VertexOut{
    float4 position [[position]];
    float pointSize [[point_size]];
};

struct Uniforms {
    float size;
    float resx;
    float resy;
    float aspect;
};

vertex VertexOut particleUV3DVTX(const device VertexIn* vertices [[ buffer(0) ]],
                                 unsigned int vid [[ vertex_id ]],
                                 const device Uniforms& in [[ buffer(1) ]],
                                 texture2d<float> inTex [[ texture(0) ]],
                                 sampler s [[ sampler(0) ]]) {
    
    int ux = vid % int(in.resx);
    int vy = int(float(vid) / in.resx);
    float u = float(ux) / in.resx;
    float v = float(vy) / in.resy;
    float2 uv = float2(u, v);
    float4 c = inTex.sample(s, uv);
    float x = (c.r / in.aspect) * 2;
    float y = c.g * 2;
    float z = c.b * 2;

    VertexOut vtxOut;
    vtxOut.position = float4(x, y, z, 1);
    vtxOut.pointSize = in.size;
    
    return vtxOut;
}
