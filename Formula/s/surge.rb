class Surge < Formula
  desc "Blazing fast TUI download manager"
  homepage "https://github.com/surge-downloader/Surge"
  url "https://github.com/surge-downloader/Surge/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "952ef5c75e8de4500990de65c1c41305458c76cbdd0c268e6a03eacd03a7c953"
  license "MIT"
  head "https://github.com/surge-downloader/Surge.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f24d95956348d22bfbf47eed7a21c3b09042ab690c4613a28752ddb7c9b643a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f24d95956348d22bfbf47eed7a21c3b09042ab690c4613a28752ddb7c9b643a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f24d95956348d22bfbf47eed7a21c3b09042ab690c4613a28752ddb7c9b643a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b196d19777805b32ebad8c5c98ba268b1a1490909f0cdae04b77fff8c403a709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "539adb4431685809447048606d53dbc556066789e9fa86baf0461552c41a41a4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/surge-downloader/surge/cmd.Version=#{version}
      -X github.com/surge-downloader/surge/cmd.BuildTime=homebrew
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
