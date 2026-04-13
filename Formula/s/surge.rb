class Surge < Formula
  desc "Blazing fast TUI download manager"
  homepage "https://github.com/surge-downloader/Surge"
  url "https://github.com/surge-downloader/Surge/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "317183ecc2589a407baae10e3e892be4df21171c1bdf0bbc41053f8be910f771"
  license "MIT"
  head "https://github.com/surge-downloader/Surge.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf387558057a0559b587be12c57dbae1676f70675930726768bc3547153e1546"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf387558057a0559b587be12c57dbae1676f70675930726768bc3547153e1546"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf387558057a0559b587be12c57dbae1676f70675930726768bc3547153e1546"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "269d7a1ca9c1feba87f39493e5a60354dfdb5f79f3f7672428e7946dfdeeee0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "127f5d83655dc8992535b00f988fbd1c82f97bd38f81431589c65291fc585f65"
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
