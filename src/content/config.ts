// src/content/config.ts
import { defineCollection, z } from 'astro:content';

// Define a collection for blog posts
const blogCollection = defineCollection({
  // Type-check frontmatter using a schema
  schema: z.object({
    title: z.string(),
    description: z.string(),
    // Transform string to Date object
    pubDate: z.coerce.date(),
    // Optional fields we might add later
    // updatedDate: z.coerce.date().optional(),
    // heroImage: z.string().optional(),
    // draft: z.boolean().optional(),
  }),
});

// Export a single `collections` object to register the collection(s)
export const collections = {
  blog: blogCollection,
};
