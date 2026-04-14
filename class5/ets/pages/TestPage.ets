

// 导入实体模块中的所有会员类
import { VipMember, SuperVipMember, Member } from '../entity/Member';
// 导入工具模块中的泛型管理器
import { GenericManager } from '../utils/GenericManager';

@Entry
@Component
struct TestPage {

  // ---- 创建两个泛型工具类实例 ----
  // 泛型为 VipMember：专门管理 VIP 会员
  private vipManager: GenericManager<VipMember> = new GenericManager<VipMember>();
  // 泛型为 SuperVipMember：专门管理超级 VIP 会员
  private superVipManager: GenericManager<SuperVipMember> = new GenericManager<SuperVipMember>();

  // 用于在页面上显示的文本内容
  @State displayText: string = '';

  /**
   * 页面初始化：创建会员对象并添加到管理器
   */
  aboutToAppear() {
    // ---- 创建多个 VIP 会员对象 ----
    const vip1 = new VipMember('V001', '张三', 1500, '13800001111');
    const vip2 = new VipMember('V002', '李四', 2300, '13900002222');
    const vip3 = new VipMember('V003', '王五', 800);  // 不填手机号

    // ---- 将 VIP 会员添加到 vipManager ----
    this.vipManager.add(vip1);
    this.vipManager.add(vip2);
    this.vipManager.add(vip3);

    // ---- 创建多个超级 VIP 会员对象 ----
    const svip1 = new SuperVipMember('S001', '赵六', 5000, '13700003333');
    const svip2 = new SuperVipMember('S002', '钱七', 8800, '13600004444');
    const svip3 = new SuperVipMember('S003', '孙八', 12000); // 不填手机号

    // ---- 将超级 VIP 会员添加到 superVipManager ----
    this.superVipManager.add(svip1);
    this.superVipManager.add(svip2);
    this.superVipManager.add(svip3);

    // ---- 构建显示内容 ----
    let result = '';

    // 获取所有 VIP 会员数据并遍历
    result += '======== VIP 会员列表 ========\n';
    const vipList = this.vipManager.getAll();
    for (const vip of vipList) {
      result += vip.getFullInfo() + '\n';
    }

    // 获取所有超级 VIP 会员数据并遍历
    result += '\n====== 超级VIP 会员列表 ======\n';
    const superVipList = this.superVipManager.getAll();
    for (const svip of superVipList) {
      result += svip.getFullInfo() + '\n';
    }

    // 显示会员总数（静态方法调用）
    result += `\n当前会员总数：${Member.getTotalCount()} 人`;

    // 演示 findById 查询功能
    result += '\n\n======== 查询演示 ========\n';
    const found = this.vipManager.findById('V002');
    if (found) {
      result += `查询 V002 结果：${found.getFullInfo()}\n`;
    }
    const notFound = this.vipManager.findById('V999');
    result += `查询 V999 结果：${notFound === undefined ? '未找到该会员' : notFound.getFullInfo()}`;

    this.displayText = result;
  }

  build() {
    Column() {
      Text('会员信息管理系统')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 16 })

      Scroll() {
        Text(this.displayText)
          .fontSize(14)
          .lineHeight(24)
          .padding(16)
          .width('100%')
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}