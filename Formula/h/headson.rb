class Headson < Formula
  desc "Structure-aware head/tail-style previews for JSON and YAML"
  homepage "https://github.com/kantord/headson"
  url "https://github.com/kantord/headson/archive/refs/tags/headson-v0.16.1.tar.gz"
  sha256 "485c221b28b361c9de2b8223f7985401d37f2c75a2870be6f59af4d83f499db7"
  license "MIT"
  head "https://github.com/kantord/headson.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    (testpath/"sample.json").write <<~JSON
      {"name":"demo","items":[1,2,3],"meta":{"enabled":true}}
    JSON

    assert_match version.to_s, shell_output("#{bin}/hson --version")
    output = shell_output("#{bin}/hson -c 120 sample.json")
    assert_match "name", output
  end
end
