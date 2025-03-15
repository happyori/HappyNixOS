def main [id: string, out: path, resize?: string] {
  let data = http get -k $"https://wallhaven.cc/api/v1/w/($id)" | get data
  # let data = curl --location --max-redirs 20 --retry 3 --retry-all-errors --continue-at - --disable-epsv -C - --fail $"https://wallhaven.cc/api/v1/w/"
  http get -r $data.path | save -f $out
  if $resize != null {
    magick $out -resize $"($resize)^" -gravity center -extent $resize $out
  }
}
