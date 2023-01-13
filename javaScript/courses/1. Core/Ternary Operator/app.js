let num = 2;
if (num === 7) {
  console.log("lucky");
} else {
  console.log("unlucky");
}

num === 7 ? console.log("lucky") : console.log("unlucky");

let status = "offline";

let color = status === "offline" ? "red" : "green";
// Doesn't post to console so won't show when running in debug
