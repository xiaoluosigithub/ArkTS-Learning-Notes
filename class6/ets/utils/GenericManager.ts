// utils/GenericManager.ts

// 泛型约束接口 要求必须包含该方法
interface HasId {
  getId(): string;
}

// 泛型工具类
export class GenericManager<T extends HasId> {

  // 私有数组：存放泛型类型 T 的数据列表
  private dataList: T[] = [];

  // 数组添加
  add(item: T): void {
    this.dataList.push(item);
  }

  // 根据ID进行查找
  findById(id: string): T | undefined {
    return this.dataList.find(item => item.getId() === id);
  }

  // 获取所有数据
  getAll(): T[] {
    return [...this.dataList] ?? [];
  }
}
