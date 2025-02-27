const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const morgan = require('morgan');
const { exec } = require('child_process');
const { v4: uuidv4 } = require('uuid');
const fs = require('fs');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;
const downloadsDir = process.env.DOWNLOADS_DIR || '/downloads';

// 确保下载目录存在
if (!fs.existsSync(downloadsDir)) {
  fs.mkdirSync(downloadsDir, { recursive: true });
}

// 中间件
app.use(cors());
app.use(bodyParser.json());
app.use(morgan('dev'));
app.use('/downloads', express.static(downloadsDir));

// 提供静态文件
app.use(express.static(path.join(__dirname, 'public')));

// 健康检查端点
app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'yt-dlp API is running' });
});

// 获取视频信息
app.get('/api/info', (req, res) => {
  const url = req.query.url;
  
  if (!url) {
    return res.status(400).json({ error: 'URL is required' });
  }
  
  const command = `yt-dlp --dump-json "${url}"`;
  
  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error: ${error.message}`);
      return res.status(500).json({ error: error.message, stderr });
    }
    
    try {
      const info = JSON.parse(stdout);
      res.json(info);
    } catch (e) {
      res.status(500).json({ error: 'Failed to parse video info', stdout, stderr });
    }
  });
});

// 下载视频
app.post('/api/download', (req, res) => {
  const { url, format, audioOnly, quality, subtitles } = req.body;
  
  if (!url) {
    return res.status(400).json({ error: 'URL is required' });
  }
  
  const jobId = uuidv4();
  const outputTemplate = path.join(downloadsDir, `${jobId}-%(title)s-%(id)s.%(ext)s`);
  
  let command = `yt-dlp -o "${outputTemplate}" `;
  
  // 处理格式选项
  if (format) {
    command += `-f ${format} `;
  } else if (audioOnly) {
    command += `-x --audio-format mp3 --audio-quality ${quality || 0} `;
  }
  
  // 处理字幕选项
  if (subtitles) {
    command += '--write-subs --write-auto-subs ';
  }
  
  // 添加URL
  command += `"${url}"`;
  
  console.log(`Executing: ${command}`);
  
  const startTime = Date.now();
  exec(command, (error, stdout, stderr) => {
    const endTime = Date.now();
    const duration = (endTime - startTime) / 1000;
    
    if (error) {
      console.error(`Error: ${error.message}`);
      return res.status(500).json({ error: error.message, stderr, stdout });
    }
    
    // 查找下载的文件
    fs.readdir(downloadsDir, (err, files) => {
      if (err) {
        return res.status(500).json({ error: 'Failed to read downloads directory' });
      }
      
      const downloadedFiles = files.filter(file => file.startsWith(jobId));
      
      if (downloadedFiles.length === 0) {
        return res.status(500).json({ error: 'No files were downloaded', stdout, stderr });
      }
      
      // 构建下载URL
      const downloadUrls = downloadedFiles.map(file => {
        return {
          filename: file,
          url: `/downloads/${file}`,
          path: path.join(downloadsDir, file)
        };
      });
      
      res.json({
        jobId,
        status: 'completed',
        duration,
        files: downloadedFiles,
        downloadUrls,
        stdout,
        stderr
      });
    });
  });
});

// 获取支持的格式
app.get('/api/formats', (req, res) => {
  const url = req.query.url;
  
  if (!url) {
    return res.status(400).json({ error: 'URL is required' });
  }
  
  const command = `yt-dlp -F "${url}"`;
  
  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error: ${error.message}`);
      return res.status(500).json({ error: error.message, stderr });
    }
    
    // 解析格式列表
    const lines = stdout.trim().split('\n');
    const formatLines = lines.filter(line => /^\d+/.test(line.trim()));
    
    const formats = formatLines.map(line => {
      const parts = line.trim().split(/\s+/);
      const id = parts[0];
      const ext = parts[1] || '';
      const resolution = parts.find(p => /^\d+x\d+$/.test(p)) || '';
      const note = line.includes('(') ? line.match(/\(([^)]+)\)/)[1] : '';
      
      return { id, ext, resolution, note, line };
    });
    
    res.json({ formats, raw: stdout });
  });
});

// 默认路由
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// 启动服务器
app.listen(port, () => {
  console.log(`yt-dlp API server running on port ${port}`);
}); 