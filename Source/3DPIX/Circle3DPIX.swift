//
//  Circle3DPIX.swift
//  VertexKit
//
//  Created by Anton Heestand on 2018-09-22.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics
#if os(iOS)
import PixelKit
#elseif os(macOS)
import PixelKit_macOS
#endif
import Metal

public class Circle3DPIX: _3DPIX {
    
    public var circRes: Res = .custom(w: 64, h: 16) { didSet { setNeedsRender() } }
    public var radius: CGFloat = 0.1 { didSet { setNeedsRender() } }

//    public override var instanceCount: Int {
//        return (circRes.w * circRes.h) / 2
//    }
    public override var vertices: [PixelKit.Vertex] {
        return circ()
    }
    public override var primativeType: MTLPrimitiveType {
        return .line
    }
    
    public required init(res: PIX.Res) {
        super.init(res: res)
    }
    
    func circ() -> [PixelKit.Vertex] {
        var verts: [PixelKit.Vertex] = []
        for j in 0..<circRes.h {
            let fj = CGFloat(j) / CGFloat(circRes.h - 1)
            for i in 0..<circRes.w {
                let fi = CGFloat(i) / CGFloat(circRes.w - 1)
                let pi = fi * .pi * 2
                let vert = PixelKit.Vertex(x: LiveFloat((cos(pi) / res.aspect.cg) * radius * 2 * fj), y: LiveFloat(sin(pi) * radius * 2 * fj), z: 0.0, s: 0.0, t: 0.0)
                verts.append(vert)
            }
        }
        return verts
    }
    
}
