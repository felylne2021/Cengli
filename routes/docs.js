import MarkdownIt from "markdown-it";
import path from "path";
import fs from "fs";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const docs = async (server) => {
  // Docs
  const md = new MarkdownIt({
    html: true,
    linkify: true,
    typographer: true
  });

  server.get('', async (request, reply) => {
    const markdownPath = path.join(__dirname, '../docs.md');
    const markdownContent = fs.readFileSync(markdownPath, 'utf-8');
    const htmlContent = md.render(markdownContent);

    const styledHtml = `
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        body {
          font-family: 'Arial', sans-serif;
          line-height: 1.6;
          margin: 20px;
          padding: 0;
          background-color: #f9f9f9;
        }
        code {
          background-color: #f4f4f4;
          padding: 2px 5px;
          border-radius: 3px;
        }
      </style>
    </head>
    <body>
      ${htmlContent}
    </body>
    </html>
  `;

    reply.type('text/html').send(styledHtml);
  });
}


