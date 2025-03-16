class Yajsv < Formula
  desc "Yet Another JSON Schema Validator"
  homepage "https://json-schema.org/"
  url "https://github.com/neilpa/yajsv/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "08118f3614231f3c5f86f4f68816e706e120b8c91cdf6c1caaea45a71e3e5943"
  license "MIT"
  head "https://github.com/neilpa/yajsv.git", branch: "master"

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
