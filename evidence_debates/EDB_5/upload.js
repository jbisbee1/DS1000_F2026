// Photo upload for EDB 5, shared by index.html (laptop) and photo.html (phone).
// Files go to the private Supabase Storage bucket "edb5-photos" under pair-<N>/.
// Students can upload but cannot list or view anything in the bucket (insert-only policy; see README).
window.EDB5Photo = (function () {
  const BUCKET = "edb5-photos";

  // Shrink large phone photos to about 2400px on the long side as JPEG. If the browser can't
  // decode the file (for example HEIC on some desktops), upload the original instead.
  async function shrink(file, max = 2400) {
    try {
      const bmp = await createImageBitmap(file);
      const s = Math.min(1, max / Math.max(bmp.width, bmp.height));
      const c = document.createElement("canvas");
      c.width = Math.round(bmp.width * s); c.height = Math.round(bmp.height * s);
      c.getContext("2d").drawImage(bmp, 0, 0, c.width, c.height);
      const blob = await new Promise(r => c.toBlob(r, "image/jpeg", 0.85));
      if (blob) return { blob, ext: "jpg", type: "image/jpeg" };
    } catch (e) {}
    const ext = ((file.name || "").split(".").pop() || "jpg").toLowerCase();
    return { blob: file, ext, type: file.type || "image/jpeg" };
  }

  async function upload(client, { pair, code, side, file, dry }) {
    if (!file) return { error: { message: "Choose a photo first." } };
    if (file.type && !file.type.startsWith("image/")) return { error: { message: "That file isn't a photo." } };
    const { blob, ext, type } = await shrink(file);
    if (blob.size > 10 * 1024 * 1024) return { error: { message: "That photo is too large (over 10 MB)." } };
    const stamp = new Date().toISOString().replace(/[:.]/g, "-");
    const path = `pair-${pair}/${side}_${code}_${stamp}.${ext}`;
    if (dry) { console.log("[dry run] would upload", path, Math.round(blob.size / 1024) + " KB"); return { path }; }
    if (!client) return { error: { message: "Not connected. Check the connection and try again." } };
    const { error } = await client.storage.from(BUCKET).upload(path, blob, { contentType: type, upsert: false });
    return error ? { error } : { path };
  }

  return { upload };
})();
