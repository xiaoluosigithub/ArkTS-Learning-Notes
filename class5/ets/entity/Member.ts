// entity/Member.ts

import { IMember, MemberType } from '../common/IMember';

// 抽象类
export abstract class BaseMember implements IMember {

  protected id: string;
  getId(): string {return this.id;}
  protected name: string;
  protected phone?: string;

  constructor(id: string, name: string, phone?: string) {
    this.id = id;
    this.name = name;
    this.phone = phone;
  }
  abstract getDiscount(): number;
  abstract getFullInfo(): string;
}

// 普通会员类
export class Member extends BaseMember {

  // 统计会员总数
  private static totalCount: number = 0;
  // 累计会员积分
  protected points: number;

  constructor(id: string, name: string, points: number, phone?: string) {
    super(id, name, phone);
    this.points = points;
    Member.totalCount++; // 统计会员数
  }
  // 返回会员总数
  static getTotalCount(): number {
    return Member.totalCount;
  }

  getDiscount(): number {
    return 1.0; // 无折扣
  }

  getFullInfo(): string {
    const phoneInfo = this.phone ? this.phone : '未填写';
    return `【普通会员】编号：${this.id}，姓名：${this.name}，` +
      `电话：${phoneInfo}，积分：${this.points}，折扣：无折扣`;
  }
}

// VIP会员类
export class VipMember extends Member {

  constructor(id: string, name: string, points: number, phone?: string) {
    super(id, name, points, phone);
  }

  getDiscount(): number {
    return 0.8; // 打8折
  }

  getFullInfo(): string {
    const phoneInfo = this.phone ? this.phone : '未填写';
    const discountInfo = `${this.getDiscount() * 10}折`;
    return `【VIP会员】编号：${this.id}，姓名：${this.name}，` +
      `电话：${phoneInfo}，积分：${this.points}，折扣：${discountInfo}`;
  }
}

//  超级 VIP 会员类
export class SuperVipMember extends Member {

  constructor(id: string, name: string, points: number, phone?: string) {
    super(id, name, points, phone);
  }

  getDiscount(): number {
    return 0.6; // 打6折
  }

  getFullInfo(): string {
    const phoneInfo = this.phone ? this.phone : '未填写';
    const discountInfo = `${this.getDiscount() * 10}折`;
    return `【超级VIP】编号：${this.id}，姓名：${this.name}，` +
      `电话：${phoneInfo}，积分：${this.points}，折扣：${discountInfo}`;
  }
}
