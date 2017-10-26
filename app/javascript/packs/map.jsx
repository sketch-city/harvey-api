import React from "react"
import ReactDOM from "react-dom"
import SimpleMap from "./components/SimpleMap"

document.addEventListener("DOMContentLoaded", () => {
  ReactDOM.render(<SimpleMap />, document.querySelector("#react-map"))
})
