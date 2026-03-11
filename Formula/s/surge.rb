class Surge < Formula
  desc "Blazing fast TUI download manager"
  homepage "https://github.com/surge-downloader/Surge"
  url "https://github.com/surge-downloader/Surge/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "96e13de139d80222a5f3e923c05c91ff42bc86391bdf5b31a2eb77a61321d269"
  license "MIT"
  head "https://github.com/surge-downloader/Surge.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56946be5e69d7b56def07573f0c0a831ef60639862a94ca7d64e5e2138b56266"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56946be5e69d7b56def07573f0c0a831ef60639862a94ca7d64e5e2138b56266"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56946be5e69d7b56def07573f0c0a831ef60639862a94ca7d64e5e2138b56266"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5c81a1b234afbda353989c5676c71b114e7715e2f41f57075f6be061f378d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f38f30182cfc9b5152b3a5f0049c5160b47709dead96679f7231b9f9bb97d3d"
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
