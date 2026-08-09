class Sbomlyze < Formula
  desc "SBOM diff and analysis tool for software supply-chain security"
  homepage "https://rezmoss.github.io/sbomlyze/"
  url "https://github.com/rezmoss/sbomlyze/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "afdebfd3459270b3e7c5ed59bb89e4101ae8715d8e5820818a3d207cde85333f"
  license "Apache-2.0"
  head "https://github.com/rezmoss/sbomlyze.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77d1a3817059fa99b3e3b2dcc5eda1c78f19babbbf37a45a19879105d8993d20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77d1a3817059fa99b3e3b2dcc5eda1c78f19babbbf37a45a19879105d8993d20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77d1a3817059fa99b3e3b2dcc5eda1c78f19babbbf37a45a19879105d8993d20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3d04887913a23ccb12bb9ede9d707222ab542817310e6c0490c360f425aab60"
    sha256 cellar: :any,                 x86_64_linux:  "de687c22fb8c3db8dae3ea9bc5e0cde46c9e9b2c2524f7c592f797bf750a4557"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rezmoss/sbomlyze/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/sbomlyze"
  end

  test do
    (testpath/"empty.json").write("{}")

    assert_match version.to_s, shell_output("#{bin}/sbomlyze --version")
    output = shell_output("#{bin}/sbomlyze #{testpath}/empty.json --no-pager")
    assert_match "SBOM Statistics", output
  end
end
