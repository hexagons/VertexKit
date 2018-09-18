//
//  3DPIX.swift
//  3D
//
//  Created by Hexagons on 2018-09-13.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import UIKit
import Pixels

public class _3DPIX: PIXGenerator, PixelsCustomGeometryDelegate {

    override open var shader: String { return "contentGeneratorColorPIX" }
    
    var root: _3DRoot
    
    public var radius: CGFloat = 0.1 { didSet { setNeedsRender() } }

    public var color: UIColor = .green { didSet { setNeedsRender() } }
    enum CodingKeys: String, CodingKey {
        case color
    }
    override public var uniforms: [CGFloat] {
        var vals: [CGFloat] = []
        vals.append(contentsOf: PIX.Color(color).list)
        return vals
    }

    public override init(res: PIX.Res) {
        root = Pixels3D.main.engine.createRoot(at: res.size)
        super.init(res: res)
//        Pixels.main.wireframeMode = true
        customGeometryActive = true
        customGeometryDelegate = self
    }

    // MARK: JSON

//    required convenience init(from decoder: Decoder) throws {
//        self.init(res: ._128) // CHECK
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        color = try container.decode(PIX.Color.self, forKey: .color).ui
//        setNeedsRender()
//    }
//
//    override public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(PIX.Color(color), forKey: .color)
//    }
    
    // MAKR: Corenr Pin
    
    public func customVertecies() -> Pixels.Vertecies? {
//        return gridVerts(res: .fullScreen / 128)
        return circVerts(res: .custom(w: 64, h: 16))
    }
    
    func gridVerts(res: Res) -> Pixels.Vertecies? {

        let verteciesRaw = grid(res: res)
        let verteciesMapped = mapGrid(verteciesRaw, res: res)
        var vertexBuffers: [Float] = []
        for vertex in verteciesMapped {
            vertexBuffers += vertex.buffer
        }
        
        let vertexBuffersSize = vertexBuffers.count * MemoryLayout<Float>.size
        let verteciesBuffer = Pixels.main.metalDevice.makeBuffer(bytes: vertexBuffers, length: vertexBuffersSize, options: [])!
        
        let instanceCount = ((res.w + 1) * (res.h + 1)) / 3
        
        return Pixels.Vertecies(buffer: verteciesBuffer, vertexCount: verteciesMapped.count, instanceCount: instanceCount)
    
    }
    
    func circVerts(res: Res) -> Pixels.Vertecies? {

        let vertecies = circ(res: res)
        var vertexBuffers: [Float] = []
        for vertex in vertecies {
            vertexBuffers += vertex.buffer
        }

        let vertexBuffersSize = vertexBuffers.count * MemoryLayout<Float>.size
        let verteciesBuffer = Pixels.main.metalDevice.makeBuffer(bytes: vertexBuffers, length: vertexBuffersSize, options: [])!

        let instanceCount = vertecies.count / 2

        return Pixels.Vertecies(buffer: verteciesBuffer, vertexCount: vertecies.count, instanceCount: instanceCount, type: .line)

    }
    
    func scale(_ point: CGPoint, by scale: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scale, y: point.y * scale)
    }
    
    func add(_ pointA: CGPoint, _ pointB: CGPoint) -> CGPoint {
        return CGPoint(x: pointA.x + pointB.x, y: pointA.y + pointB.y)
    }
    
    func circ(res: Res) -> [Pixels.Vertex] {
        var verts: [Pixels.Vertex] = []
        for j in 0..<res.h {
            let fj = Float(j) / Float(res.h - 1)
            for i in 0..<res.w {
                let fi = Float(i) / Float(res.w - 1)
                let pi = fi * .pi * 2
                let vert = Pixels.Vertex(x: (cos(pi) / Float(Res.fullScreen.aspect)) * Float(radius) * 2 * fj, y: sin(pi) * Float(radius) * 2 * fj, z: 0.0, s: 0.0, t: 0.0)
                verts.append(vert)
            }
        }
        return verts
    }
    
    func grid(res: Res) -> [[Pixels.Vertex]] {
        
        var verts: [[Pixels.Vertex]] = []
        for y in 0...res.h {
            let v = CGFloat(y) / res.height
            var vertRow: [Pixels.Vertex] = []
            for x in 0...res.w {
                let u = CGFloat(x) / res.width
                let vert = Pixels.Vertex(x: Float(u * 2 - 1.0), y: Float(v * 2 - 1.0), z: 0.0, s: Float(u), t: Float(v))
                vertRow.append(vert)
            }
            verts.append(vertRow)
        }
        
        return verts
        
    }
    
    func mapGrid(_ vertecies: [[Pixels.Vertex]], res: Res) -> [Pixels.Vertex] {
        var verteciesMap: [Pixels.Vertex] = []
        for y in 0..<res.h {
            for x in 0..<res.w {
                let vertexBottomLeft = vertecies[y][x]
                let vertexTopLeft = vertecies[y][x + 1]
                let vertexBottomRight = vertecies[y + 1][x]
                let vertexTopRight = vertecies[y + 1][x + 1]
                verteciesMap.append(vertexTopLeft)
                verteciesMap.append(vertexTopRight)
                verteciesMap.append(vertexBottomLeft)
                verteciesMap.append(vertexBottomRight)
                verteciesMap.append(vertexBottomLeft)
                verteciesMap.append(vertexTopRight)
            }
        }
        return verteciesMap
    }
    
}
