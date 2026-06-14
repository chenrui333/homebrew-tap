class VetRun < Formula
  desc "Safer way to run remote scripts"
  homepage "https://getvet.sh/"
  url "https://github.com/vet-run/vet/releases/download/v1.0.2/vet"
  sha256 "1b85c98f4f29be13b908ec225f53a70f90c0da5025759810a55961f7c6274878"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "af5bdf6f5be8e1addc61256c783623a41774d2292d281c074aef5df36bcce839"
  end

  depends_on "curl"

  def install
    bin.install "vet"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    output = shell_output("#{bin}/vet --force https://my-trusted-internal-script.sh 2>&1", 1)
    assert_match "Could not resolve host: my-trusted-internal-script.sh", output
  end
end
