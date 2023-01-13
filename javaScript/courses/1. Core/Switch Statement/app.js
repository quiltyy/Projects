let day = 2;

if (day === 1) {
  console.log("MONDAY");
} else if (day === 2) {
  console.log("TUESDAY");
} else if (day === 3) {
  console.log("WEDNESDAY");
} else if (day === 4) {
  console.log("THURSDAY");
} else if (day === 5) {
  console.log("FRIDAY");
} else if (day === 6) {
  console.log("SATURDAY");
} else if (day === 7) {
  console.log("SUNDAY");
}

switch (day) {
  case 1:
    console.log("Monday");
    break;
  case 2:
    console.log("Tuesday");
    break;
  case 3:
    console.log("Wednesday");
    break;
  case 4:
    console.log("Thursday");
    break;
  case 5:
    console.log("Friday");
    break;
  case 6:
    console.log("Saturday");
    break;
  case 7:
    console.log("Sunday");
    break;
}

let emoji = "sad face";

switch (emoji) {
  case "sad face":
  case "happy face":
    console.log("yellow");
    break;
  case "eggplant":
    console.log("purple");
    break;
  case "heart":
    console.log("red");
    break;
  case "lips":
    console.log("red");
    break;
}
