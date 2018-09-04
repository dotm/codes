typealias LineSegment = (min: Int, max: Int)
func lineSegmentsIntersect(_ segment1: LineSegment, _ segment2:LineSegment) -> Bool{
    if segment1.max <= segment2.min {
        return false
    }else if segment1.min >= segment2.max {
        return false
    }else{
        return true
    }
}
func isRectangleOverlap(_ rec1: [Int], _ rec2: [Int]) -> Bool {
    let xLeft = 0
    let xRight = 2
    let yBottom = 1
    let yTop = 3
    
    let overlap_inDimensionX = lineSegmentsIntersect((min: rec1[xLeft], max: rec1[xRight]), (min: rec2[xLeft], max: rec2[xRight]))
    let overlap_inDimensionY = lineSegmentsIntersect((min: rec1[yBottom], max: rec1[yTop]), (min: rec2[yBottom], max: rec2[yTop]))
    return overlap_inDimensionX && overlap_inDimensionY
}

isRectangleOverlap([7,8,13,15], [10,8,12,20])

