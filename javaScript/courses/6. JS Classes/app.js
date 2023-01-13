class Color {
  constructor(r, g, b, name) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.name = name;
  }
  innerRGB() {
    const { r, g, b } = this;
    return `${r}. ${g}. ${b}`;
  }
  rgb() {
    return `rgb(${this.innerRGB})`;
  }
  hex() {
    const { r, g, b } = this;
    return "# " + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
  }
  rgba(a = 1.0) {
    return `rgba(${this.innerRGB},${a})`;
  }
}

class Pet {
  constructor(name, age) {
    this.name = name;
    this.age = age;
  }
  eat() {
    return `${this.name} is eating!`;
  }
}

class Cat extends Pet {
  constructor(name, age, livesLeft = 9) {
    super(name, age); // Refers to the Pet constructor to pull insto this class for this constructor
    this.livesLeft = livesLeft;
  }
  meow() {
    return `MEOWWW!!`;
  }
}

class Dog extends Pet {
  bark() {
    return "WOOF!!";
  }
  eat() {
    return `${this.name} scarfs his food!`;
  }
}
