class Sloop < Formula
  desc "Kubernetes History Visualization"
  homepage "https://github.com/salesforce/sloop"
  url "https://github.com/salesforce/sloop/archive/refs/tags/v1.2.tar.gz"
  sha256 "ff5b6e91ab56ab534dfa967fa560fd9c2c4a95e63c38c19d1574c4c37645dbd5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a47ac3282c25f0fa68733b6370ab45a0cbcbd91e10fb782d3593e8eacde79b49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d607d931e6882a6e306e225c96b680a3981ccd3f1602bb1e91de7bba1c3c478"
    sha256 cellar: :any_skip_relocation, ventura:       "9780c8d1695275245841dc2a13062f8dff8957b0304746213b4a9d4fe7e249e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61e0d7553a2d6d9b29fb8500d9454c011019ae0e30dca9aa7f46ae7e2675769d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-installsuffix", "cgo", "./pkg/sloop"
  end

  test do
    assert_match "Getting k8s context with user-defined config", shell_output("#{bin}/sloop 2>&1", 2)
    assert_path_exists testpath/"data/KEYREGISTRY"
    assert_path_exists testpath/"data/MANIFEST"
  end
end
