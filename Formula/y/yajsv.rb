class Yajsv < Formula
  desc "Yet Another JSON Schema Validator"
  homepage "https://json-schema.org/"
  url "https://github.com/neilpa/yajsv/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "08118f3614231f3c5f86f4f68816e706e120b8c91cdf6c1caaea45a71e3e5943"
  license "MIT"
  head "https://github.com/neilpa/yajsv.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c5b35d39aadd3955d5f54eae35742847157131722c7ac6c5ac620a44a3bc465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa006249351af05a9c51b44108c5ff4469ae5cd90b9aa9189bca123d08d78d02"
    sha256 cellar: :any_skip_relocation, ventura:       "aa1487aabc9a56a3c3db74d26aa62b6927a5d09ef5438fea6f3b8741a1c2f995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b506da088d05fa14ea1b0a4280a37770fccb2f637783972f07c1a7e6ddc211dd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"schema.json").write <<~JSON
      {
          "properties": {
              "foo": { "type": "string" },
              "bar": {}
          },
          "required": ["foo"]
      }
    JSON

    (testpath/"data-pass.json").write <<~JSON
      {
          "foo": "asdf",
          "bar": "zxcv"
      }
    JSON

    output = shell_output("#{bin}/yajsv -s schema.json data-pass.json")
    assert_equal "data-pass.json: pass", output.strip

    (testpath/"data-fail.json").write <<~JSON
      {
          "bar": "missing foo"
      }
    JSON

    output = shell_output("#{bin}/yajsv -s schema.json data-fail.json", 1)
    assert_match "data-fail.json: fail: (root): foo is required", output.strip
  end
end
