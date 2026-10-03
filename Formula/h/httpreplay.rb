class Httpreplay < Formula
  desc "Replay HTTP requests from a tape file"
  homepage "https://github.com/roy2220/httpreplay"
  url "https://github.com/roy2220/httpreplay/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "7fa02e5384b72fc285fa4ab35c47e003f0149397b3d9ec2951b1ccc24f3e7541"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0728bfaf07813c92e8802617e92cd32f3e580636a0d124e601e5fbb376e372e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0728bfaf07813c92e8802617e92cd32f3e580636a0d124e601e5fbb376e372e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "890aa962b32f84c27f1ad9e21624c4a9d1683e58319a810d987aa05b096f13ed"
    sha256 cellar: :any,                 x86_64_linux:  "7f6168f823bfe6e95d43d1593f383a438ed43802e23be852d68837ac4c710239"
  end
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
