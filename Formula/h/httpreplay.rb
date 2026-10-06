class Httpreplay < Formula
  desc "Replay HTTP requests from a tape file"
  homepage "https://github.com/roy2220/httpreplay"
  url "https://github.com/roy2220/httpreplay/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "e28d6eaa2f56f07f3ca60c41cf783316fd0c9f1bf9778cc99c8230170c01d999"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4db74c6520e0d6b318bbcd4919411c48bc45ce465a52106d3c6d75a0ee6c3d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4db74c6520e0d6b318bbcd4919411c48bc45ce465a52106d3c6d75a0ee6c3d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4063d0c87149810056cc4879eff03a4d84a3e6f6dbe6f431d6d2ce22a96bf8d1"
    sha256 cellar: :any,                 x86_64_linux:  "d025e02c236aa05bcfb8106cfac1ff780a34399a4b69fc2c5f249a6e45ad8243"
  end
  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
