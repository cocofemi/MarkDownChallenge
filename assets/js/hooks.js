import { jsPDF } from "jspdf";

let Hooks = {};

Hooks.RenderHook = {
  mounted() {
    this.handleEvent("export-pdf", ({ url }) => {
      const link = document.createElement("a");
      link.href = url;
      link.download = "";
      document.body.appendChild(link);
      link.click();
      link.remove();
    });

    this.handleEvent("copy-html", ({ html }) => {
      const temp = document.createElement("div");
      temp.innerHTML = html;
      document.body.appendChild(temp);
      const range = document.createRange();
      range.selectNode(temp);
      window.getSelection().removeAllRanges();
      window.getSelection().addRange(range);
      document.execCommand("copy");
      document.body.removeChild(temp);

      //Send a message back to LiveView
      this.pushEvent("copied-to-clipboard", {});
    });
  },
};

export default Hooks;
