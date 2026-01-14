/**
 * 获取带 base URL 的资源路径
 * 用于处理 GitHub Pages 子路径部署
 */
export function getAssetUrl(path: string): string {
  const base = import.meta.env.BASE_URL
  // 确保 path 以 / 开头
  const normalizedPath = path.startsWith('/') ? path : `/${path}`
  // 移除 base 末尾的 / 避免双斜杠
  const normalizedBase = base.endsWith('/') ? base.slice(0, -1) : base
  return `${normalizedBase}${normalizedPath}`
}
