@Entry
@Component
struct Index {

  build() {
    Column() {
    }
    .width('100%')
    .height('100%')
  }
}


class GradeCount {
  A: number = 0
  B: number = 0
  C: number = 0
  D: number = 0
  E: number = 0
}

// 声明学生成绩数组
let scoreList: Array<number | string> = [95, 88, 72, 59, 105, -5, '80', 92, 66, 78]
// 存放学生有效成绩的数组
let validScores: number[] = []
// 统计学生等级人数的对象
let gradeCount: GradeCount = new GradeCount()

// 1. 过滤无效成绩（while）
let i: number = 0
while (i < scoreList.length) {
  // 取出下标为i的元素
  let score = scoreList[i]
  if (typeof score === 'number' && score >= 0 && score <= 100) {
    validScores.push(score) // 成绩有效 放入数组
  }
  i++
}

// 2. 成绩统计
let maxScore: number = validScores[0]
let minScore: number = validScores[0]
let sumScore: number = 0

for (let j: number = 0; j < validScores.length; j++) {
  let score: number = validScores[j]
  sumScore += score
  if (score > maxScore) { maxScore = score}
  if (score < minScore) { minScore = score}
}

console.info('最高分：' + maxScore)
console.info('最低分：' + minScore)
console.info('总分：' + sumScore)

// 3. 等级统计（for...of + switch）
for (let score of validScores) {
  let grade: string = ''

  if (score >= 90 && score <= 100) { grade = 'A'}
  else if (score >= 80) { grade = 'B'}
  else if (score >= 70) { grade = 'C'}
  else if (score >= 60) { grade = 'D'}
  else { grade = 'E'}

  switch (grade) {
    case 'A': gradeCount.A++
      break
    case 'B': gradeCount.B++
      break
    case 'C': gradeCount.C++
      break
    case 'D': gradeCount.D++
      break
    case 'E': gradeCount.E++
      break
    default:
      break
  }
}

console.info('等级统计结果：')
console.info('A等级人数：' + gradeCount.A)
console.info('B等级人数：' + gradeCount.B)
console.info('C等级人数：' + gradeCount.C)
console.info('D等级人数：' + gradeCount.D)
console.info('E等级人数：' + gradeCount.E)


