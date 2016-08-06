welcomeMessage = require("./../structure/templates/welcomeMessageTemplate.pug")
welcomeMessageContainer = document.querySelector "[welcomeMessage]"
welcomeMessageContainer.innerHTML = welcomeMessage({yourName: "Stan"})

setTimeout ->
  welcomeMessageContainer.classList.add "active"
, 200
