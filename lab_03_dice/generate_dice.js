const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

// Create PNG buffer from RGBA buffer
function createPNG(width, height, rgbaBuffer) {
  // PNG signature
  const signature = Buffer.from([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);

  // IHDR chunk
  const ihdr = Buffer.alloc(13);
  ihdr.writeUInt32BE(width, 0);
  ihdr.writeUInt32BE(height, 4);
  ihdr.writeUInt8(8, 8); // 8 bits per channel
  ihdr.writeUInt8(6, 9); // RGBA color type
  ihdr.writeUInt8(0, 10); // Compression method
  ihdr.writeUInt8(0, 11); // Filter method
  ihdr.writeUInt8(0, 12); // Interlace method
  const ihdrChunk = makeChunk('IHDR', ihdr);

  // Raw image data with filter byte 0 at start of each scanline
  const scanlineWidth = width * 4;
  const rawData = Buffer.alloc(height * (scanlineWidth + 1));
  for (let y = 0; y < height; y++) {
    rawData[y * (scanlineWidth + 1)] = 0; // Filter None
    rgbaBuffer.copy(
      rawData,
      y * (scanlineWidth + 1) + 1,
      y * scanlineWidth,
      (y + 1) * scanlineWidth
    );
  }

  // Deflate IDAT chunk
  const compressed = zlib.deflateSync(rawData);
  const idatChunk = makeChunk('IDAT', compressed);

  // IEND chunk
  const iendChunk = makeChunk('IEND', Buffer.alloc(0));

  return Buffer.concat([signature, ihdrChunk, idatChunk, iendChunk]);
}

function crc32(buf) {
  let crc = 0xFFFFFFFF;
  for (let i = 0; i < buf.length; i++) {
    crc ^= buf[i];
    for (let j = 0; j < 8; j++) {
      crc = (crc >>> 1) ^ ((crc & 1) ? 0xEDB88320 : 0);
    }
  }
  return (crc ^ 0xFFFFFFFF) >>> 0;
}

function makeChunk(type, data) {
  const typeBuf = Buffer.from(type, 'ascii');
  const lenBuf = Buffer.alloc(4);
  lenBuf.writeUInt32BE(data.length, 0);
  const toCrc = Buffer.concat([typeBuf, data]);
  const crcBuf = Buffer.alloc(4);
  crcBuf.writeUInt32BE(crc32(toCrc), 0);
  return Buffer.concat([lenBuf, typeBuf, data, crcBuf]);
}

// Distance to rounded rectangle SDF
function sdRoundedBox(px, py, bx, by, r) {
  const qx = Math.abs(px) - bx + r;
  const qy = Math.abs(py) - by + r;
  const outerX = Math.max(qx, 0);
  const outerY = Math.max(qy, 0);
  const outerDist = Math.hypot(outerX, outerY);
  const innerDist = Math.min(Math.max(qx, qy), 0);
  return outerDist + innerDist - r;
}

// Distance to circle SDF
function sdCircle(px, py, cx, cy, r) {
  return Math.hypot(px - cx, py - cy) - r;
}

// Gradient color interpolator
function getGradientColor(yNorm) {
  // Top: vibrant reddish-orange [235, 75, 25], Bottom: golden orange/yellow [255, 175, 0]
  const r = 235 + (255 - 235) * yNorm;
  const g = 75 + (175 - 75) * yNorm;
  const b = 25 + (0 - 25) * yNorm;
  return [Math.round(r), Math.round(g), Math.round(b)];
}

const dotPositions = {
  1: [[0, 0]],
  2: [[-0.48, -0.48], [0.48, 0.48]],
  3: [[-0.48, -0.48], [0, 0], [0.48, 0.48]],
  4: [[-0.48, -0.48], [0.48, -0.48], [-0.48, 0.48], [0.48, 0.48]],
  5: [[-0.48, -0.48], [0.48, -0.48], [0, 0], [-0.48, 0.48], [0.48, 0.48]],
  6: [
    [-0.48, -0.55], [-0.48, 0], [-0.48, 0.55],
    [0.48, -0.55], [0.48, 0], [0.48, 0.55]
  ]
};

function renderDie(number, size = 512) {
  const buffer = Buffer.alloc(size * size * 4);
  const half = size / 2;
  const boxHalf = size * 0.42;
  const cornerRadius = size * 0.15;
  const borderWidth = size * 0.055;
  const dotRadius = size * 0.062;
  const dots = dotPositions[number];

  for (let y = 0; y < size; y++) {
    const py = y - half;
    const yNorm = y / size;
    const gradColor = getGradientColor(yNorm);

    for (let x = 0; x < size; x++) {
      const px = x - half;
      const idx = (y * size + x) * 4;

      // Distance to outer rounded box
      const dOuter = sdRoundedBox(px, py, boxHalf, boxHalf, cornerRadius);
      // Distance to inner rounded box
      const dInner = sdRoundedBox(px, py, boxHalf - borderWidth, boxHalf - borderWidth, Math.max(0, cornerRadius - borderWidth));

      // Border mask: smooth transition from outer to inner
      const alphaOuter = Math.max(0, Math.min(1, 0.5 - dOuter));
      const alphaInner = Math.max(0, Math.min(1, 0.5 - dInner));
      const borderAlpha = Math.max(0, alphaOuter - alphaInner);

      // Dot mask
      let minDotDist = 999999;
      for (const [dx, dy] of dots) {
        const cx = dx * (boxHalf - borderWidth - dotRadius * 0.5);
        const cy = dy * (boxHalf - borderWidth - dotRadius * 0.5);
        const d = sdCircle(px, py, cx, cy, dotRadius);
        if (d < minDotDist) minDotDist = d;
      }
      const dotAlpha = Math.max(0, Math.min(1, 0.5 - minDotDist));

      // Combine border and dot
      const combinedAlpha = Math.min(1, borderAlpha + dotAlpha);

      if (combinedAlpha > 0) {
        buffer[idx] = gradColor[0];
        buffer[idx + 1] = gradColor[1];
        buffer[idx + 2] = gradColor[2];
        buffer[idx + 3] = Math.round(combinedAlpha * 255);
      } else {
        buffer[idx] = 0;
        buffer[idx + 1] = 0;
        buffer[idx + 2] = 0;
        buffer[idx + 3] = 0;
      }
    }
  }

  return createPNG(size, size, buffer);
}

const assetsDir = path.join(__dirname, 'assets');
if (!fs.existsSync(assetsDir)) {
  fs.mkdirSync(assetsDir, { recursive: true });
}

for (let i = 1; i <= 6; i++) {
  const pngData = renderDie(i);
  fs.writeFileSync(path.join(assetsDir, `dice${i}.png`), pngData);
  console.log(`Generated assets/dice${i}.png`);
}
