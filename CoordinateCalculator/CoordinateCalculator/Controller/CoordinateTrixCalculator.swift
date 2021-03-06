//
//  CoordinateTrixCalculater.swift
//  CoordinateCalculator
//
//  Created by Mrlee on 2017. 11. 7..
//  Copyright © 2017년 Codesquad Inc. All rights reserved.
//

import Foundation

struct Calculator {
    
    func extract(_ pointParser: RawCoordinate) throws -> CoordinateModel {
        let kindOfInputAndPoints = countPointsValue(pointParser.inputCoordinateValue)
        var separatePoints = kindOfInputAndPoints.points
        var dotPoints: [MyPoint] = [MyPoint()]
        dotPoints.remove(at: 0)
        
        for pointsIndex in 0..<separatePoints.count {
            separatePoints[pointsIndex].remove(at: separatePoints[pointsIndex].startIndex)
            separatePoints[pointsIndex].remove(at: separatePoints[pointsIndex].index(before: separatePoints[pointsIndex].endIndex))
            let separateAxisValue = separatePoints[pointsIndex].components(separatedBy: ",").flatMap{ Int($0) }
            if confirm(points: separateAxisValue) {
                let dotPoint = MyPoint(x: separateAxisValue[0], y: separateAxisValue[1])
                dotPoints.append(dotPoint)
            } else {
                throw InputViewError.invalidPoint
            }
        }
        
        let pointModel = CoordinateModel(trixValue: kindOfInputAndPoints.generatrix, points: dotPoints)
        
        do {
           return try sortAndMakePoints(pointModel)
        } catch InputViewError.invalidRectangle {
            throw InputViewError.invalidRectangle
        }
    }
    
    private func countPointsValue(_ coordinateValue: String) -> (generatrix: Generatrixs, points: [String]) {
        var separatePoints = coordinateValue.components(separatedBy: "-")
        var separatePointInfo: Generatrixs {
            get {
                switch separatePoints.count{
                case 1:
                    return Generatrixs.point
                case 2:
                    return Generatrixs.line
                case 3:
                    return Generatrixs.triangle
                case 4:
                    return Generatrixs.rectangle
                default:
                    return Generatrixs.point
                }
            }
        }
        return (separatePointInfo, separatePoints)
    }
    
    private func confirm(points: [Int]) -> Bool {
        if points.isEmpty || points.count == 1 {
            print("다시입력해주세요. 괄호안에는 정수가 와야합니다. :)")
            return false
        }
        for index in 0...1 {
            if points[index] < 0 || points[index] > 24 {
                print("x,y 값은 0 <= x,y <= 24 합니다. :) 다시입력해주세요.")
                return false
            }
        }
        return true
    }
    
    private func checkRectPoints(_ coordinateModel: CoordinateModel) -> Bool {
        if coordinateModel[0].x != coordinateModel[3].x ||
            coordinateModel[0].y != coordinateModel[1].y ||
            coordinateModel[1].x != coordinateModel[2].x ||
            coordinateModel[2].y != coordinateModel[3].y {
            print("다시입력해주세요. 마름모는 입력하실 수 없습니다. :)")
            return false
        }
        return true
    }
    
    private func sortAndMakePoints(_ coordinateModel: CoordinateModel) throws -> CoordinateModel {
        var pointModel = coordinateModel
        switch coordinateModel.generatrix {
        case .point:
            return pointModel
        case .line:
            let line = MyLine(coordinateModel)
            let lineDistance = line.calcurateDistanceTwoPoints()
            pointModel = CoordinateModel(typeResult: lineDistance, model: coordinateModel)
            return pointModel
        case .triangle:
            let triangle = MyTriangle(coordinateModel)
            let triangleArea = triangle.calculateTriangleArea()
            pointModel = CoordinateModel(typeResult: triangleArea, model: coordinateModel)
            return pointModel
        case .rectangle:
            if !checkRectPoints(coordinateModel) {
                throw InputViewError.invalidRectangle
            }
            let rect = MyRect(coordinateModel)
            let rectArea = rect.calculateRectArea()
            pointModel = CoordinateModel(typeResult: rectArea, model: coordinateModel)
            return pointModel
        }
        
    }
}
