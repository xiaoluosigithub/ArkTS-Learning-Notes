// pages/Index.ets

import { Member, VipMember, SuperVipMember, BaseMember } from '../entity/Member'
import { GenericManager } from '../utils/GenericManager'

// 全局样式
@Styles function pageBackground() {
  .width('100%')
  .height('100%')
  .backgroundColor('#F5F7FA')
  .padding(15)
}

@Styles function memberCardStyle() {
  .width('100%')
  .backgroundColor('#FFFFFF')
  .borderRadius(12)
  .padding(15)
  .margin({ bottom: 10 })
}

// 扩展原生组件样式
@Extend(Text) function memberNameStyle() {
  .fontSize(18)
  .fontWeight(FontWeight.Bold)
  .fontColor('#333333')
}

@Extend(Text) function pageTitleStyle() {
  .fontSize(26)
  .fontWeight(FontWeight.Bold)
  .fontColor('#1677FF')
  .margin({ bottom: 15 })
}

@Extend(Button) function primaryBtnStyle() {
  .width('80%')
  .height(40)
  .backgroundColor('#1677FF')
  .borderRadius(20)
  .margin({ top: 10 })
}

// 会员信息展示
@Builder function infoRow(label: string, value: string | number) {
  Row() {
    Text(label)
      .fontSize(14)
      .fontColor('#888888')
      .width(75)
      .textAlign(TextAlign.Start)
    Text(value.toString())
      .fontSize(14)
      .fontColor('#333333')
      .layoutWeight(1)
      .textAlign(TextAlign.Start)
  }
  .width('100%')
  .margin({ bottom: 6 })
  .alignItems(VerticalAlign.Center)
}

// 会员详情弹窗
@CustomDialog
struct MemberDetailDialog {
  memberId: string = ''
  memberName: string = ''
  memberLevel: string = ''
  memberPhone: string = ''
  memberPoints: number = 0
  controller: CustomDialogController = new CustomDialogController({
    builder: MemberDetailDialog()
  })

  build() {
    Column() {
      // 弹窗标题
      Text('会员详情')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1677FF')
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ bottom: 20 })

      // 信息列表 —— 左对齐
      Column() {
        infoRow('ID：', this.memberId)
        infoRow('姓名：', this.memberName)
        infoRow('会员等级：', this.memberLevel)
        infoRow('手机号：', this.memberPhone)
        infoRow('会员积分：', this.memberPoints)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)

      // 关闭按钮
      Button('关闭弹窗')
        .primaryBtnStyle()
        .onClick(() => {
          this.controller.close()
        })
    }
    .width('85%')
    .padding({ top: 24, bottom: 24, left: 20, right: 20 })
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .alignItems(HorizontalAlign.Center)
  }
}

// 会员卡片组件
@Component
struct MemberCard {
  memberId: string = ''
  memberName: string = ''
  memberLevel: string = ''
  memberPhone: string = ''
  memberPoints: number = 0
  onCardClick: () => void = () => {}

  build() {
    Column() {
      // 头像（居中）
      Image($r('app.media.startIcon'))
        .width(64)
        .height(64)
        .borderRadius(32)
        .margin({ bottom: 8 })

      // 姓名（居中）
      Text(this.memberName)
        .memberNameStyle()
        .textAlign(TextAlign.Center)
        .margin({ bottom: 10 })

      // 信息列表（左对齐）
      Column() {
        infoRow('等级：', this.memberLevel)
        infoRow('积分：', this.memberPoints)
        infoRow('手机号：', this.memberPhone)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .memberCardStyle()
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.onCardClick()
    })
  }
}

// 主页面组件
@Entry
@Component
struct Index {
  // 泛型工具类
  private manager: GenericManager<Member> = new GenericManager<Member>()

  // 驱动 UI 的会员列表
  @State memberList: Member[] = []

  // 弹框控制器
  private dialogController: CustomDialogController | null = null

  // 页面初始化：向 manager 添加 3 个会员
  aboutToAppear() {
    this.manager.add(new Member('10001', '张三', 888, '13800138000'))
    this.manager.add(new VipMember('10002', '李四', 1688, '13900139000'))
    this.manager.add(new SuperVipMember('10003', '王五', 366, '13700137000'))
    this.memberList = this.manager.getAll()
  }

  // 点击卡片时动态创建弹框并打开
  openMemberDialog(item: Member) {
    // 解析等级文字
    let levelText = '普通会员'
    if (item.getDiscount() === 0.8) levelText = 'VIP会员'
    if (item.getDiscount() === 0.6) levelText = '超级VIP'

    this.dialogController = new CustomDialogController({
      builder: MemberDetailDialog({
        memberId: item.getId(),
        memberName: item.getFullInfo().match(/姓名：([^，]+)/)?.[1] ?? '',
        memberLevel: levelText,
        memberPhone: item.getFullInfo().match(/电话：([^，]+)/)?.[1] ?? '未填写',
        memberPoints: Number(item.getFullInfo().match(/积分：(\d+)/)?.[1] ?? 0)
      }),
      autoCancel: true,
      alignment: DialogAlignment.Center,
      offset: { dx: 0, dy: 0 }
    })
    this.dialogController.open()
  }

  build() {
    Column() {
      // 页面标题
      Text('会员信息管理中心')
        .pageTitleStyle()

      // 会员卡片列表
      ForEach(this.memberList, (item: Member) => {
        MemberCard({
          memberId: item.getId(),
          memberName: item.getFullInfo().match(/姓名：([^，]+)/)?.[1] ?? '',
          memberLevel: item.getDiscount() === 0.6 ? '超级VIP' :
            item.getDiscount() === 0.8 ? 'VIP会员' : '普通会员',
          memberPhone: item.getFullInfo().match(/电话：([^，]+)/)?.[1] ?? '未填写',
          memberPoints: Number(item.getFullInfo().match(/积分：(\d+)/)?.[1] ?? 0),
          onCardClick: () => {
            this.openMemberDialog(item)
          }
        })
      }, (item: Member) => item.getId())

      // 刷新按钮
      Button('刷新会员列表')
        .primaryBtnStyle()
        .onClick(() => {
          this.memberList = [...this.manager.getAll()].reverse()
        })
    }
    .pageBackground()
    .alignItems(HorizontalAlign.Center)
  }
}
