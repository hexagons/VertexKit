//
//  Pixel3DProtocol.swift
//  VertexKit
//
//  Created by Hexagons on 2019-01-21.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Foundation
import simd

public protocol VertexCustom3DRenderDelegate {
    func update(cameraMatrix: simd_float4x4, projectionMatrix: simd_float4x4)
}
