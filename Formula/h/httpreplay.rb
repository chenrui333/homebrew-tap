class Httpreplay < Formula
  desc "Replay HTTP requests from a tape file"
  homepage "https://github.com/roy2220/httpreplay"
  url "https://github.com/roy2220/httpreplay/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "6630a42cd3d30465970bedb5b4501ea7f60b30df36791eb72d84f1dedafe3b71"
  license "MIT"
  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"httpreplay")
  end

  test do
    (testpath/"requests.txt").write <<~EOS
      https://example.com/api/status
      https://example.com/api/post -X POST -H "Content-Type: application/json" -d '{"key":"value"}'
    EOS

    output = shell_output("#{bin}/httpreplay requests.txt -d -q 1 -c 1 2>&1")
    assert_match "<dry-run> http request: method=\"GET\" url=\"https://example.com/api/status\"", output
    assert_match "final progress: tapePosition=2", output
    assert_path_exists testpath/"requests.txt.httpreplay-pos.dry-run"
  end
end
