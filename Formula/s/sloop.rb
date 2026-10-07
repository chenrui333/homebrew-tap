class Sloop < Formula
  desc "Kubernetes History Visualization"
  homepage "https://github.com/salesforce/sloop"
  url "https://github.com/salesforce/sloop/archive/refs/tags/v1.2.tar.gz"
  sha256 "ff5b6e91ab56ab534dfa967fa560fd9c2c4a95e63c38c19d1574c4c37645dbd5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0ebf9824cd027e4872fae49af326fc91aa99b7a40b64b084515f206e32796d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7259afb2ea1b5187f70e630ea738f074dc6ff802da108a82269f5b2f6f5bc3f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a49dd05ac2e8e73140a200292f2b88d56773b1cbad2dc96c8fa7d3e75b0beecf"
    sha256 cellar: :any,                 x86_64_linux:  "10cd9744734695db16108be99035ecfb087f3ed578b1903246077a8ea4340a71"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # Pre-1.17 go.mod omits indirect deps the build needs; fetch the full module graph.
    system "go", "mod", "download", "all"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-installsuffix", "cgo", "./pkg/sloop"
  end

  test do
    assert_match "Getting k8s context with user-defined config", shell_output("#{bin}/sloop 2>&1", 2)
    assert_path_exists testpath/"data/KEYREGISTRY"
    assert_path_exists testpath/"data/MANIFEST"
  end
end
