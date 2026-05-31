class Wozz < Formula
  desc "Catch expensive Kubernetes resource changes before they merge"
  homepage "https://github.com/WozzHQ/wozz"
  url "https://github.com/WozzHQ/wozz/archive/refs/tags/v1.tar.gz"
  sha256 "9d56f1cf994ef0e548b5c486b75a36fac7a3839ee25f37d12ef9e27f74c66723"
  license "MIT"
  head "https://github.com/WozzHQ/wozz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "1383c1f04a233008734dfc79edc9e5ce7fd9f7ab405b65adcace72334e890f8d"
  end

  depends_on "kubectl"

  def install
    bin.install "scripts/wozz-audit.sh" => "wozz"
  end

  test do
    assert_match "Kubernetes Audit", (bin/"wozz").read
    output = shell_output("#{bin}/wozz 2>&1", 1)
    assert_match(/kubectl|kube|namespace|cluster/i, output)
  end
end
