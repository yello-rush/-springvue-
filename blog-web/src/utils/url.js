export function normalizeImageUrl(input) {
  if (!input) return input
  let url = String(input).trim()
  if (!url) return url
  if (typeof window !== 'undefined' && window.location && window.location.protocol === 'https:' && url.startsWith('http://')) {
    url = 'https://' + url.slice('http://'.length)
  }
  try {
    return encodeURI(url)
  } catch (e) {
    return url
  }
}

export function getOptimizedImageUrl(input, options = {}) {
  const url = normalizeImageUrl(input)
  if (!url) return url
  const width = Number(options.width || 720)
  const quality = Number(options.quality || 75)
  if (!/^https?:\/\//i.test(url)) return url
  if (/(x-oss-process|imageMogr2|imageView2)=/i.test(url)) return url

  const joiner = url.includes('?') ? '&' : '?'
  // Aliyun OSS
  if (/aliyuncs\.com|oss-/i.test(url)) {
    return `${url}${joiner}x-oss-process=image/format,webp/resize,w_${width}/quality,q_${quality}`
  }
  // Qiniu
  if (/qiniucdn|clouddn|qiniu/i.test(url)) {
    return `${url}${joiner}imageView2/2/w/${width}/q/${quality}/format/webp`
  }
  // Unsplash and common free image hosts
  if (/unsplash\.com|images\.unsplash\.com|picsum\.photos|pixabay\.com/i.test(url)) {
    const params = [`w=${width}`, `q=${quality}`, 'auto=format', 'fit=crop']
    return `${url}${joiner}${params.join('&')}`
  }
  return url
}
