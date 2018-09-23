//
//  LineGrid3DPIX.swift
//  Pixels3D
//
//  Created by Anton Heestand on 2018-09-22.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics
import Metal
import Pixels

public class LineGrid3DPIX: Grid3DPIX {
    
    open override var customVertexShaderName: String? { return "distort3DVTX" }
    open override var customVertexTextureActive: Bool { return true }
    open override var customVertexPixIn: (PIX & PIXOut)? { return gridPixIn }
    
    public var gridPixIn: (PIX & PIXOut)? = nil
    /*public*/ var offset: _3DVec = _3DVec(x: 0.125, y: 0.125, z: 0.0)// { didSet { setNeedsRender() } }
    
    public override var vertecies: [Pixels.Vertex] { return gridLines }
    public override var instanceCount: Int { return gridRes.count }
    public override var primativeType: MTLPrimitiveType { return .line }
    
    var gridLines: [Pixels.Vertex]!
    
    public init(res: Res, gridRes: Res, gridSize: CGSize) {
        super.init(res: res)
        self.gridRes = gridRes
        self.gridSize = gridSize
        self.gridLines = makeGridLines()
    }
    
    func makeGridLines() -> [Pixels.Vertex] {
        let gridA = vecGrid()
        let gridB = offset(grid: gridA, by: offset)
        var gridLines: [Pixels.Vertex] = []
        for y in 0..<gridRes.h {
            for x in 0..<gridRes.w {
                let vecA = gridA[y][x]
                let vtxA = Pixels.Vertex(x: vecA.x / res.aspect, y: vecA.y, s: 0.0, t: 0.0)
                let vecB = gridB[y][x]
                let vtxB = Pixels.Vertex(x: vecB.x / res.aspect, y: vecB.y, s: 0.0, t: 0.0)
                gridLines.append(vtxA)
                gridLines.append(vtxB)
            }
        }
        return gridLines
    }
    
    required convenience init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}