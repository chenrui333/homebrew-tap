class Surge < Formula
  desc "Blazing fast TUI download manager"
  homepage "https://github.com/surge-downloader/Surge"
  url "https://github.com/surge-downloader/Surge/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "317183ecc2589a407baae10e3e892be4df21171c1bdf0bbc41053f8be910f771"
  license "MIT"
  head "https://github.com/surge-downloader/Surge.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22a879910120e78012c06f078a807fdd008bd225c72c3bf47852a2a61b7ef63d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22a879910120e78012c06f078a807fdd008bd225c72c3bf47852a2a61b7ef63d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22a879910120e78012c06f078a807fdd008bd225c72c3bf47852a2a61b7ef63d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b34c9d4a755071419bcf44215afb4f796010e6d1b1d5a6ed233f3dfe992eaa9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e8f00bc6bd5efa83ad24800f9cd836aed0e00993c1dcffb272f0538c670a343"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/SurgeDM/Surge/cmd.Version=#{version}
      -X github.com/SurgeDM/Surge/cmd.BuildTime=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"surge"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surge --version")

    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    ENV["XDG_STATE_HOME"] = testpath/".local/state"
    ENV["XDG_RUNTIME_DIR"] = testpath/".runtime"

    token = shell_output("#{bin}/surge token").strip
    assert_match(/\A[0-9a-f-]{36}\z/, token)

    assert_path_exists testpath/".local/state/surge/token" if OS.linux?
  end
end
