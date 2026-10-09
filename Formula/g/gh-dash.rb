class GhDash < Formula
  desc "Terminal UI for GitHub"
  homepage "https://github.com/dlvhdr/gh-dash"
  url "https://github.com/dlvhdr/gh-dash/archive/refs/tags/v4.26.1.tar.gz"
  sha256 "3e60e3dbd82ff0ea8a040dbde1d0768f1bea5f9bc79e4a6926bc57d8027e399b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91be6093770c0206448153325bd2d59228717319ddcfa524fe06b39178e3b062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91be6093770c0206448153325bd2d59228717319ddcfa524fe06b39178e3b062"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a354e0ecc9a443d8f4619b7e7f071da0a7fe6254fa582e41d58ef8fbe042f64"
    sha256 cellar: :any,                 x86_64_linux:  "5e882644c069f46fd95f08de28c49e35f41005d68956d64e38780005336928bd"
  end

  depends_on "go" => :build
  depends_on "gh"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/dlvhdr/gh-dash/v4/cmd.Version=#{version}
      -X github.com/dlvhdr/gh-dash/v4/cmd.Commit=Homebrew
      -X github.com/dlvhdr/gh-dash/v4/cmd.Date=unknown
      -X github.com/dlvhdr/gh-dash/v4/cmd.BuiltBy=Homebrew
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"gh-dash")
  end

  test do
    output = shell_output("#{bin}/gh-dash one two 2>&1", 1)
    assert_match "Accepts at most 1 arg(s)", output
    assert_match version.to_s, shell_output("#{bin}/gh-dash --version")
  end
end
