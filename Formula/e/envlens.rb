class Envlens < Formula
  desc "Inspect, search, and copy environment variables from the terminal"
  homepage "https://github.com/craigf-svg/envlens"
  url "https://github.com/craigf-svg/envlens/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "47e655fcd0736efc661652f5460e645759f8450907e2aa3978cc1145db9fc089"
  license "MIT"
  head "https://github.com/craigf-svg/envlens.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14fe3c5e56db4d4989d6e72e45f33734eb64354842c2e2344242349b2ba0456d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14fe3c5e56db4d4989d6e72e45f33734eb64354842c2e2344242349b2ba0456d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14fe3c5e56db4d4989d6e72e45f33734eb64354842c2e2344242349b2ba0456d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff8369f66304f5adb097437b284f96aeaa5f2dc77ab3c50bbfe020f9b5c27663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d44533b22b8781f2976157352e6d865b066faeb3496ac92eaa576014f9d909a2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envlens --version")

    output = shell_output("#{bin}/envlens --definitely-invalid-flag 2>&1", 2)
    assert_match "flag provided but not defined", output
  end
end
