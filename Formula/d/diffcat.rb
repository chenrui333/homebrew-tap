class Diffcat < Formula
  desc "TUI for visualizing git diffs"
  homepage "https://github.com/trebaud/diffcat"
  url "https://github.com/trebaud/diffcat/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "86dad8196d711478c0cc1d1ddc2d66310b07c5b273c25afb17119d6ea3b66f3a"
  license "MIT"
  head "https://github.com/trebaud/diffcat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d228841ccb9660707757e6f638c962cbe6af53db3bc025b90ff744afcc3e4a97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d228841ccb9660707757e6f638c962cbe6af53db3bc025b90ff744afcc3e4a97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d228841ccb9660707757e6f638c962cbe6af53db3bc025b90ff744afcc3e4a97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2dad803658c356c01d82ac6640c4cce4430e127602da7369898fd56f9488fc4"
    sha256 cellar: :any,                 x86_64_linux:  "c0523740b7aee4b3740b9e86337e60441f859571073f6c61355425474b403144"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.ldflagsVersion=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/diffcat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diffcat --version")
    output = shell_output("#{bin}/diffcat not-a-real-command 2>&1", 1)
    assert_match "not a git repository", output
  end
end
