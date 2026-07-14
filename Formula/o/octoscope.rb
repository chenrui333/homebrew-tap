class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "af7f434edc658f0340012404d408bcd7b0385ce8001a567dc29368739ea5baf8"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b429aee181aa8ddaca5cd0a905b3b1526d843d2bd0606529cc2fe0cae74c29c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b429aee181aa8ddaca5cd0a905b3b1526d843d2bd0606529cc2fe0cae74c29c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b429aee181aa8ddaca5cd0a905b3b1526d843d2bd0606529cc2fe0cae74c29c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24ae29cb4b46b62ee26c8db517c4f3f50e9cb64a7c63e28c5de27c5606252d90"
    sha256 cellar: :any,                 x86_64_linux:  "31359941d9e7f60e8390c80b9f04879a2bcba0f5e0c0616ccac6bb0baff1d601"
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
