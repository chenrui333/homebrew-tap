class Surge < Formula
  desc "Blazing fast TUI download manager"
  homepage "https://github.com/surge-downloader/Surge"
  url "https://github.com/surge-downloader/Surge/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "053b227a19b92a4079f95a64f719ab0a458f7f36a721e68d1ee31df680f992dc"
  license "MIT"
  head "https://github.com/surge-downloader/Surge.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "217f8dcc9c811e2971bc12251f7a7390ef4f9e8518ed53dd87dc46c716518ac2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "217f8dcc9c811e2971bc12251f7a7390ef4f9e8518ed53dd87dc46c716518ac2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "217f8dcc9c811e2971bc12251f7a7390ef4f9e8518ed53dd87dc46c716518ac2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dab2d2d06246ab21cfabf3b6fd1ceadf8bc84a82c3a56f384b51d35ac66f25c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "328fafe04cbdbbe9fa5ae49c6496c4f5a9ed612df24a63c29f3216957dfb687e"
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
