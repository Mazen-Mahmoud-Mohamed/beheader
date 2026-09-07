# beheader

> **Polyglot generator for media files.**

beheader is a polyglot generator for media files that combines multiple file formats into a single output file. Depending on the file extension and the application opening it, the resulting file can behave as an image, video, HTML document, PDF, or ZIP archive.

## ✨ Features

- 🖼️ Image + video/audio polyglot generation
- 🎬 Video re-encoding to normalized MP4
- 🎵 Audio encoding to AAC in an MP4 container
- 🌐 Optional HTML embedding
- 📄 Optional PDF embedding
- 📦 Multiple ZIP-like archive merging
- 📎 Appendable binary files
- ➕ Short custom header data with `--extra`
- 🧰 Nix-based development environment
- 🧹 Automatic cleanup of temporary files

## 📋 Supported Formats

| Output extension | Behavior |
|---|---|
| `.ico` | Displays the input image |
| `.png` | Displays the input image |
| `.mp4` | Plays the input video |
| `.html` | Shows the input webpage |
| `.pdf` | Opens the input PDF (if applicable) |
| `.zip` | Extracts the input archive (if applicable) |

## 🛠️ Requirements

The project requires:

- Bun
- Linux
- FFmpeg
- FFprobe
- ImageMagick
- `zip`
- `unzip`
- `mp4edit`

The exact dependency requirements and Nix setup are documented below.

## 📦 Installation

Clone the repository:

```bash
git clone <YOUR-REPOSITORY-URL>
cd beheader
```

If Nix is installed, enter the development environment:

```bash
nix develop
```

Make sure the required tools are available in your `PATH` and that an executable `mp4edit` binary is present in the working directory.

## 🚀 Quick Start

Basic usage:

```bash
bun run beheader.js <output> <image> <video|audio>
```

Example:

```bash
bun run beheader.js output.mp4 image.png video.mp4
```

## 🧪 Examples

### HTML

```bash
bun run beheader.js output.html image.png video.mp4 --html page.html
```

### PDF

```bash
bun run beheader.js output.pdf image.png video.mp4 --pdf document.pdf
```

### Multiple ZIP archives

```bash
bun run beheader.js output.zip image.png video.mp4 \
  --zip first.zip \
  --zip second.zip
```

### Appendable files

```bash
bun run beheader.js output.mp4 image.png video.mp4 extra.bin
```

### Extra header data

```bash
bun run beheader.js output.mp4 image.png video.mp4 --extra extra.txt
```

## 🔬 Technical Overview

The generator processes the inputs through several stages:

1. The input image is converted to a normalized 32-bit PNG.
2. The video/audio input is inspected with `ffprobe`.
3. Video is re-encoded to MP4 using H.264, while audio is encoded using AAC.
4. MP4 atoms are modified with `mp4edit`.
5. Image and optional HTML data are inserted into a `skip` atom.
6. The PNG offset is calculated and written into the ICO-compatible header.
7. Optional PDF data is embedded and its offsets are adjusted.
8. Appendable files are added.
9. ZIP-like archives are extracted, merged, repacked, and appended.
10. Temporary files are cleaned up.

## ⚠️ Compatibility

Polyglot files depend on how individual programs parse file structures. Different applications may therefore interpret the same output differently, and some less tolerant programs may reject the resulting file.

The original technical notes below document additional compatibility and lossless-processing limitations.

## 📁 Project Structure

```text
beheader/
├── beheader.js
├── flake.nix
├── flake.lock
├── README.md
├── LICENSE
└── .gitignore
```

## 🤝 Contributing

Contributions, bug reports, compatibility testing, and improvements are welcome.

When contributing, please keep changes focused and document meaningful changes to command-line behavior or file-format handling.

## 📜 License

See the `LICENSE` file included with the project for licensing information.

---

# Original Documentation

Polyglot generator for media files.

### Dependencies

This project requires the [Bun JavaScript runtime](https://bun.sh/), and is built for Linux systems. You'll need `ffmpeg`, `ffprobe`, ImageMagick's `convert`, `zip`, and `unzip` in your `PATH`, as well as an executable [mp4edit](https://www.bento4.com/) binary in your working directory.

If you have Nix installed on your system, be it just `nix` on your favorite distribution, or you're running NixOS, you can (after cloning) use the `flake.nix` to automatically get all of the above dependencies.

### Usage

With all dependencies set up, you should be able to run:

```text
$ bun run beheader.js <output> <image> <video|audio> [-options] [appendable...]
```

**Positional arguments:**

- `output` - Path of resulting polyglot file.
- `image` - Path of input image file.
- `video|audio` - Path of input video (or audio) file.
- `appendable` - Path(s) of files to append without parsing.

**Optional flags:**

- `-h` (or `--html`) `<path>` - Path to HTML document.
- `-p` (or `--pdf`) `<path>` - Path to PDF document.
- `-z` (or `--zip`) `<path>` - Path to ZIP-like archive. Can be repeated to merge multiple ZIPs.
- `-e` (or `--extra`) `<path>` - Path to short (<200 byte) file to include near the header.
- `--help` - Print usage guide and exit.

**Technical notes:**

1. The merging process is not necessarily lossless. Video (or audio) gets re-encoded to MP4, images get converted to PNG (in an ICO container), HTML is coupled with a stylesheet, PDF offsets are adjusted, and ZIP archives get re-packed.
2. There are many other file formats that use the ZIP structure under the hood. Popular examples include JAR, APK, PPTX, DOCX, XLSX, and a few others. Note that "appendables" are inserted *before* any ZIPs.
3. The `--extra` data gets inserted starting at byte 22. Input size is not regulated - exceeding ~200 bytes (or less!) may break other components.

The output file will be a polyglot of all of its inputs. On most systems, it will change behavior depending on its file extension:
- `.ico` (or `.png`) displays the input image;
- `.mp4` plays the input video;
- `.html` shows the input webpage;
- `.pdf` opens the input PDF (if applicable);
- `.zip` extracts the input archive (if applicable).

Because of the several unholy beheadings that this script performs, some less tolerant (or less compliant) programs may fail early with errors about bad metadata or file type.
