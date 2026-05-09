# Markdown Viewer — Commenting

The viewer at `markdown-viewer.html` supports right-click + selection-based threaded commenting on any markdown file. Comments are stored **inside the markdown file itself** as HTML comments, so the file remains a single self-contained unit that any other markdown renderer (GitHub, Obsidian, VS Code preview, Mintlify) renders without the comment UI but without rendering the comment payload either.

## How to use

1. Open `markdown-viewer.html` in **Chrome, Edge, Brave, Arc, or Opera** (Chromium-based — needed for in-place file save).
2. Click the **📄 Open** button (top-right toolbar) and pick a `.md` file. Browser will ask for read-write permission — pick **"Allow on every visit"** for friction-free reuse.
3. Read the document.
4. **Right-click any paragraph → "💬 Add comment"**, OR select text and click the floating "💬 Comment" popover.
5. Type, hit Cmd+Enter (or click Save). The comment appears as a chip on the paragraph + a card in the right sidebar.
6. Replies, resolve, delete are all in the sidebar. Auto-save fires 1.5 s after each change.

**Keyboard:** `Cmd/Ctrl+Shift+C` toggles the sidebar. `Cmd/Ctrl+S` forces save. `Esc` closes popups. `Shift+Right-click` keeps the native browser menu.

**Non-Chromium browsers** (Firefox, Safari): drag-drop a file in or use `?file=URL`. In-place save is unavailable; instead, the viewer offers a "Download with comments" button to replace the file manually.

## Storage format

Comments live in two HTML-comment forms inside the markdown source:

- **Inline anchor markers** — `<!-- KFU-ANCHOR id="c_xyz" -->` placed on its own line immediately before the anchored block. Stays attached to its block when the surrounding text is edited.
- **Trailing payload** — a single `<!-- KFU-COMMENTS:v1 ... KFU-COMMENTS:end -->` block at the end of the file containing all comment data as JSON (one comment per object, `parent_id` for threading).

Both forms are invisible to every CommonMark-compliant renderer. The `KFU-` prefix is the reserved namespace; do not use it for unrelated HTML comments.

## Threading

Comments form trees via `parent_id` (null for thread roots, otherwise the id of the parent comment). The viewer renders each thread chronologically (oldest first; Slack convention). One thread per anchor; replies share the thread's anchor.

## Anchor stability

Three-level fallback when the markdown is edited (per Hypothesis's algorithm):

1. **Exact** — anchor marker by id (survives any edit that doesn't touch the marker).
2. **Structural** — same block kind at the same sibling index in the parent.
3. **Fuzzy** — Bitap match of the original quoted text + 32-char prefix/suffix using vendored `diff-match-patch`.

Comments whose anchor cannot be resolved at any level surface in the sidebar with a yellow ⚠ orphan badge — they are never silently dropped.

## Conflict & external edits

The viewer tracks the file's `lastModified` timestamp at open time. If you edit the file in another tool while the viewer is open, the next save attempt blocks with a toast offering: *Reload from disk* / *Overwrite anyway* / *Cancel*. Never silently overwrite.

## Privacy

Everything is local. No network calls. The file never leaves your disk. Author identity is whatever `localStorage` holds under `kfu-author-name` (defaults to `"You"`); change with `localStorage.setItem('kfu-author-name', 'Vik')` in DevTools.
