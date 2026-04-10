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
