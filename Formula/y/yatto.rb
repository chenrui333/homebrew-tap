class Yatto < Formula
  desc "Interactive VCS-based todo-list for the command-line"
  homepage "https://github.com/handlebargh/yatto"
  url "https://github.com/handlebargh/yatto/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "0b0652d79fbe2ff3708baa768cb5c834aa1d6ef96888371540d1620af208cd7e"
  license "MIT"
  head "https://github.com/handlebargh/yatto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "027ef95fccf1e0cbea90e87eac15f4be91be3a9961a2ce5a912b1aef65d4c211"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "027ef95fccf1e0cbea90e87eac15f4be91be3a9961a2ce5a912b1aef65d4c211"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "027ef95fccf1e0cbea90e87eac15f4be91be3a9961a2ce5a912b1aef65d4c211"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17b0544fd38996486e25e0736359f30a8a9413ae5dc7071e4d910490533c17e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5271cbcefcf8c148ff4f9a9ce62c5781816f31192fbc99e40a8ec34d8ccf55bc"
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
