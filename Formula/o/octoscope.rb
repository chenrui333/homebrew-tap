class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "af7f434edc658f0340012404d408bcd7b0385ce8001a567dc29368739ea5baf8"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6e843d006b62bf0efe3a732a6d43395c105ef2d56df890f72803e437a9f6633"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6e843d006b62bf0efe3a732a6d43395c105ef2d56df890f72803e437a9f6633"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6e843d006b62bf0efe3a732a6d43395c105ef2d56df890f72803e437a9f6633"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71b19e9eae09c7b26f98eb7b9bfc8d77e12d0e481eb66125cf8a42d1399cf3ce"
    sha256 cellar: :any,                 x86_64_linux:  "c4eeb9b666faf9ca477c521d6726bb802b031f2dcc6abd6a3970d92d4fb5986d"
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
