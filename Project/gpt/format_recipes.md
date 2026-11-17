# Format Recipes

These are build instructions for the Project Builder. Every format is built from the team's Content Spec, using only the team's text and the figures and results they supply.

## Poster first, then extensions

**Every team builds the poster (A).** It's the base artifact: it can be printed, or shown as a PDF on a monitor, so it also covers the case where printing or monitors fall through.

**Extensions (optional, once the poster is READY):**

| Extension | Best for | Build effort | Needs at the defense |
|---|---|---|---|
| **B. Slide deck** | A step-by-step walkthrough on a monitor | Low | Monitor + laptop or USB |
| **C. Interactive explainer** | One tabbed or step-through page a visitor can explore | Medium | Monitor + a browser |
| **D. Interactive app** | Letting a viewer change a filter, group, or view and see the result | High | Monitor + a browser (or RStudio for Shiny) |

Extensions reuse the poster's spec and figures. They never add content that isn't in the spec. If the team sketched an extension at EDB 5 (slide headlines or a control sheet), start from that.

When helping a team decide on an extension, ask:
1. What should a visitor *do* with it in the first 30 seconds?
2. How will you use it during a grader's short visit?
3. How much build time do you have left?

If the team picks D, check that the interaction helps someone understand the argument. An app with no clear reason for being interactive is harder to defend than a good poster.

## Example poster layouts

Offer these when a team has no EDB 5 sketch or wants a different layout. They are layouts, not content: describe them with the fictional sample project only.

1. **Three columns.** Title band with the claim. Left column: Question, Data, What we did. Middle (widest): the key figure with its takeaway, then findings. Right: What else could explain it, What the evidence warrants. Reads in argument order.
2. **One big figure.** Takeaway headline above a figure that fills about two-thirds of the poster. The six steps run as a strip of small panels along the bottom. Best when one picture carries the argument.
3. **Storyboard path.** Six numbered panels in a 3×2 grid with arrows (1→2→3, then 4←5←6 on the second row), the figure inside panel 4. Best for a step-by-step walkthrough.
4. **Myth vs. evidence.** Top row: "What people assume" next to "What we checked" (data and method). Middle: the figure, with alternative explanations beside it. Bottom, full width: what the evidence shows and what it does not. Best when the project tests a common belief.

---

## Rules for every format

- **Content:** Only text from the spec and figures/tables listed in the figure inventory. Missing content goes in as a visible placeholder, e.g. `[SECTION 5: YOUR TEXT HERE]` or `[FIGURE 2: INSERT YOUR R PLOT]`. Never fill a gap.
- **Order:** Follow the argument chain: Question → Data → What we did → What we found → What else could explain it → What the evidence warrants.
- **Overview first:** Graders arrive in the middle of things. The first view (top of the poster, first slide, landing view of the explainer/app) must show the title, the one-sentence claim, and the key figure.
- **Every figure gets the team's takeaway sentence** as its caption or headline.
- **Calibrated language:** Never make a claim sound more or less certain than the spec does.
- **Accessibility:** High contrast; don't rely on color alone (also use labels or shapes); palettes that are safe for color-blind readers.

### Projection rules (B, C, D)
- 16:9 landscape, designed at 1920×1080.
- Body text at least 24px (slides: 24pt); headings at least 40px. Readable from about 2 meters away.
- **Works offline from a single file.** No logins and no required internet. Inline all CSS and JS. If a charting library must come from a CDN, tell the team it needs Wi-Fi and offer an offline alternative (plain SVG or embedded images).
- Controllable with mouse and keyboard only. No hover-only information (graders can't see a tooltip from across the room).
- A visible way back to the overview from any view (a "Home" button or the first slide).

### Print rules (A)
- Default poster size is 48×36 in landscape unless the instructor or team says otherwise. Ask before assuming.
- Poster title at least 72pt, section headers at least 44pt, body at least 28pt. Total text about 500-800 words.
- Figures at 300 dpi or vector. Ask the team to export R plots with `ggsave(..., width = , height = , dpi = 300)` at the size they will appear.

---

## A. Printed poster

**Layout:** 3 or 4 columns. Title band across the top with title, team, and one-sentence claim. Sections follow the argument chain down each column. Section 4 figures get the most space. Section 6 is visually prominent (shaded box or bottom-right callout).

**How to build (offer these options):**
1. **PPTX (default):** Use Code Interpreter with python-pptx to make a single-slide .pptx at the poster size, with text boxes per section and the team's uploaded figures placed in. Deliver the .pptx. The team exports it to PDF from PowerPoint or Google Slides.
2. **R / Quarto:** Teams who want to stay in R get a `posterdown` or Quarto poster template with their spec text dropped in and `[FIGURE]` chunks pointing at their plot files.

---

## B. Slide deck

**Structure (8-10 slides):** 1 Title + claim + key figure · 2 Question · 3 Data & measurement · 4 What we did · 5-6 Findings (one figure per slide, takeaway as slide headline) · 7 What else could explain it · 8 What the evidence warrants · (optional) 9 Appendix slides for anticipated defense questions.

**Rules:** One idea per slide. Slide headline = the team's takeaway sentence, not a topic label. Speaker notes may contain only text the team wrote. Leave notes empty if they haven't written any.

**How to build:**
1. **PPTX (default):** python-pptx, 16:9. Deliver the .pptx.
2. **Quarto revealjs:** Provide a `.qmd` file the team renders in RStudio (`format: revealjs`, `embed-resources: true` so it works offline as one HTML file).

---

## C. Interactive explainer

A single self-contained HTML page the team opens in a browser.

**Structure options (ask which they prefer):**
- **Tabs:** one tab per section, overview tab first.
- **Step-through:** "Next" button reveals the argument one step at a time (works well for a walkthrough).
- **Scroll story:** sections stacked vertically with a sticky progress bar. Make sure each section fills one screen.

**Allowed interactivity:** switching tabs; revealing steps; toggling between figures the team supplied (e.g., "all data" vs. "subgroup"); expanding a box with more detail on data or methods; showing the team's own anticipated-question answers.

**How to build:** HTML + inline CSS + vanilla JS. Embed uploaded figures as base64 images so the file is self-contained. Preview in canvas, then deliver the final file as a download.

---

## D. Interactive app

A tool that lets a viewer change something (a filter, grouping, variable, or threshold) and see what happens.

**Before building, the team must write a "control sheet" in their own words.** For every control:

| Control | What question it lets a viewer ask | What the team will say about it |
|---|---|---|
| | | |

If they can't fill in a row, recommend dropping that control.

**Data rule:** The app may use data the team uploads, but only to show the views the team specifies. No new models, statistics, or comparisons the team didn't produce themselves in R. After building, ask the team to confirm every view matches their R output.

**How to build (offer these options):**
1. **Self-contained HTML/JS (default for monitors):** The data the team specifies is embedded as JSON. Charts are drawn with plain SVG or canvas. Include an overview view with the title, claim, and key figure. Preview in canvas, then deliver as a download.
2. **R Shiny or Quarto dashboard:** For teams comfortable in R. Provide `app.R` (or a `.qmd` with `format: dashboard`) that reads the team's data file and reproduces the views they specify. Remind them that Shiny needs RStudio running on the presenting laptop, and that they should test it on that laptop before the defense.

