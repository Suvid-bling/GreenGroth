export interface PlantInfo {
  Name: string
  LatinName: string
  Score: string
  AliasName: string
  AliasList: string[]
  aliasList: string[]
  Family: string
  Genus: string
  ImageUrl: string
  hyyy: string
  InfoCode: string
}

export interface ApiResponse {
  Status: number
  Message: string
  Result: PlantInfo[]
}