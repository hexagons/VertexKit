<img src="https://github.com/hexagons/pixels-3d/raw/master/Assets/Pixels-3D_logo_1k_bg.png" width="128"/>

# VertexKit

[![License](https://img.shields.io/cocoapods/l/VertexKit.svg)](https://github.com/hexagons/VertexKit/blob/master/LICENSE)
[![Cocoapods](https://img.shields.io/cocoapods/v/VertexKit.svg)](http://cocoapods.org/pods/VertexKit)
[![Platform](https://img.shields.io/cocoapods/p/VertexKit.svg)](http://cocoapods.org/pods/VertexKit)
<img src="https://img.shields.io/badge/in-swift5.0-orange.svg">

a Framework for iOS & macOS<br>
written in Swift & Metal<br>
an extension of [PixelKit](https://github.com/hexagons/pixelkit)<br>

## Install

`pod 'VertexKit'`

`import VertexKit`

## Particle Example

<img src="https://github.com/hexagons/VertexKit/blob/master/Assets/Images/vertexkit-particle-noise.png?raw=true" width="256"/>

```
view.wantsLayer = true
view.layer!.backgroundColor = .black

PixelKit.main.bits = ._16

let pres: PIX.Res = .square(Int(sqrt(1_000_000)))

let noise = NoisePIX(res: pres)
noise.colored = true
noise.octaves = 5
noise.zPosition = .live * 0.1

let particles = ParticlesUV3DPIX(res: .cgSize(view.bounds.size) * 2)
particles.vtxPixIn = noise - 0.5
particles.color = LiveColor(lum: 1.0, a: 0.1)

let final: PIX = particles
final.view.frame = view.bounds
final.view.checker = false
view.addSubview(final.view)
```
