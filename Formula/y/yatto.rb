class Yatto < Formula
  desc "Interactive VCS-based todo-list for the command-line"
  homepage "https://github.com/handlebargh/yatto"
  url "https://github.com/handlebargh/yatto/archive/refs/tags/v0.21.9.tar.gz"
  sha256 "bdfcccd24d50939b950a7f5ffb0a99ef4fb9579cce5de9032db29bfb498842fc"
  license "MIT"
  head "https://github.com/handlebargh/yatto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83cbe91bbc4d5e0daaf52a0fcff078b2f0e02f08f1871163f52cb9b1fac9d5f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83cbe91bbc4d5e0daaf52a0fcff078b2f0e02f08f1871163f52cb9b1fac9d5f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83cbe91bbc4d5e0daaf52a0fcff078b2f0e02f08f1871163f52cb9b1fac9d5f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6198a905166cec1673ce2bf8c5ca22b42f7d4a2ffb43a22c1a7618d33546d2f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d68e78f85d767252aad1dd86bafb5a2ccf5399f673830b2af125abc770f25a91"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/handlebargh/yatto/internal/version.version=#{version}
      -X github.com/handlebargh/yatto/internal/version.revision=#{tap.user}
      -X github.com/handlebargh/yatto/internal/version.revisionDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"yatto", shell_parameter_format: :cobra)
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/yatto version")
    # Version:	(devel)
    # Revision:	chenrui333
    # RevisionDate:	2025-11-17T17:30:31Z
    # GoVersion:	go1.25.4
    system bin/"yatto", "version"

    (testpath/".config/yatto/config.toml").write <<~TOML
      [git]
      default_branch = 'main'

      [git.remote]
      enable = true
      name = 'origin'
      url = 'chenrui333/homebrew-tap'
    TOML
    output = shell_output("#{bin}/yatto config show")
    assert_match "[git]\ndefault_branch = 'main'", output
  end
end
