class Wozz < Formula
  desc "Catch expensive Kubernetes resource changes before they merge"
  homepage "https://github.com/WozzHQ/wozz"
  url "https://github.com/WozzHQ/wozz/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "a3898c7e393b8f1862b7f581541a7ada23f650e22bc34ae157fca18c82de9b5d"
  license "MIT"
  head "https://github.com/WozzHQ/wozz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "b7464da19a8b469df24e0477865c968af3234cc6ec7ba75e2eb6b42420642120"
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
