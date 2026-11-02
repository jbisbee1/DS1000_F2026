// DS 1000 EDB 4: renders one dataset's codebook. Shared by index.html (side sheet)
// and codebook.html (standalone page). Needs MENU (edb4_menu.js) and PROFILES (edb4_profiles.js).
const CB_RAW = "https://github.com/jbisbee1/DS1000_F2026/raw/main/data/";
const cbEsc = s => String(s ?? "").replace(/[&<>"]/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;"}[c]));

// columns offered in the claim builder: every documented column except IDs and leftovers
function cbColumns(d) { return d && d.cols ? Object.keys(d.cols).filter(k => !(d.skip || []).includes(k)) : []; }

function cbLoad(f) {
  const fn = /\.csv$/i.test(f) ? "read_csv" : "read_rds";
  return `library(tidyverse)\ndat <- ${fn}("${CB_RAW}${f}")`;
}

function cbTable(d, f) {
  const p = (typeof PROFILES !== "undefined" && PROFILES[f]) || null;
  const names = p ? p.cols.map(c => c.name) : Object.keys(d.cols);
  const prof = n => p ? p.cols.find(c => c.name === n) : null;
  return `<table class="cbt"><thead><tr><th>Column</th><th>What it is</th><th>Values in the data</th><th>Missing</th></tr></thead><tbody>${names.map(n => {
    const c = prof(n), skip = (d.skip || []).includes(n);
    return `<tr class="${skip ? "cbskip" : ""}"><td><code>${cbEsc(n)}</code></td><td>${cbEsc(d.cols[n] || "")}</td>
      <td>${c ? `<span class="cbty">${cbEsc(c.type)}</span> ${cbEsc(c.summary)}` : ""}</td>
      <td class="cbmiss ${c && c.missing >= 20 ? "hi" : ""}">${c ? c.missing + "%" : ""}</td></tr>`;
  }).join("")}</tbody></table>`;
}

// opts.dataUrl: relative path to the data folder for download links
function cbDataset(d, opts = {}) {
  const dataUrl = opts.dataUrl || "../../data/";
  const multi = d.files.length > 1;
  const rows = (typeof PROFILES !== "undefined") ? d.files.map(f => PROFILES[f] ? PROFILES[f].rows.toLocaleString("en-US") : "?") : [];
  return `<div class="cb">
  <p class="cbabout">${cbEsc(d.about)}</p>
  <dl class="cbfacts">
   <dt>One row is</dt><dd>${cbEsc(d.row)}</dd>
   <dt>Rows</dt><dd>${multi ? d.files.map((f, i) => `${cbEsc(f)}: ${rows[i]}`).join(" · ") : cbEsc(rows[0] || d.n)}</dd>
   <dt>Coverage</dt><dd>${cbEsc(d.coverage)}</dd>
   <dt>Source</dt><dd>${cbEsc(d.source)}</dd>
   <dt>Seen in class</dt><dd>${cbEsc(d.seen)}</dd>
  </dl>
  <h4>Known problems</h4>${d.cautions.map(c => `<div class="cau">${cbEsc(c)}</div>`).join("")}
  ${d.files.map(f => `<h4>${multi ? cbEsc(f) : "Every column"}</h4>
   <div class="cbload"><pre>${cbEsc(cbLoad(f))}</pre><a href="${dataUrl + f}" download>Download ${cbEsc(f)}</a></div>
   <div class="cbwrap">${cbTable(d, f)}</div>`).join("")}
  <p class="cbnote">Grey rows are IDs or leftovers and are not offered in the claim builder. Missing at 20% or more is highlighted.</p>
  <h4>Example questions</h4><p class="cbnote">Illustrative only; your claim should be your own.</p>
  <ul class="cbideas">${d.ideas.map(q => `<li>${cbEsc(q)}</li>`).join("")}</ul>
 </div>`;
}

const CB_CSS = `
.cb{font-size:.88rem}
.cbabout{margin:4px 0 8px}
.cbfacts{display:grid;grid-template-columns:max-content 1fr;gap:3px 12px;margin:0 0 10px}
.cbfacts dt{font-weight:700;color:#444}.cbfacts dd{margin:0}
.cb h4{margin:14px 0 6px;font-size:.92rem}
.cbload{display:flex;gap:10px;align-items:center;flex-wrap:wrap;margin:4px 0 6px}
.cbload pre{margin:0;background:#1f2a44;color:#f5f5f4;padding:6px 10px;border-radius:6px;font-size:.76rem;overflow-x:auto;max-width:100%}
.cbwrap{overflow-x:auto}
table.cbt{border-collapse:collapse;width:100%;font-size:.8rem;margin:4px 0}
table.cbt th{text-align:left;background:#eef0f4;padding:4px 6px;position:sticky;top:0}
table.cbt td{border-top:1px solid #e0dede;padding:4px 6px;vertical-align:top}
table.cbt td:first-child{white-space:nowrap}
table.cbt code{font-family:Consolas,Menlo,monospace;font-size:.78rem;font-weight:700}
tr.cbskip td{color:#8a8a8a}tr.cbskip code{font-weight:400}
.cbty{display:inline-block;font-size:.68rem;text-transform:uppercase;letter-spacing:.04em;color:#616061;border:1px solid #ccc;border-radius:3px;padding:0 3px;margin-right:3px}
.cbmiss{white-space:nowrap;text-align:right}.cbmiss.hi{color:#b3261e;font-weight:700}
.cbnote{font-size:.78rem;color:#616061;margin:4px 0}
.cbideas{margin:4px 0;padding-left:20px}
`;
