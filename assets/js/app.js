import LiveSocket from "phoenix_live_view"

import '../css/app.css'

let liveSocket = new LiveSocket("/live")
liveSocket.connect()