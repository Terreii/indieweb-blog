import { Controller } from "@hotwired/stimulus"
import "trix"
import "@rails/actiontext"

// Connects to data-controller="trix"
export default class extends Controller {
  connect() {
    Trix.config.blockAttributes.heading1.tagName = "h2"
  }
}
