class Konfigo < Formula
  desc "Merge and transform configuration files across multiple formats"
  homepage "https://github.com/ebogdum/konfigo"
  url "https://github.com/ebogdum/konfigo/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "d571f54dc7e79946b45ac8784373b0783e011e3c8a50e8b4d6d29be196dbe36c"
  license "MIT"
  head "https://github.com/ebogdum/konfigo.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"konfigo"), "./cmd/konfigo"
  end

  test do
    (testpath/"config1.json").write <<~JSON
      {"a":1,"b":2}
    JSON
    (testpath/"config2.json").write <<~JSON
      {"b":3,"c":4}
    JSON

    output = shell_output("#{bin}/konfigo -s config1.json,config2.json -oj")
    assert_match '"a": 1', output
    assert_match '"b": 3', output
    assert_match '"c": 4', output

    help = shell_output("#{bin}/konfigo -h 2>&1")
    assert_match "Path to a schema file", help
  end
end
