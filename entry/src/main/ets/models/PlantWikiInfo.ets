export interface PlantDetailInfo {
  xgsc: string         // 相关诗词
  jzgy: string         // 价值功用
  hyyy: string         // 花语寓意
  fbdq: string         // 分布地区
  mcll: string         // 名称来历
  yhjs: string         // 养护技术
  bxtz: string         // 表型特征
  hksj: string         // 花开时节
}

export interface PlantWikiInfo {
  nameStd: string
  nameLt: string
  familyCn: string
  genusCn: string
  alias: string
  description: string
  info: PlantDetailInfo
  images: string[]
}

export interface WikiApiResponse {
  status: number
  message: string
  result: PlantWikiInfo
}