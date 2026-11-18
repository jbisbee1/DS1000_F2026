# DS 1000 Project Builder (ChatGPT plugin)

This replaces the custom GPT in `../gpt/`, since new GPTs can no longer be created. The content is the same: the GPT instructions became the skill's instructions, and the three knowledge files became the skill's reference files.

```
ds1000-project-builder/
  plugin.json                       name, description, and the four starter prompts
  skills/project-builder/
    SKILL.md                        the instructions (was instructions.txt)
    references/
      content_spec_template.md      (was a knowledge file)
      format_recipes.md             (was a knowledge file)
      boundary_examples.md          (was a knowledge file)
ds1000-project-builder.zip          the same folder, zipped, for uploading
```

## Changes from the GPT version

- `SKILL.md` starts with a short `name` and `description`. ChatGPT reads the description to decide when to use the skill, so it says plainly that it is for DS 1000 project work.
- The instructions now name each reference file and say when to consult it (OpenAI's docs ask for this).
- Mentions of Canvas and Code Interpreter are softened to "if available," because OpenAI's docs don't say which tools plugins get. If file downloads aren't available, it gives the full file contents in a code block instead.
- One line added: it stays in this role for the rest of the conversation once a team starts.
- "Project Builder GPT" is now "Project Builder" in the reference copies. The originals in `../gpt/` are unchanged.

## Setting it up (based on OpenAI's documentation; I haven't been able to try it myself)

1. In ChatGPT, open **Plugins** and select **Add (+)**. This opens a conversation with Plugin Creator.
2. Attach `SKILL.md` and the three reference files (or the zip), and ask: "Create a plugin from these files. Use SKILL.md as the skill's instructions, word for word, and the three markdown files as its reference files."
3. Review what it made: the name, description, instructions and reference files. Check that the instructions weren't shortened or reworded.
4. Test it in a new conversation by typing **@** and choosing the plugin. OpenAI says to test in both Chat and Work, since the available tools differ. Use the pre-launch tests in `../gpt/README.md`, especially the requests it should decline.
5. Share it. New plugins start private.

## Open questions (OpenAI's help-center pages blocked automated reading, so these are unconfirmed)

- **Can students use it?** OpenAI's developer docs say workspace plugins can't be used by accounts outside the workspace. If students have Vanderbilt ChatGPT accounts in the same workspace as yours, sharing should work. If they use personal accounts, it may not. Please check the sharing options when you get to step 5.
- **Do students need to install it?** The docs say recipients install a shared plugin unless an admin installs it for them.
- **Starter prompts:** there is no exact equivalent of conversation starters. The prompts are in `plugin.json`; if they don't show up, post them with the link instead: "Start our Content Spec", "Build our poster from this spec", "Turn our finished poster into slides or an app", "Run a defense drill on our project".

## Fallback if students can't get access

The same files work in a ChatGPT **Project** (or a Claude Project). Students create a project, paste `SKILL.md` (without the top four lines) into the project instructions, and upload the three reference files. This is weaker, since students can edit the instructions, but it doesn't depend on workspace sharing.
