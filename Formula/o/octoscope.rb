class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "ae997cbf509d1e0d3325caf856717b2b52eeb1755ab607d41f809b15ed976c70"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54b9b8dada8d7d1eb02f5a8b08906008df24cf222c92034ab126bfd27ab8e6cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54b9b8dada8d7d1eb02f5a8b08906008df24cf222c92034ab126bfd27ab8e6cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54b9b8dada8d7d1eb02f5a8b08906008df24cf222c92034ab126bfd27ab8e6cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0716af0d686a7022c42323561a23954689368305142cc037edbdc5e4f3fa5312"
    sha256 cellar: :any,                 x86_64_linux:  "92ea8be30a359f11f95c74a768653eb7f54a0734d470acf645bdfd572940c388"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")

    output = shell_output("#{bin}/octoscope --theme invalid 2>&1", 2)
    assert_match 'unknown theme "invalid"', output
  end
end
