---
title: 'A Test Blog Post'
description: 'This is a sample blog post to test the Astro content collections setup.'
pubDate: 2025-04-10 # Use YYYY-MM-DD format
---

## Welcome to the Blog!

This is the body of my **first blog post**. I'm using Astro's [Content Collections](https://docs.astro.build/en/guides/content-collections/) feature.

Here's a list:

- Item 1
- Item 2

Testing a Mermaid JS graph:

```mermaid
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```

Testing syntax highlighting:

1. Python

    ```python
    # This is a sample Python code block
    import os

    def greet(name):
    """Greets the given name."""
    message = f"Hello, {name}!"
    print(message)
    return message

    # Example usage
    if __name__ == "__main__":
    user_name = os.getenv("USER", "World")
    greet(user_name)
    ```

2. Yaml

    ```yaml
    ---
    # A sample yaml file
    company: spacelift
    domain:
    - devops
    - devsecops
    tutorial:
    - yaml:
        name: "YAML Ain't Markup Language"
        type: awesome
        born: 2001
    - json:
        name: JavaScript Object Notation
        type: great
        born: 2001
    - xml:
        name: Extensible Markup Language
        type: good
        born: 1996
    author: omkarbirade
    published: true
    ```

3. json

    ```json
    {"menu": {
        "header": "SVG Viewer",
        "items": [
            {"id": "Open"},
            {"id": "OpenNew", "label": "Open New"},
            null,
            {"id": "ZoomIn", "label": "Zoom In"},
            {"id": "ZoomOut", "label": "Zoom Out"},
            {"id": "OriginalView", "label": "Original View"},
            null,
            {"id": "Quality"},
            {"id": "Pause"},
            {"id": "Mute"},
            null,
            {"id": "Find", "label": "Find..."},
            {"id": "FindAgain", "label": "Find Again"},
            {"id": "Copy"},
            {"id": "CopyAgain", "label": "Copy Again"},
            {"id": "CopySVG", "label": "Copy SVG"},
            {"id": "ViewSVG", "label": "View SVG"},
            {"id": "ViewSource", "label": "View Source"},
            {"id": "SaveAs", "label": "Save As"},
            null,
            {"id": "Help"},
            {"id": "About", "label": "About Adobe CVG Viewer..."}
        ]
    }}
    ```

4. Kotlin

    ```kotlin
    class Customer                                  // 1

    class Contact(val id: Int, var email: String)   // 2

    fun main() {

        val customer = Customer()                   // 3
        
        val contact = Contact(1, "mary@gmail.com")  // 4

        println(contact.id)                         // 5
        contact.email = "jane@gmail.com"            // 6
    }
    ```


And here's a link:
[Visit Astro Docs](https://docs.astro.build/)

We can add more content here later.