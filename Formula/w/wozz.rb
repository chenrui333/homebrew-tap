class Wozz < Formula
  desc "Catch expensive Kubernetes resource changes before they merge"
  homepage "https://github.com/WozzHQ/wozz"
  url "https://github.com/WozzHQ/wozz/archive/refs/tags/v1.tar.gz"
  sha256 "9d56f1cf994ef0e548b5c486b75a36fac7a3839ee25f37d12ef9e27f74c66723"
  license "MIT"
  head "https://github.com/WozzHQ/wozz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d8c4fa9fb35767a84c6cdb7a48f9715a98e1b449dc2bcf27b288a7694a7f05bb"
  end

  depends_on "kubectl"

  deny_network_access!

  def install
    bin.install "scripts/wozz-audit.sh" => "wozz"
  end

  test do
    assert_match "Kubernetes Audit", (bin/"wozz").read
    # Running the audit would contact a cluster and send telemetry; check local argument handling instead.
    output = shell_output("WOZZ_NO_TELEMETRY=1 #{bin}/wozz --not-a-real-option 2>&1", 1)
    assert_match "Unknown option: --not-a-real-option", output
  end
end
