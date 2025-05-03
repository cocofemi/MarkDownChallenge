import { jsPDF } from "jspdf";

let Hooks = {};

Hooks.RenderHook = {
  mounted() {
    this.handleEvent("export-pdf", ({ html }) => {
      const doc = new jsPDF();
      doc.html(html, {
        callback: () => doc.save("markdown_export.pdf"),
      });
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
