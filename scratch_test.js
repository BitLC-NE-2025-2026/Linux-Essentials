const markdownlint = require('markdownlint');
const options = {
  files: ['d:\\DEV\\Linux-Essentials\\Day_13\\README.md'],
  config: { "MD051": true }
};
markdownlint(options, function (err, result) {
  // markdownlint doesn't expose the internal fragments map directly, but we can copy the convertHeadingToHTMLFragment logic
  // and run it on all headings in the file!
  const fs = require('fs');
  const content = fs.readFileSync('d:\\DEV\\Linux-Essentials\\Day_13\\README.md', 'utf8');
  const lines = content.split('\n');
  const headings = lines.filter(l => l.startsWith('## ') || l.startsWith('# '));
  
  function getSlug(text) {
    // strip leading '#'
    let t = text.replace(/^#+\s+/, '');
    return "#" + encodeURIComponent(
      t
        .toLowerCase()
        .replace(
          /[^\p{Letter}\p{Mark}\p{Number}\p{Connector_Punctuation}\- ]/gu,
          ""
        )
        .replace(/ /gu, "-")
    );
  }

  for (const h of headings) {
    console.log(`${h} -> ${getSlug(h)}`);
  }
});
