def main [id: string, out: path, resize?: string] {
  let data = curl --location --max-redirs 20 --retry 3 --retry-all-errors --continue-at - --disable-epsv -C - --fail $"https://wallhaven.cc/api/v1/w/($id)" | from json | get data
  curl --location --max-redirs 20 --retry 3 --retry-all-errors --continue-at - --disable-epsv -C - --fail $data.path --output $out
  if $resize != null {
    magick $out -resize $"($resize)^" -gravity center -extent $resize $out
  }
}
