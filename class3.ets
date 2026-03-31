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


// ==================== 数据声明 ====================

// 数据常量
const DEFAULT_CATEGORY: string = "未分类";
const MAX_PRICE: number = 99;

// 闭包函数
function createGenerator(): () => number {
  let id: number = 0;
  let g = (): number => {
    return ++id;
  };
  return g;
}
const generateId = createGenerator();

class BookInfo {
  id: number;
  title: string;
  author: string;
  price: number;
  category: string;

  constructor( id: number, title: string, author: string, price: number, category: string = DEFAULT_CATEGORY
  ) {
    this.id = id;
    this.title = title;
    this.author = author;
    this.price = price;
    this.category = category;
  }

  // 图书价格打折函数
  discount = (rate: number): number => {
    return parseFloat((this.price * rate).toFixed(2));
  };

  // 图书信息输出函数
  printInfo = (): void => {
    let info: string =
      `ID: ${this.id} | 书名: ${this.title} | 作者: ${this.author} | 价格: ${this.price}元`;
    if (this.category) {
      info += ` | 分类: ${this.category}`;
    }
    console.log(info);
  };

  // 图书涨价函数
  raisePrice = (amount: number = 10): void => {
    const newPrice = this.price + amount;
    this.price = newPrice > MAX_PRICE ? MAX_PRICE : newPrice;
  };
}

// 图书管理业务类 BookManage
class BookManage {
  // 图书数组
  private books: BookInfo[] = [];

  // 添加图书方法
  addBooks = (...newBooks: BookInfo[]): void => {
    newBooks.forEach((book) => {
      this.books.push(book);
    });
    console.log(`成功添加 ${newBooks.length} 本图书。`);
  };

  // 删除图书方法（根据 ID 删除）
  deleteBook = (id: number): void => {
    const index = this.books.findIndex((book) => book.id === id);
    if (index === -1) {
      console.log(`删除失败：ID 为 ${id} 的图书不存在。`);
    } else {
      const removed = this.books.splice(index, 1);
      console.log(`已成功删除图书：《${removed[0].title}》`);
    }
  };

  // 获取所有图书
  getAllBooks = (): BookInfo[] => {
    return this.books;
  };
}

// ==================== 业务数据测试 ====================

// 创建 4 本图书对象，通过闭包函数对图书 ID 赋值
const book1 = new BookInfo(generateId(), "HarmonyOS应用开发实战", "张三", 89, "技术");
const book2 = new BookInfo(generateId(), "ArkTS编程指南", "李四", 75, "技术");
const book3 = new BookInfo(generateId(), "设计模式之禅", "王五", 65);       // 使用默认分类
const book4 = new BookInfo(generateId(), "深入理解计算机系统", "赵六", 95, "计算机基础");

// 任选一本图书通过打折函数改变图书价格（book1 打八折）
console.log(`\n===== 图书打折测试 =====`);
console.log(`《${book1.title}》打折前价格：${book1.price} 元`);
book1.price = book1.discount(0.8);
console.log(`《${book1.title}》打八折后价格：${book1.price} 元`);

// 创建图书管理对象，添加 4 本图书
console.log(`\n===== 添加图书 =====`);
const manager = new BookManage();
manager.addBooks(book1, book2, book3, book4);

// 测试涨价功能
console.log(`\n===== 涨价测试 =====`);
console.log(`《${book4.title}》涨价前：${book4.price} 元`);
book4.raisePrice(); // 默认涨 10 元，但不超过 MAX_PRICE(99)
console.log(`《${book4.title}》涨价后：${book4.price} 元（最高限价 ${MAX_PRICE} 元）`);

// 测试删除功能
console.log(`\n===== 删除图书测试 =====`);
manager.deleteBook(2);         // 正常删除
manager.deleteBook(99);        // 删除不存在的 ID

// 获取所有图书，通过循环遍历输出图书信息
console.log(`\n===== 所有图书信息 =====`);
const allBooks = manager.getAllBooks();
for (let i = 0; i < allBooks.length; i++) {
  allBooks[i].printInfo();
}

// 额外演示：输出不含分类的图书信息
console.log(`\n===== 图书信息（不含分类）=====`);
allBooks.forEach((book) => {
  book.printInfo();
});

