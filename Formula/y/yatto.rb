class Yatto < Formula
  desc "Interactive VCS-based todo-list for the command-line"
  homepage "https://github.com/handlebargh/yatto"
  url "https://github.com/handlebargh/yatto/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "1ae4ff38e15638866e6ae72f6457ba6cb68be419fc631ec967e35d266e5a5427"
  license "MIT"
  head "https://github.com/handlebargh/yatto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e50454346552fe5cb9bb24ef06d93fe0e23170df985c4b05007c0a5d3f5188ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e50454346552fe5cb9bb24ef06d93fe0e23170df985c4b05007c0a5d3f5188ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e50454346552fe5cb9bb24ef06d93fe0e23170df985c4b05007c0a5d3f5188ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5be841a7d55aca32533d961c1dee123cbccf658ac81cf00a86e6a23b73d9de19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b006bda269b16835b4b9d84490dfb99360a8766aa920b1d1754ea3ac9fa318ec"
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
