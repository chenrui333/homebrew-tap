class Envdiff < Formula
  desc "Tool to snapshot and diff environments"
  homepage "https://github.com/GBerghoff/envdiff"
  url "https://github.com/GBerghoff/envdiff/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "94c6a431511d679211489d59f6c9ca53b26a090fd599fec11c0766373ce5d55c"
  license "MIT"
  head "https://github.com/GBerghoff/envdiff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e838d0753976911ccef09be3137a33c6a01a849dfb64d5caac192c3ee7ada90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e838d0753976911ccef09be3137a33c6a01a849dfb64d5caac192c3ee7ada90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7b1fac1faf48074f321bf8dc1397f1c8d060627a19f5c46c7eeac61faede24d"
    sha256 cellar: :any,                 x86_64_linux:  "94e9bf8119fe31b251fa054ede43ed1f0125c16b8378b7437edd5ac60d53f935"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/envdiff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envdiff --version")

    system bin/"envdiff", "init"
    assert_path_exists testpath/"envdiff.yaml"

    system bin/"envdiff", "snapshot", "-o", "snapshot.json"
    assert_path_exists testpath/"snapshot.json"

    output = shell_output("#{bin}/envdiff render snapshot.json")
    assert_match "SYSTEM", output
    assert_match "RUNTIME", output
  end
end
