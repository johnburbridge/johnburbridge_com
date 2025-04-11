import { defineConfig } from 'astro/config';
import rehypeMermaid from 'rehype-mermaid';

// https://astro.build/config
export default defineConfig({
  markdown: {
    syntaxHighlight: false, // Disable default syntax highlighting
    rehypePlugins: [
      [rehypeMermaid, { strategy: 'pre-mermaid' }], // Use 'pre-mermaid' strategy
    ],
    // Optionally, if you use remark-gfm for GitHub Flavored Markdown features:
    // remarkPlugins: [remarkGfm],
  },
});
