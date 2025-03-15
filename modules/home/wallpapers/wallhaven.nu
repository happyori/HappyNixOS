def main [id: string, out: path, resize?: string] {
  let data = http get -k $"https://wallhaven.cc/api/v1/w/($id)" | get data
  http get -r $data.path | save -f $out
  if $resize != null {
    magick $out -resize $"($resize)^" -gravity center -extent $resize $out
  }
}
