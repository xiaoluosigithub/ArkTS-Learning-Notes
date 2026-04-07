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

// 员工抽象类
abstract class AbstractEmployee {

  static totalCount: number = 0; // 总员工数量
  protected employeeId: string; // 员工id
  protected employeeName: string; // 员工姓名
  protected department: string; // 部门
  protected baseSalary: number; // 基础薪资

  // 构造函数
  constructor()
  constructor(employeeId: string)
  constructor(employeeId: string, employeeName: string)
  constructor(employeeId: string, employeeName: string, department: string)
  constructor(employeeId: string, employeeName: string, department: string, baseSalary: number)
  // 实现签名
  constructor(employeeId?: string, employeeName?: string, department?: string, baseSalary?: number) {
    this.employeeId   = employeeId   ?? 'N/A';
    this.employeeName = employeeName ?? '未知';
    this.department   = department   ?? '未分配';
    this.baseSalary   = baseSalary   ?? 0;
    // 每次创建员工对象时统计人数
    AbstractEmployee.totalCount++;
  }

  // 获取员工数量
  static getEmployeeCount(): number {
    return AbstractEmployee.totalCount;
  }
  // 抽象方法：输出员工信息
  abstract printInfo(): void;
  // 抽象方法：计算薪资
  abstract calculateSalary(): number;
}

// 正式员工
class FullTimeEmployee extends AbstractEmployee {
  // 员工奖金
  private bonus: number;
  getBonus(): number {return this.bonus;}
  setBonus(bonus: number): void {this.bonus = bonus;}

  // 构造方法
  constructor(employeeId: string, employeeName: string, department: string, baseSalary: number, bonus: number) {
    super(employeeId, employeeName, department, baseSalary);
    this.bonus = bonus;
  }

  // 输出信息
  printInfo(): void {
    console.log(
      `[正式员工] ID: ${this.employeeId} | 姓名: ${this.employeeName}` +
        ` | 部门: ${this.department} | 底薪: ${this.baseSalary}` +
        ` | 奖金: ${this.bonus} | 总薪资: ${this.calculateSalary()}`
    );
  }

  // 计算薪资（底薪 + 奖金）
  calculateSalary(): number {
    return this.baseSalary + this.bonus;
  }
}
// 兼职员工
class PartTimeEmployee extends AbstractEmployee {
  private workHours: number; // 工时
  getWorkHours(): number {return this.workHours;}
  setWorkHours(workHours: number): void {this.workHours = workHours;}

  private hourlyRate: number; // 时薪
  getHourlyRate(): number {return this.hourlyRate;}
  setHourlyRate(hourlyRate: number): void {this.hourlyRate = hourlyRate;}

  constructor(employeeId: string, employeeName: string, department: string, workHours: number, hourlyRate: number) {
    super(employeeId, employeeName, department, 0);
    this.workHours  = workHours;
    this.hourlyRate = hourlyRate;
  }

  // 打印信息
  printInfo(): void {
    console.log(
      `[兼职员工] ID: ${this.employeeId} | 姓名: ${this.employeeName}` +
        ` | 部门: ${this.department} | 工时: ${this.workHours}h` +
        ` | 时薪: ${this.hourlyRate} | 总薪资: ${this.calculateSalary()}`
    );
  }

  // 薪资计算
  calculateSalary(): number {
    return this.workHours * this.hourlyRate;
  }
}
// 实习员工
class InternEmployee extends AbstractEmployee {

  private allowance: number; // 补贴
  getAllowance(): number {return this.allowance;}
  setAllowance(allowance: number): void {this.allowance = allowance;}

  constructor(employeeId: string, employeeName: string, department: string, allowance: number) {
    super(employeeId, employeeName, department, 0);
    this.allowance = allowance;
  }

  // 打印信息
  printInfo(): void {
    console.log(
      `[实习员工] ID: ${this.employeeId} | 姓名: ${this.employeeName}` +
        ` | 部门: ${this.department} | 补贴: ${this.allowance}` +
        ` | 总薪资: ${this.calculateSalary()}`
    );
  }
  // 薪资计算
  calculateSalary(): number {
    return this.allowance;
  }
}
// 员工管理类
class EmployeeManager {
  // 员工集合
  private employees: AbstractEmployee[] = [];
  getEmployees(): AbstractEmployee[] {  return this.employees;}
  // 添加员工
  addEmployee(employee: AbstractEmployee): void {
    this.employees.push(employee);
  }

  // 筛选正式员工
  getFullTimeEmployees(): FullTimeEmployee[] {
    let result: FullTimeEmployee[] = [];
    for (let emp of this.employees) {
      if (emp instanceof FullTimeEmployee) {
        result.push(emp);
      }
    }
    return result;
  }
}



const manager = new EmployeeManager();

const emp1 = new FullTimeEmployee('FT001', '张三', '研发部', 15000, 5000);
const emp2 = new FullTimeEmployee('FT002', '李四', '产品部', 12000, 3000);
const emp3 = new PartTimeEmployee('PT001', '王五', '市场部', 80, 120);
const emp4 = new PartTimeEmployee('PT002', '赵六', '运营部', 60, 100);
const emp5 = new InternEmployee('IN001', '孙七', '研发部', 3000);
const emp6 = new InternEmployee('IN002', '周八', '人事部', 2500);

manager.addEmployee(emp1);
manager.addEmployee(emp2);
manager.addEmployee(emp3);
manager.addEmployee(emp4);
manager.addEmployee(emp5);
manager.addEmployee(emp6);

console.log(`\n========== 员工管理系统 ==========`);
console.log(`当前员工总数：${AbstractEmployee.getEmployeeCount()} 人`);

console.log(`\n---------- 所有正式员工信息 ----------`);
for (let emp of manager.getFullTimeEmployees()) {
  emp.printInfo();
}

console.log(`\n---------- 所有员工信息 ----------`);
for (let emp of manager.getEmployees()) {
  emp.printInfo();
}



