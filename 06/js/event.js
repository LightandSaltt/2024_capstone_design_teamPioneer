const button = document.querySelector("#bttn");

button.addEventListener("click", () => {
  const word = document.querySelector("#word").value;
  const result = document.querySelector("#result");
  let count = word.length;

  result.innerText = `${count}`;
});
