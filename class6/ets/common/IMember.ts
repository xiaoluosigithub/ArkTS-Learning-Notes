
// 会员类型枚举
export enum MemberType {
  NORMAL = "普通会员",
  VIP = "VIP会员",
  SUPER_VIP = "超级VIP"
}

// 会员标准规范接口
export interface IMember {
  // 计算会员折扣
  getDiscount(): number;

  // 获取完整会员信息
  getFullInfo(): string;
}