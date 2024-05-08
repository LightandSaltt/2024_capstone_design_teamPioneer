const open = document.querySelector("open");
const modlaBox = document.querySelector("#modal-box");
const close = document.querySelector("#close");

open.addEventListener("click", () => {
  modlaBox.classList.add("active");
});

close.addEventListener("click", () => {
  modlaBox.classList.remove("active");
});
